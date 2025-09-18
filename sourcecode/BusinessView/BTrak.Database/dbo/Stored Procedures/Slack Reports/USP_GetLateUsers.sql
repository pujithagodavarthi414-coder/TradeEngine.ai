------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetLateUsers] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetLateUsers]
(
 @Date DATE = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

        IF (@HavePermission = '1')
        BEGIN

        IF(@Date IS NULL)
        SET @Date = DATEADD(DAY,-1,CONVERT(DATE,GETUTCDATE()))
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        DECLARE @LateUsers TABLE(
            [Rank] INT IDENTITY(1,1),
            [Top 5 morning late employees] VARCHAR(500),
            [Morning late reason] VARCHAR(Max),
            [Top 5 afternoon late employees] VARCHAR(500),
            [Top 5 max time spent employees] VARCHAR(500),
            [Least 5 productive employees] VARCHAR(500)
        )
        INSERT INTO @LateUsers([Top 5 morning late employees],[Morning late reason])
        SELECT TOP(5) U.FirstName + ' ' + ISNULL(U.SurName,'') UserFullName,
              PR.ReasonName
        FROM [TimeSheet] TS
              INNER JOIN [User] U ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL
                            INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
                            INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL 
							AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,@Date) 
				            AND (ES.ActiveTo IS NULL OR (ES.ActiveTo IS NOT NULL AND CONVERT(DATE,ES.ActiveTo) > CONVERT(DATE,@Date)))))
                            INNER JOIN ShiftTiming  ST ON ES.ShiftTimingId = ST.Id AND ST.InActiveDateTime IS NULL
                            INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = ST.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,@Date)) 
                            LEFT JOIN [Permission] P ON P.UserId = U.Id AND TS.[Date] = P.[Date] AND P.IsMorning = 1 AND (P.IsDeleted IS NULL OR P.IsDeleted = 0) AND P.InActiveDateTime IS NULL
                            LEFT JOIN [PermissionReason] PR ON PR.Id = P.PermissionReasonId AND PR.InActiveDateTime IS NULL
                            LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ST.Id AND SE.InActiveDateTime IS NULL AND SE.ExceptionDate = @Date
        WHERE U.CompanyId = @CompanyId
             AND SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
             AND TS.[Date] = CAST(@Date AS DATE)
			 --AND CONVERT(TIME,TS.InTime) > CONVERT(TIME,SE.DeadLine)
        ORDER BY DATEDIFF(MINUTE,ISNULL(SE.DeadLine,SW.DeadLine),TS.InTime) DESC

		DECLARE @Id INT = (SELECT MAX([RANK] + 1) FROM @LateUsers)

		WHILE (@Id <= 5)
		BEGIN

			INSERT INTO @LateUsers([Top 5 morning late employees])
			SELECT NULL

			SET @Id = @Id + 1

		END
        UPDATE @LateUsers SET [Top 5 afternoon late employees] = Afternoon.UserFullName
        FROM @LateUsers LU
        JOIN (
        SELECT UserFullName,ROW_NUMBER() OVER(Order BY LateTime DESC,UserFullName) AS Id FROM (
        SELECT TOP(5) U.FirstName + ' ' + ISNULL(U.SurName,'') UserFullName ,DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')) LateTime--,ROW_NUMBER() OVER(ORDER BY U.FirstName + ' ' + ISNULL(U.SurName,'') DESC) AS Id
        FROM [TimeSheet] TS
              INNER JOIN [User] U ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL
                            INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
                            INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
							AND ES.ActiveFrom <= CONVERT(DATE,@Date) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,@Date))
                            INNER JOIN ShiftTiming  ST ON ES.ShiftTimingId = ST.Id AND ST.InActiveDateTime IS NULL
                            LEFT JOIN [Permission] P ON P.UserId = U.Id AND TS.[Date] = P.[Date] AND (P.IsDeleted IS NULL OR P.IsDeleted = 0) AND P.InActiveDateTime IS NULL
                            LEFT JOIN [PermissionReason] PR ON PR.Id = P.PermissionReasonId AND PR.InActiveDateTime IS NULL
        WHERE U.CompanyId = @CompanyId AND 
        DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00'))  > 70
             AND TS.[Date] = CAST(@Date AS DATE)
        ORDER BY TS.InTime DESC) T) Afternoon ON Afternoon.Id = LU.[Rank]
        UPDATE @LateUsers SET [Top 5 max time spent employees] = WorkingHours.UserFullName
        FROM @LateUsers LU
        LEFT JOIN (SELECT UserFullName,ROW_NUMBER() OVER(Order BY TotalSpent DESC,UserFullName) AS Id FROM (
                        SELECT Top(5) U.FirstName + ' ' + ISNULL(U.SurName,'') UserFullName 
                                      , CAST(((ISNULL(TSInner.SpentTimeWithOutBreaks*1.0,0)) 
                                      - ISNULL(UBInner.BreakTime*1.0,0))/60 AS Decimal(10,2)) TotalSpent FROM [User] U 
                    JOIN
                    (SELECT TS.UserId, TS.[Date] ,
                         ((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, '+00:00'), (CASE WHEN @Date = CAST(GETDATE() AS Date) 
                         AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN @Date ELSE SWITCHOFFSET(TS.OutTime, '+00:00') END)),0) - 
                         ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')),0))) AS SpentTimeWithOutBreaks
                            FROM TimeSheet TS
                            JOIN [User] U ON  U.Id = TS.UserId AND U.CompanyId = @CompanyId AND U.IsActive = 1
                            WHERE [Date] = CAST(@Date AS DATE)
                            GROUP BY TS.UserId,TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime,
                        TS.InTime,TS.OutTime) TSInner ON TSInner.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = @CompanyId
                        LEFT JOIN
                        (SELECT SUM(DATEDIFF(MINUTE, UB.BreakIn, UB.BreakOut)) BreakTime,UB.UserId,UB.[Date]
                        FROM UserBreak UB
                        JOIN [User] U ON  U.Id = UB.UserId AND U.CompanyId = @CompanyId AND U.IsActive = 1
                        WHERE ([Date] = CAST(@Date AS DATE))
                        GROUP BY UB.UserId,UB.[Date]) UBInner ON UBInner.UserId = U.Id 
                        ORDER BY TotalSpent Desc) T
        ) WorkingHours ON WorkingHours.Id = LU.[Rank]
        UPDATE @LateUsers SET [Least 5 productive employees] = Productivity.UserName
        FROM @LateUsers LU
        LEFT JOIN (SELECT UserName,ROW_NUMBER() OVER(Order BY ProductivityVal ASC,UserName) AS Id FROM (
                        SELECT TOP 5 Sum(ProductivityIndex) ProductivityVal,UserName FROM [Ufn_ProductivityIndexofAnIndividual](DATEADD(DAY,-30,CONVERT(DATE,GETUTCDATE())),CONVERT(DATE,GETUTCDATE()),Null,@CompanyId)
        WHERE ProductivityIndex <> 0
        GROUP BY UserName ORDER BY ProductivityVal ASC) T
        ) Productivity ON Productivity.Id = LU.[Rank]
        SELECT * FROM @LateUsers
    END

	END TRY
    BEGIN CATCH
        THROW
    END CATCH
END