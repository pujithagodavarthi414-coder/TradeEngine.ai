---------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2019-02-11 00:00:00.000'
-- Purpose      To Get the logtime report for a month by applying different filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_MonthlyLogReports_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@SearchText='01-Jan'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_MonthlyLogReports_New]
(
   @SelectedDate DATETIME = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @LineManagerId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @SearchText VARCHAR(500) = NULL,
   @SortBy NVARCHAR(250) = NULL,
   @SortDirection NVARCHAR(50) = NULL,
   @PageNumber INT = NULL,
   @EntityId UNIQUEIDENTIFIER = NULL,
   @PageSize INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
              
    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
    
    IF (@HavePermission = '1')
    BEGIN

        IF(@SortDirection IS NULL )
        BEGIN
            SET @SortDirection = 'DESC'
        END
            IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
        DECLARE @OrderByColumn NVARCHAR(250) 
        IF(@SortBy IS NULL)
        BEGIN
            SET @SortBy = 'DeployedDateTime'
        END
        ELSE
        BEGIN
            SET @SortBy = @SortBy
        END
            
        IF(@PageNumber IS NULL) SET @PageNumber = 1

        IF(@PageSize IS NULL) SET @PageSize = 2147483647

        SET @SearchText = '%'+ @SearchText +'%'

        DECLARE @CompanyId UNIQUEIDENTIFIER =  (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
            
        DECLARE @CompliantHours NUMERIC(10,3) = ISNULL((SELECT CAST(REPLACE([Value], 'h', '' ) AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like '%SpentTime%' AND [CompanyId] = @CompanyId),0)
              
            CREATE TABLE #MonthlyLogReport
             (
                 UserId UNIQUEIDENTIFIER NOT NULL,
                 UserName NVARCHAR(800),
                 [Date] DATETIME,
                 SpentTime INT,
                 LogTime INT,
                 SummaryValue INT,
                 Summary NVARCHAR(800),
                 IsAbsent BIT,
                 InTime TIME
             )
        DECLARE @DateFrom DATETIME = NULL            
        DECLARE @DateTo DATETIME = NULL
        IF(@SelectedDate IS NULL) SET @SelectedDate = CAST(GETDATE() AS DATE)
        SET @DateFrom = DATEADD(mm, DATEDIFF(mm, 0, @SelectedDate), 0)          
        SET @DateTo = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @SelectedDate) + 1, 0))
        IF (@BranchId = '00000000-0000-0000-0000-000000000000')
        BEGIN
        SET @BranchId = NULL
        END
        IF (@LineManagerId = '00000000-0000-0000-0000-000000000000')
        BEGIN
            SET @LineManagerId = NULL
        END
            
        INSERT INTO #MonthlyLogReport(UserId,UserName,[Date])
            SELECT  UserTable.Id,UserTable.FullName,DateTable.[Date]
            FROM (
             SELECT DATEADD(DAY,number,@DateFrom) [Date] FROM
             master..spt_values
             WHERE type = 'p' AND number BETWEEN 0 AND DATEDIFF(DAY,@DateFrom,@DateTo)) DateTable
            ,(SELECT U.Id,ISNULL(FirstName,'') + ' ' + ISNULL(SurName,'') AS FullName
              FROM [User] U 
              JOIN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](ISNULL(@LineManagerId,@OperationsPerformedBy),@CompanyId) GROUP BY ChildId)ERT ON ERT.ChildId = U.Id 
              AND U.InActiveDateTime IS NULL AND U.IsActive = 1 
              --INNER JOIN UserActiveDetails UAD ON UAD.UserId = U.OriginalId AND UAD.AsAtInActiveDateTime IS NULL
              INNER JOIN Employee E ON E.UserId  = U.Id AND E.InActiveDateTime IS NULL
              INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
                      AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                      AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
              INNER JOIN Job J ON J.EmployeeId = E.Id AND J.InActiveDateTime IS NULL
              WHERE (J.JoinedDate BETWEEN @DateFrom AND @DateTo OR @DateFrom >= J.JoinedDate) 
                  --AND (@DateFrom <= UAD.ActiveTo OR UAD.ActiveTo IS NULL)
                  AND (CompanyId = @CompanyId)
              GROUP BY U.Id,FirstName,SurName) AS UserTable
        
        UPDATE #MonthlyLogReport 
        SET LogTime = CEILING(ISNULL(MLRInner.SpentTime,0)), 
        SpentTime = (ISNULL(MLRInner1.SpentTime,0) - ISNULL(UBInner.BreakTime,0))/60
        ,SummaryValue = CASE WHEN H.[Date] IS NOT NULL AND SW.Id IS NOT NULL AND (ISNULL(MLRInner1.SpentTime,0) - ISNULL(UBInner.BreakTime,0))/60 = 0 THEN 0
		                    WHEN (MLR.[Date] > GETDATE() OR MLR.[Date] < J.JoinedDate) THEN 5
                            WHEN SW.Id IS NULL AND (ISNULL(MLRInner1.SpentTime,0) - ISNULL(UBInner.BreakTime,0))/60 = 0 THEN 1
                            
                            WHEN @CompliantHours <> 0 
                                 THEN CASE WHEN ((ISNULL(MLRInner1.SpentTime,0) - ISNULL(UBInner.BreakTime,0))/60 * 1.0) >= @CompliantHours
                                                 AND CEILING(ISNULL(MLRInner.SpentTime,0)) >= @CompliantHours THEN 2
                                            WHEN ((ISNULL(MLRInner1.SpentTime,0) - ISNULL(UBInner.BreakTime,0))/60 * 1.0) < @CompliantHours
                                                 AND CEILING(ISNULL(MLRInner.SpentTime,0)) >= (((ISNULL(MLRInner1.SpentTime,0) - ISNULL(UBInner.BreakTime,0))/60 * 1.0) * 0.9) /* 90 Percent of office spent time*/ THEN 2
                                            ELSE 3 END
                            WHEN CEILING(ISNULL(MLRInner.SpentTime,0)) >= (((ISNULL(MLRInner1.SpentTime,0) - ISNULL(UBInner.BreakTime,0))/60 * 1.0) * 0.9) THEN 2  
                            ELSE 3 END 
        FROM #MonthlyLogReport MLR 
        LEFT JOIN (SELECT OwnerUserId,CONVERT(DATE,ISNULL(UST.DateTo,ISNULL(UST.EndTime,GETDATE()))) [Date],(ISNULL(SUM(SpentTimeInMin)/60,0)) + (ISNULL(
						 (SUM(DATEDIFF(MINUTE, UST.StartTime, ISNULL(UST.EndTime,GETDATE())))/60.0),0)) SpentTime
                    FROM UserStory US JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
                    AND US.OwnerUserId = UST.CreatedByUserId 
                    WHERE ((CONVERT(DATE,UST.DateTo) <= @DateTo) AND (CONVERT(DATE,UST.DateTo) >= @DateFrom) OR (CONVERT(DATE,UST.EndTime) <= @DateTo) AND (CONVERT(DATE,UST.StartTime) >= @DateFrom))
                    GROUP BY OwnerUserId,CONVERT(DATE,ISNULL(UST.DateTo,ISNULL(UST.EndTime,GETDATE())))) MLRInner ON MLRInner.OwnerUserId = MLR.UserId AND MLRInner.[Date] = MLR.[Date] 
        LEFT JOIN (SELECT UserId, [Date],((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, '+00:00'), (CASE WHEN [Date] = CAST(GETDATE() AS DATE) 
	                    AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETUTCDATE() WHEN [Date] <> CAST(GETDATE() AS DATE) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN DATEADD(HH,CAST((SELECT TOP 1 LTRIM(RTRIM([Value])) FROM CompanySettings WHERE CompanyId = @CompanyId AND [Key] = 'MaximumWorkingHours') AS INT),SWITCHOFFSET(TS.InTime, '+00:00'))
						ELSE SWITCHOFFSET(TS.OutTime, '+00:00') END)),0) - 
	                    ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')),0))) SpentTime
                    FROM TimeSheet TS
                    WHERE [Date] BETWEEN @DateFrom AND @DateTo) MLRInner1 ON MLRInner1.UserId = MLR.UserId AND MLRInner1.[Date] = MLR.[Date]
        LEFT JOIN (SELECT SUM(DATEDIFF(MINUTE, SWITCHOFFSET(UB.BreakIn, '+00:00'), SWITCHOFFSET(UB.BreakOut, '+00:00'))) BreakTime,UB.UserId,UB.[Date] 
                    FROM UserBreak UB
                    WHERE [Date] BETWEEN @DateFrom AND @DateTo
                    GROUP BY UB.UserId,UB.[Date]) UBInner  ON UBInner.UserId = MLR.UserId AND UBInner.[Date] = MLR.[Date]
        JOIN Employee E ON E.UserId = MLR.UserId
        JOIN Job J ON J.EmployeeId = E.Id
        LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((MLR.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (ES.ActiveFrom <= MLR.[Date] AND ES.ActiveTo IS NULL))
        LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,MLR.[Date]) = SW.[DayOfWeek]
        LEFT JOIN Holiday H ON H.[Date] = MLR.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId
        
        UPDATE #MonthlyLogReport SET Summary = CASE WHEN SummaryValue IN (2,3) THEN (UserName+' (Log Time :' +  CAST(LogTime AS NVARCHAR(100)) + ', SpentTime :' + CAST(SpentTime AS NVARCHAR(100)) + ') ')
                                                         WHEN SummaryValue = 1 THEN 'Week Off'
                                                         WHEN SummaryValue = 0 THEN 'Holiday' 
                                                         WHEN SummaryValue = 5 THEN 'Future Day' 
                                                    END
        
        UPDATE #MonthlyLogReport SET SummaryValue = (CASE WHEN ((ToLeaveSessionId = (SELECT Id FROM LeaveSession WHERE IsFirstHalf = 1 AND CompanyId = @CompanyId) AND LA.LeaveDateTo = MLR.[Date]) OR (LA.LeaveDateFrom = MLR.[Date] AND IsSecondHalf = 1)) THEN 8
                                                              WHEN MasterLeaveTypeId = (SELECT MLT.Id FROM MasterLeaveType MLT WHERE MLT.IsSickLeave = 1) THEN 4 
                                                              WHEN MasterLeaveTypeId = (SELECT MLT.Id FROM MasterLeaveType MLT WHERE MLT.IsCasualLeave = 1) THEN 4 
                                                              WHEN MasterLeaveTypeId = (SELECT MLT.Id FROM MasterLeaveType MLT WHERE MLT.IsWithoutIntimation = 1) THEN 7 ELSE 6 END)
                            FROM #MonthlyLogReport MLR
                            JOIN Employee E ON E.UserId = MLR.UserId
                            LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((MLR.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (ES.ActiveFrom < MLR.[Date] AND ES.ActiveTo IS NULL))
                            LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,MLR.[Date]) = SW.[DayOfWeek]
                            LEFT JOIN Holiday H ON H.[Date] = MLR.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId
                            LEFT JOIN [dbo].[LeaveApplication]LA WITH (NOLOCK) ON LA.UserId = MLR.UserId
                            LEFT JOIN [dbo].[LeaveType] LT ON LT.Id = LA.LeaveTypeId
                            LEFT JOIN LeaveSession LS ON LS.Id = LA.FromLeaveSessionId 
                            WHERE  MLR.[Date] BETWEEN LA.LeaveDateFrom AND LA.LeaveDateTo
                                  AND ((ISNULL(LT.IsIncludeHolidays,0) = 0 AND H.[Date] IS NULL AND SW.Id IS NOT NULL)
                                   OR (LT.IsIncludeHolidays = 1))
                                  AND LA.OverallLeaveStatusId = (SELECT Id FROM LeaveStatus WHERE IsApproved = 1 AND CompanyId = @CompanyId)                          
        
        SELECT  UserId,  
                UserName AS EmployeeName,
                [Date],
                SpentTime,
                LogTime,
                SummaryValue,
                Summary 
        FROM #MonthlyLogReport
        WHERE (@SearchText IS NULL 
                    OR UserName LIKE @SearchText
                    OR (SUBSTRING(CONVERT(VARCHAR, [Date], 106),1,2) + '-'
                                                  + SUBSTRING(CONVERT(VARCHAR, [Date], 106),4,3) + '-'
                                                  + CONVERT(VARCHAR,DATEPART(YEAR,[Date])) LIKE @SearchText))
        ORDER BY 
        CASE WHEN @SortDirection = 'ASC' THEN
            CASE WHEN @SortBy = 'Employee Name' THEN UserName
                WHEN @SortBy = 'Dates' THEN [Date]
                WHEN @SortBy = 'Spent Time' THEN SpentTime
                WHEN @SortBy = 'Log Time' THEN LogTime
                WHEN @SortBy = 'Summary' THEN Summary
            END 
        END ASC,
        CASE WHEN @SortDirection = 'DESC' THEN
            CASE WHEN @SortBy = 'Employee Name' THEN UserName
                WHEN @SortBy = 'Dates' THEN [Date]
                WHEN @SortBy = 'Spent Time' THEN SpentTime
                WHEN @SortBy = 'Log Time' THEN LogTime
                WHEN @SortBy = 'Summary' THEN Summary
            END 
        END DESC
        OFFSET ((@PageNumber - 1) * @PageSize) ROWS 
                         
        FETCH NEXT @PageSize ROWS ONLY

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
GO
