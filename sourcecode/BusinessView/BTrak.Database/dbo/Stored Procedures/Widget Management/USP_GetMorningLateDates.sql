--EXEC [dbo].[USP_GetMorningLateDates] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@UserId='0B2921A9-E930-4013-9047-670B5352F308'
CREATE PROCEDURE [dbo].[USP_GetMorningLateDates]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @UserId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
              
     IF (@HavePermission = '1')
     BEGIN
     
        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        
		IF(@UserId IS NULL)
		   BEGIN
				SET @UserId = @OperationsPerformedBy;
		   END

        DECLARE @JoiningDate DATETIME = (SELECT ISNULL(J.JoinedDate,U.RegisteredDateTime)
										 FROM  Employee E
										 INNER JOIN [User] U ON U.Id = E.UserId AND U.Id = @UserId
										 LEFT JOIN [Job] J ON J.EmployeeId = E.Id
										 WHERE J.InActiveDateTime IS NULL)
        
        DECLARE @DateFrom DATETIME = @JoiningDate
        
        DECLARE @DateTo DATETIME = GETDATE()
        
        IF(DATEDIFF(YEAR,@DateFrom,@DateTo) > 5) SET @DateFrom = DATEADD(YEAR,-5,@DateTo)

        SET @DateFrom = CONVERT(DATE,@DateFrom)
        SET @DateTo = CONVERT(DATE,@DateTo)

        DECLARE @LeaveApprovedId UNIQUEIDENTIFIER = (SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId)

        CREATE TABLE #Temp
        (
        [Date] DATETIME
        )
        INSERT INTO #Temp ([Date])
        SELECT DATEADD(DAY,number+0,@DateFrom) [Date]
        FROM master..spt_values
        WHERE type = 'P'
        AND number <= DATEDIFF(DAY,@DateFrom,@DateTo)
        
		SELECT  T.[Date]
               ,CASE WHEN TInner.[Date] IS NOT NULL 
                   THEN CASE WHEN TInner.MorningLate = 1
                             THEN 1 ELSE 2
                        END 
              WHEN LA.Id IS NOT NULL THEN 3
              WHEN H.Id IS NOT NULL THEN 4
              ELSE 0 END AS MorningLate
             ,CASE WHEN TInner.[Date] IS NOT NULL 
                   THEN CASE WHEN TInner.LunchBreakLate = 1
                             THEN 1 ELSE 2
                        END 
              WHEN LA.Id IS NOT NULL THEN 3
              WHEN H.Id IS NOT NULL THEN 4
              ELSE 0 END AS LunchBreakLate
        ,TInner.LunchBreakStartTime,TInner.LunchBreakEndTime
        FROM #Temp T
        LEFT JOIN (SELECT TS.[Date] AS Date
        ,CASE WHEN SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.DeadLine, SW.Deadline) AS DATETIME)) 
                             THEN 1 ELSE 0
                        END AS MorningLate
        ,CASE WHEN ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')),0) >= 71
                             THEN 1 ELSE 0
                        END AS LunchBreakLate
		,TS.LunchBreakStartTime
		,TS.LunchBreakEndTime
        From [User] U
        INNER JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id AND E.InactiveDateTime IS NULL AND U.InactiveDateTime IS NULL
        LEFT JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id  AND TS.InActiveDateTime IS NULL
        LEFT JOIN EmployeeShift ES WITH (NOLOCK) ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
		          AND ( (ES.ActiveTo IS NOT NULL AND TS.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo)
			          OR (ES.ActiveTo IS NULL AND TS.[Date] >= ES.ActiveFrom)
					  OR (ES.ActiveTo IS NOT NULL AND TS.[Date] <= ES.ActiveTo)
				  )
        LEFT JOIN ShiftTiming ST WITH (NOLOCK) ON ST.Id = ES.ShiftTimingId 
        --LEFT JOIN UserActiveDetails UAD WITH (NOLOCK) ON UAD.UserId = U.Id 
        LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ST.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,TS.[Date])) AND  SW.InActiveDateTime IS NULL
        LEFT JOIN ShiftException SE ON SE.ShiftTimingId = ST.Id AND  SE.InActiveDateTime IS NULL AND CONVERT(DATE,TS.[Date]) = CONVERT(DATE,SE.ExceptionDate)
        WHERE U.Id = @UserId 
        AND U.CompanyId = @CompanyId 
        AND TS.[Date] BETWEEN @DateFrom AND @DateTo
        --AND (SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.[Date] AS DATETIME) + CAST(ISNULL(SE.DeadLine, SW.Deadline) AS DATETIME))
        --OR ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')),0) >= 71)
        )TInner ON TInner.[Date] = CONVERT(DATE,T.[Date])
        LEFT JOIN LeaveApplication LA ON T.[Date] BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo AND LA.UserId = @UserId
                           AND LA.OverallLeaveStatusId = @LeaveApprovedId
        LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.CompanyId = @CompanyId  
		ORDER BY T.[Date] DESC
    END
      ELSE
      BEGIN
              
        RAISERROR (@HavePermission,11, 1)
                    
     END 
     END TRY
   BEGIN CATCH
       
       THROW
   END CATCH 
END