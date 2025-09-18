-------------------------------------------------------------------------------
-- Author       Sudha Goli
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get the Timesheet Details By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved select * from TimeSheet 
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetTimesheetDetails] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@Datefrom = '2020-01-01',@DateTo = '2020-01-31',@IncludeEmptyRecords = 0,@PageSize = 100,@SortDirection = 'ASC',@SortBy = 'InTime',@UserId = '0B2921A9-E930-4013-9047-670B5352F308'
------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetTimesheetDetails] 
(
    @UserId UNIQUEIDENTIFIER = NULL,
    @DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @PageNumber INT = 1,
    @PageSize INT = 10,
    @SearchText VARCHAR(500) = NULL,
	@EmployeeSearchText VARCHAR(500) = NULL,
    @SortBy NVARCHAR(250) = NULL,
    @SortDirection NVARCHAR(50) = NULL,
    @BranchId UNIQUEIDENTIFIER = NULL,
    @EntityId UNIQUEIDENTIFIER = NULL,
    @TeamLeadId UNIQUEIDENTIFIER = NULL,
    @IncludeEmptyRecords BIT = 0
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

     DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
  
     IF (@HavePermission = '1')
     BEGIN
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   DECLARE @Time DATETIME = GETUTCDATE()
           
           IF(@UserId = '00000000-0000-0000-0000-000000000000') SET  @UserId = NULL
           
           IF(@DateFrom IS NULL) SET  @DateFrom = CONVERT(DATE,GETDATE())
           
           IF(@DateTo IS NULL) SET  @DateTo = CONVERT(DATE,GETDATE())

           IF(@UserId = '00000000-0000-0000-0000-000000000000') SET  @UserId = NULL
           
           IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET  @BranchId = NULL
           
           IF(@TeamLeadId = '00000000-0000-0000-0000-000000000000') SET  @TeamLeadId = NULL
           
           IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET  @EntityId = NULL

		   DECLARE @MaxOfficeWorkingHours AS INT

		   SET @MaxOfficeWorkingHours = (SELECT TOP 1 LTRIM(RTRIM([Value])) FROM CompanySettings WHERE CompanyId = (SELECT CompanyId FROM [User] U WHERE U.Id = @OperationsPerformedBy) AND [Key] = 'MaximumWorkingHours')
          
           DECLARE @CanViewAllEmployees BIT = (CASE WHEN EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) 
		                                                        AND FeatureId IN(SELECT TOP 1 Id FROM Feature WHERE FeatureName = 'View activity reports for all employee') AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)          
		   DROP TABLE IF EXISTS #Employees   
           CREATE TABLE #Employees(EmployeeId UNIQUEIDENTIFIER)

		   IF(@CanViewAllEmployees = 1)
		   BEGIN
		    INSERT INTO #Employees(EmployeeId)
		    SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy)
		   END
           ELSE
		   BEGIN
		       INSERT INTO #Employees(EmployeeId)
		    SELECT EmployeeId FROM [dbo].[Ufn_GetEmployeeBranchReportedMembers](@OperationsPerformedBy, @CompanyId)
		   END

           IF(@SortDirection IS NULL )
           BEGIN
           
                SET @SortDirection = 'DESC'
           
           END

           IF(@SortBy IS NULL) SET @SortBy = 'Date'

		   --DECLARE @CurrentDate DATETIME = GETUTCDATE()

     IF (@EmployeeSearchText = '') SET @EmployeeSearchText = NULL
           
     IF(@IncludeEmptyRecords IS NULL) SET @IncludeEmptyRecords = 0

           DECLARE @OrderByColumn NVARCHAR(250) 
     
           SET @SearchText = '%'+ @SearchText+'%'

     SET @EmployeeSearchText = '%'+ @EmployeeSearchText + '%'

        CREATE TABLE #DateTable
           (
                Datevalue DATETIME,
				UserId UNIQUEIDENTIFIER,
				ActiveTimeInMin INT,
				TotalIdleTime INT,
				ProductiveTimeInMin INT,
				LoggedTime INT,
				Screenshots INT
           )
           INSERT INTO #DateTable(Datevalue,UserId)
           SELECT DATEADD(DAY, number, @DateFrom),U.Id
           FROM MASTER..SPT_VALUES M CROSS JOIN (SELECT U.Id,U.RegisteredDateTime,J.JoinedDate,U.InActiveDateTime FROM [User] U 
     JOIN Employee E ON E.UserId = U.Id AND U.CompanyId = @CompanyId
	 JOIN #Employees TE ON TE.EmployeeId = E.Id AND (@UserId IS NULL OR E.UserId = @UserId)
     LEFT JOIN Job J ON J.EmployeeId = E.Id --AND (U.InActiveDateTime IS NULL OR (U.InActiveDateTime BETWEEN @DateFrom AND @DateTo))
	 ) U 
                    WHERE TYPE = 'p' AND number<= DATEDIFF(DAY,@DateFrom,@DateTo) 
                      AND ISNULL(U.JoinedDate,U.RegisteredDateTime) <= DATEADD(DAY, number, @DateFrom) 
                      AND  (DATEADD(DAY, number, @DateFrom) <= U.InActiveDateTime OR U.InActiveDateTime IS NULL)
---*Leaves list begin
           CREATE TABLE #Leaves
           (
           UserId UNIQUEIDENTIFIER, 
           LeaveDateFrom DATETIME,
           LeaveDateTo DATETIME,
           LeaveAppliedDate DATETIME,
           LeaveReason NVARCHAR(1000),
           ToLeaveSessionId UNIQUEIDENTIFIER,
           LeaveTypeId UNIQUEIDENTIFIER,
           LeaveTypeName  NVARCHAR(1000),
           LeaveSessionName  NVARCHAR(1000),
		   LeaveStatus NVARCHAR(250),
		   IsApproved BIT,
		   IsRejected BIT,
		   IsWaitingForApproval BIT,
		   LeaveStatusColour NVARCHAR(250)
           )
           
           INSERT INTO #Leaves
           SELECT LA.UserId, LA.LeaveDateFrom,LA.LeaveDateTo,LA.LeaveAppliedDate,LA.LeaveReason,LA.ToLeaveSessionId,LA.LeaveTypeId,
                             LT.LeaveTypeName, CONCAT((SELECT LeaveSessionName FROM LeaveSession WHERE Id = LA.FromLeaveSessionId),'') AS LeaveSessionName,LST.LeaveStatusColour,LST.IsApproved,LST.IsRejected,LST.IsWaitingForApproval,LST.LeaveStatusColour
                             FROM  [LeaveApplication] LA 
                                   JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId 
                                   JOIN LeaveSession LS ON LS.Id = LA.ToLeaveSessionId 
                 JOIN LeaveStatus LST ON LA.OverallLeaveStatusId = LST.Id
                             WHERE ((LeaveDateFrom BETWEEN @DateFrom AND @DateTo) 
           				      OR (LeaveDateTo BETWEEN @DateFrom AND @DateTo)) 
           				      --OR (@DateFrom BETWEEN LeaveDateFrom AND LeaveDateTo)  
           				      --OR (@DateTo BETWEEN LeaveDateFrom AND LeaveDateTo))
                                 AND LA.InActiveDateTime IS NULL 
                                 AND (@UserId IS NULL OR LA.UserId = @UserId)
								 AND LA.UserId IN (SELECT E1.UserId FROM #Employees E INNER JOIN Employee E1 ON E1.Id = E.EmployeeId)
       --AND (U.InActiveDateTime IS NULL OR U.InActiveDateTime > @DateFrom)
----* Leaves end

           UPDATE #DateTable SET  ActiveTimeInMin = ISNULL(T.ActiveTimeInMin,0)
                                 ,TotalIdleTime = ISNULL(T.IdleInMinutes,0)
                                 ,ProductiveTimeInMin = ISNULL(T.Productive,0)
   FROM #DateTable ATT
   LEFT JOIN ( SELECT UserId,CreatedDateTime
                      ,SUM(Productive)/60000 AS Productive
                      ,SUM(IdleInMinutes) AS IdleInMinutes
                      ,SUM(Productive + Neutral + UnProductive) / 60000  AS ActiveTimeInMin
                  FROM UserActivityTimeSummary UAH
                  WHERE UAH.CreatedDateTime BETWEEN @DateFrom AND @DateTo
                        AND UAH.CompanyId = @CompanyId
                GROUP BY UserId,CreatedDateTime
              ) T ON T.UserId = ATT.UserId AND T.CreatedDateTime = ATT.Datevalue

   UPDATE #DateTable SET LoggedTime = ISNULL(T.TotalTime,0)
   FROM #DateTable ATT
   LEFT JOIN (SELECT UM.Id AS UserId,CAST(UAT.CreatedDateTime AS date) AS CreatedDateTime, SUM(SpentTimeInMin) AS TotalTime
                       --,CEILING(SUM(( DATEPART(HH, UAT.SpentTime) * 3600000 ) + (DATEPART(MI, UAT.SpentTime) * 60000 ) + DATEPART(SS, UAT.SpentTime)*1000  + DATEPART(MS, UAT.SpentTime)) * 1.0 / 60000 * 1.0) AS TotalTime
                        FROM [User] AS UM
                           INNER JOIN (SELECT UserId,CONVERT(DATE, CreatedDateTime) AS CreatedDateTime, ROUND(DATEDIFF(MILLISECOND, UA.StartTime, UA.EndTime ) * 1.0 / 60000 * 1.0, 1) AS SpentTimeInMin
											--CEILING(DATEDIFF(MILLISECOND, UA.StartTime, UA.EndTime ) * 1.0 / 60000 * 1.0) AS SpentTimeInMin
                                          FROM UserStorySpentTime AS UA 
                                          WHERE CONVERT(DATE, UA.CreatedDateTime) BETWEEN CONVERT(DATE, @DateFrom) AND CONVERT(DATE, @DateTo)
                                                AND UA.InActiveDateTime IS NULL AND UA.StartTime IS NOT NULL AND UA.EndTime IS NOT NULL
                                          UNION ALL
										  SELECT UserId,CONVERT(DATE, DateTo) AS CreatedDateTime,SpentTimeInMin
										  FROM UserStorySpentTime UAH
 										  WHERE CONVERT(DATE, UAH.DateTo) BETWEEN CONVERT(DATE, @DateFrom) AND CONVERT(DATE, @DateTo)
												AND UAH.StartTime IS NULL
                                        ) UAT ON UAT.UserId = UM.Id
                        GROUP BY UM.Id,UAT.CreatedDateTime
                       ) T ON T.UserId = ATT.UserId AND CONVERT(DATE, T.CreatedDateTime) = CONVERT(DATE, ATT.Datevalue)

	UPDATE #DateTable SET Screenshots = ISNULL(T.ScreenshotCount, 0)
	FROM #DateTable ATT
	LEFT JOIN (	SELECT DISTINCT COUNT(1) AS ScreenshotCount, U.Id AS UserId, A.CreatedDateTime
							FROM ActivityScreenShot AS A
							LEFT JOIN [User] AS U ON U.Id = A.UserId 
							WHERE (CONVERT(DATE,A.CreatedDateTime)) BETWEEN CONVERT(DATE,@DateFrom)
							AND CONVERT(DATE,@DateTo)
							AND A.CreatedDateTime IS NOT NULL
								AND U.CompanyId = @CompanyId
							GROUP BY U.Id, A.CreatedDateTime
							) T ON T.UserId = ATT.UserId AND CONVERT(DATE, T.CreatedDateTime) = CONVERT(DATE, ATT.Datevalue)
  
           SELECT T.*,
                 (SELECT CONVERT(NVARCHAR(50),UB.BreakIn) BreakIn,
                         CONVERT(NVARCHAR(50),UB.BreakOut) BreakOut,
						(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = UB.BreakInTimeZone)  BreakInAbbreviation,
						 (SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = UB.BreakOutTimeZone)  BreakOutAbbreviation,
						 (SELECT TimeZoneName FROM TimeZone WHERE Id = UB.BreakInTimeZone)  BreakInTimeZone,
						  (SELECT TimeZoneName FROM TimeZone WHERE Id = UB.BreakOutTimeZone)  BreakOutTimeZone,
                         CAST(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn,'+00:00'),SWITCHOFFSET( BreakOut ,'+00:00'))/60 AS VARCHAR(50)) + 'h ' + CAST(DATEDIFF(MINUTE, SWITCHOFFSET(BreakIn ,'+00:00'),SWITCHOFFSET( BreakOut ,'+00:00'))%60 AS VARCHAR(50)) + 'm' BreakDifference,
                         DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn,'+00:00'),SWITCHOFFSET( BreakOut ,'+00:00')) BreakInMin
                  FROM [UserBreak] UB WITH (NOLOCK)
                  WHERE UserId = T.UserId AND CAST([Date] AS DATE) = T.[Date]
                  ORDER BY SWITCHOFFSET( UB.BreakIn ,'+00:00')
                  FOR JSON PATH,Root('Breaks')) AS UserBreaks,
				 UserBreaksCount = (SELECT COUNT(1) FROM [UserBreak] UB WITH (NOLOCK) WHERE UserId = T.UserId AND CAST([Date] AS DATE) = T.[Date]),
				 UsersBreakTime = (SELECT CAST(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn ,'+00:00'),SWITCHOFFSET( BreakOut ,'+00:00')))/60 AS VARCHAR(50)) + 'h ' + CAST(SUM(DATEDIFF(MINUTE, SWITCHOFFSET(BreakIn ,'+00:00'),SWITCHOFFSET( BreakOut ,'+00:00')))%60 AS VARCHAR(50)) + 'm' 
				 FROM [UserBreak] UB WITH (NOLOCK) WHERE UserId = T.UserId AND BreakOut IS NOT NULL AND CAST([Date] AS DATE) = T.[Date]),
                 L.LeaveDateFrom,
                 L.LeaveAppliedDate,
				 L.LeaveReason,
				 L.LeaveStatusColour AS LeaveStatusColor,
                 L.ToLeaveSessionId,
                 L.LeaveTypeId,
                 T.CountOfUserBreak,
                 L.LeaveTypeName,
                 L.LeaveSessionName,
				 L.IsApproved,
				 L.IsRejected,
				 L.IsWaitingForApproval,
				IIF(OutTime IS NULL,

      IIF((DATEDIFF(MINUTE,SWITCHOFFSET(InTime,'+00:00'),GETUTCDATE()) - (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0))  ) / 60  >= @MaxOfficeWorkingHours,CONVERT(NVARCHAR(5),@MaxOfficeWorkingHours) + 'h',
     (CAST(((DATEDIFF(MINUTE,SWITCHOFFSET(InTime,'+00:00'),GETUTCDATE()) - (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0)))  / 60 ) AS VARCHAR(50)) + 'h ' + 
     CAST(((DATEDIFF(MINUTE,SWITCHOFFSET(InTime,'+00:00'),GETUTCDATE()) - (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0)) )  % 60 ) AS VARCHAR(50)) + 'm'))
     
     ,CAST((DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00'))- (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0)))/60 AS VARCHAR(50)) + 'h ' +
     CAST((DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00'))- (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0)))%60 AS VARCHAR(50)) + 'm') SpentTimeDiff,
 IIF(T.TimingId IS NOT NULL AND ISNULL(T.BreakAllowance,0) < T.CountOfUserBreak,1,0) AS IsBreaksBold,
                 TotalCount = COUNT(1) OVER() 
          FROM (SELECT TS.Id TimeSheetId
					   ,U.Id UserId
                       ,DT.Datevalue [Date]
                       ,U.IsAdmin 
                       ,DT.ActiveTimeInMin AS ActiveTimeInMin
                       ,DT.ActiveTimeInMin + DT.TotalIdleTime AS TotalActiveTimeInMin
					   ,DT.ProductiveTimeInMin AS ProductiveTimeInMin
					   ,DT.TotalIdleTime AS TotalIdleTime
					   ,DT.LoggedTime AS LoggedTime
					   ,DT.Screenshots AS Screenshots
					   ,U.RegisteredDateTime
                       ,ES.ShiftTimingId TimingId
                       ,TS.[Date] TimesheetDate
                       ,U.FirstName + ' '+ ISNULL(U.SurName,'') EmployeeName
					   ,CASE WHEN TS.InTime IS NOT NULL AND TS.InTimeTimeZone IS NOT NULL THEN TS.InTimeTimeZone ELSE U.TimeZoneId END TimeZoneId
                       ,U.ProfileImage AS UserProfileImage
                        --@TeamLeadId TeamLeadId
                       ,TS.LunchBreakEndTime
                       ,TS.LunchBreakStartTime
                       ,TS.InTime AS InTime
					   ,(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = TS.InTimeTimeZone)  InTimeAbbreviation
					   ,(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = TS.OutTimeTimeZone) OutTimeAbbreviation
					   ,(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = TS.LunchBreakStartTimeZone)  LunchStartAbbreviation
					   ,(SELECT TimeZoneAbbreviation FROM TimeZone WHERE Id = TS.LunchBreakEndTimeZone)  LunchEndAbbreviation
					   ,(SELECT TimeZoneName FROM TimeZone WHERE Id = TS.InTimeTimeZone)  InTimeTimeZone
					   ,(SELECT TimeZoneName FROM TimeZone WHERE Id = TS.OutTimeTimeZone) OutTimeTimeZone
					   ,(SELECT TimeZoneName FROM TimeZone WHERE Id = TS.LunchBreakStartTimeZone) LunchStartTimeZone
					   ,(SELECT TimeZoneName FROM TimeZone WHERE Id = TS.LunchBreakEndTimeZone) LunchEndTimeZone
                       ,(SELECT TOP 1 ST.StatusName FROM TimeSheetPunchCard AS TP
                                           LEFT JOIN [Status] AS ST ON ST.Id = TP.StatusId
                                           WHERE TP.UserId = U.Id AND CAST(TP.[Date] AS DATE) = CAST (DT.Datevalue AS DATE) ORDER BY TP.CreatedDateTime DESC) StatusName
						,(SELECT TOP 1 ST.StatusColour FROM TimeSheetPunchCard AS TP
                                           LEFT JOIN [Status] AS ST ON ST.Id = TP.StatusId
                                           WHERE TP.UserId = U.Id AND CAST(TP.[Date] AS DATE) = CAST (DT.Datevalue AS DATE) ORDER BY TP.CreatedDateTime DESC) StatusColour
                       ,TS.OutTime
					   ,ES.ShiftTimingId
                       ,(SELECT sum(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn,'+00:00'),SWITCHOFFSET( BreakOut ,'+00:00')))
                            FROM [UserBreak] UB WITH (NOLOCK)
                            WHERE UserId = TS.UserId AND CAST([Date] AS DATE) = TS.[Date]) BreakInMin
                       ,ISNULL(SE.DeadLine, SW.Deadline) DeadLine  
						,(SELECT  IIF(TS.[Date] = CONVERT(DATE,GETUTCDATE()), SUM(DATEDIFF(MINUTE, SWITCHOFFSET( BreakIn ,'+00:00'),ISNULL(SWITCHOFFSET( BreakOut ,'+00:00'),GETUTCDATE())))
                            ,SUM(DATEDIFF(MINUTE, SWITCHOFFSET( BreakIn ,'+00:00'),SWITCHOFFSET( BreakOut ,'+00:00'))))
                        FROM [UserBreak] UB WITH (NOLOCK)
                        WHERE UserId = TS.UserId AND CAST([Date] AS date) = TS.[Date]
                        GROUP BY CAST([Date] AS date),UserId
                        ) CountOfUserBreak                   
                       ,CAST(DATEDIFF(MINUTE,SWITCHOFFSET( LunchBreakStartTime ,'+00:00'),ISNULL(SWITCHOFFSET( LunchBreakEndTime ,'+00:00'),GETUTCDATE()))/60 AS VARCHAR(50)) + 'h ' + CAST(DATEDIFF(MINUTE, SWITCHOFFSET( LunchBreakStartTime ,'+00:00'),ISNULL(SWITCHOFFSET( LunchBreakEndTime ,'+00:00'),GETUTCDATE()))%60 AS VARCHAR(50)) + 'm' LunchBreakDiff
                       ,DATEDIFF(MINUTE, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET( LunchBreakEndTime ,'+00:00')) as Minutes_Difference
                       ,DATEDIFF(MINUTE, SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00')) TotalTimeSpend
                       ,ISNULL(TS.UpdatedDateTime,TS.CreatedDateTime) AS CreatedDateTime
                       ,CASE WHEN IsFeed = 1 THEN 'Manually' ELSE CASE WHEN IsFeed = 0 THEN 'Automatic' ELSE '-' END END FeedThrough
                       ,CASE WHEN SWITCHOFFSET(TS.InTime, '+00:00') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME)) THEN 1 ELSE 0 END IsMorningLate
                       ,CASE WHEN DATEDIFF(MINUTE, LunchBreakStartTime,LunchBreakEndTime) > 70 THEN 1 ELSE 0 END IsAfterNoonLate
                       ,TS.[TimeStamp]
        ,IIF((TS.InTime IS NOT NULL AND TS.OutTime IS NOT NULL AND (DATEDIFF(DAY,CONVERT(DATE,TS.Intime),CONVERT(DATE,TS.OutTime))) > 0),1,0) AS IsNextDay
        ,ISNULL(SE.AllowedBreakTime,SW.AllowedBreakTime) AS BreakAllowance
        ,(SELECT CONVERT(DATETIME,AppSettingsValue)
          FROM [AppSettings] WHERE AppSettingsName = 'LatestInsertedTrackerDate') AS LatestInsertedTrackerDate
		  ,(SELECT (CASE WHEN DATEDIFF(MINUTE,MAX(LastActiveDateTime),@Time) < 11 THEN 1 ELSE 0 END) FROM ActivityTrackerStatus AS UTS WHERE UTS.UserId = U.Id) AS [Status] 
         FROM [User] U WITH (NOLOCK)
          JOIN #DateTable DT ON DT.UserId = U.Id
                JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id AND (U.CompanyId = @CompanyId)
             INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
                        AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                        --AND EB.EmployeeId IN (SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees](NULL,@OperationsPerformedBy))
                        AND EB.EmployeeId IN (SELECT EmployeeId FROM #Employees)
                        AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
    LEFT JOIN TimeSheet TS WITH (NOLOCK) ON U.Id = TS.UserId AND DT.Datevalue = TS.[Date] AND TS.InActiveDateTime IS NULL--AND TS.[Date] >= @DateFrom AND TS.[Date] <= @DateTo
                LEFT JOIN EmployeeShift ES ON  ES.EmployeeId = E.Id  
    --AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date]) 
    --AND (ES.ActiveTo IS NULL OR (ES.ActiveTo IS NOT NULL AND CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date])))))
    AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date]) 
    AND (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date])))) AND ES.InActiveDateTime IS NULL
                LEFT JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
    LEFT JOIN [ShiftWeek] SW ON ST.Id = SW.ShiftTimingId AND [DayOfWeek] = DATENAME(WEEKDAY,TS.[Date])
    LEFT JOIN [ShiftException] SE ON ST.Id = SE.ShiftTimingId AND SE.InActiveDateTime IS NULL AND ExceptionDate = TS.[Date]
                --LEFT JOIN Branch HMB ON HMB.Id = EB.BranchId  
 
           WHERE (@BranchId IS NULL OR EB.BranchId = @BranchId)
                 AND U.Id NOT IN (SELECT UserId FROM ExcludedUser)
                 --AND U.IsActive = 1 AND U.InActiveDateTime IS NULL
                 AND (@UserId IS NULL OR U.Id = @UserId)
            GROUP BY TS.Id,DT.ActiveTimeInMin,DT.TotalIdleTime,DT.ProductiveTimeInMin,DT.LoggedTime,DT.Screenshots,U.Id,U.TimeZoneId,TS.UserId,DT.Datevalue,U.IsAdmin,EB.BranchId,ES.ShiftTimingId,TS.[Date],U.FirstName,U.SurName,U.RegisteredDateTime,U.ProfileImage,--HMB.BranchName,
                  TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.InTime,TS.InTimeTimeZone,TS.OutTimeTimeZone,TS.LunchBreakStartTimeZone,TS.LunchBreakEndTimeZone,TS.InTimeTimeZone,TS.OutTimeTimeZone,
				  TS.LunchBreakStartTimeZone,TS.LunchBreakEndTimeZone,TS.OutTime,ISNULL(SE.DeadLine, SW.Deadline),ES.ShiftTimingId, TS.CreatedDateTime, IsFeed,TS.[TimeStamp],TS.UpdatedDateTime,SE.AllowedBreakTime,SW.AllowedBreakTime) T  
                  LEFT JOIN #Leaves L ON T.UserId = L.UserId AND T.[Date] BETWEEN L.LeaveDateFrom AND L.LeaveDateTo
           WHERE ((@IncludeEmptyRecords = 0 AND (T.TimeSheetId IS NOT NULL OR L.[UserId] IS NOT NULL)) OR @IncludeEmptyRecords = 1)
          AND (@EmployeeSearchText IS NULL OR T.EmployeeName LIKE @EmployeeSearchText)
          AND (@SearchText IS NULL 
                  OR (T.EmployeeName LIKE @SearchText)
                  OR (FeedThrough LIKE @SearchText)
                  OR (LeaveReason LIKE @SearchText)
                  OR (LeaveTypeName LIKE @SearchText)
                  OR (LeaveSessionName LIKE @SearchText)
                 )
           ORDER BY 
                CASE WHEN @SortDirection = 'ASC' THEN
                     CASE WHEN @SortBy = 'EmployeeName' THEN T.EmployeeName
                          WHEN @SortBy = 'InTime' THEN Cast(SWITCHOFFSET(T.InTime, '+00:00') as sql_variant)
                          WHEN @SortBy = 'OutTime' THEN Cast(SWITCHOFFSET(T.OutTime, '+00:00') as sql_variant)
                          WHEN @SortBy = 'LunchBreakDiff' THEN Cast(Minutes_Difference as sql_variant) 
                          WHEN @SortBy = 'FeedThrough' THEN T.FeedThrough
                          WHEN @SortBy = 'CreatedDateTime' THEN T.CreatedDateTime
                          WHEN @SortBy = 'UserBreaks' THEN T.CountOfUserBreak
                          WHEN @SortBy = 'LeaveReason' THEN L.LeaveReason
                          WHEN @SortBy = 'Date' THEN CAST(T.[Date] as sql_variant)
      --   WHEN @SortBy = 'SpentTimeDiff' THEN  IIF(OutTime IS NULL, 
	-- 										 CAST((DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),IIF(CONVERT(DATE,T.[Date]) = CONVERT(DATE,@CurrentDate), @CurrentDate,CONVERT(DATETIME,CONVERT(DATE, T.[Date])) + '23:59:59')) - (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0)))/60 AS VARCHAR(50)) + 'h ' + 
	-- 										 CAST((DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),IIF(CONVERT(DATE,T.[Date]) = CONVERT(DATE,@CurrentDate), @CurrentDate,CONVERT(DATETIME,CONVERT(DATE, T.[Date])) + '23:59:59')) - (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0)))% 60 AS VARCHAR(50)) + 'm',
	-- 										 CAST((DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00'))- (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0)))/60 AS VARCHAR(50)) + 'h ' +
	-- 										 CAST((DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00'))- (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0)))%60 AS VARCHAR(50)) + 'm')
                     END 
                END ASC,
                CASE WHEN @SortDirection = 'DESC' THEN
                     CASE WHEN @SortBy = 'EmployeeName' THEN T.EmployeeName
                          WHEN @SortBy = 'InTime' THEN Cast(SWITCHOFFSET(T.InTime, '+00:00') as sql_variant)
                          WHEN @SortBy = 'OutTime' THEN Cast(SWITCHOFFSET(T.OutTime, '+00:00') as sql_variant)
                          WHEN @SortBy = 'LunchBreakDiff' THEN Cast(Minutes_Difference as sql_variant) 
                          WHEN @SortBy = 'FeedThrough' THEN T.FeedThrough
                          WHEN @SortBy = 'LeaveReason' THEN L.LeaveReason
                          WHEN @SortBy = 'UserBreaks' THEN T.CountOfUserBreak
                          WHEN @SortBy = 'CreatedDateTime' THEN T.CreatedDateTime
                          WHEN  @SortBy = 'Date' THEN CAST(T.[Date] as sql_variant)
      --   WHEN @SortBy = 'SpentTimeDiff' THEN  IIF(OutTime IS NULL, 
	-- 										 CAST((DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),IIF(CONVERT(DATE,T.[Date]) = CONVERT(DATE,@CurrentDate), @CurrentDate,CONVERT(DATETIME,CONVERT(DATE, T.[Date])) + '23:59:59')) - (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0)))/60 AS VARCHAR(50)) + 'h ' + 
	-- 										 CAST((DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),IIF(CONVERT(DATE,T.[Date]) = CONVERT(DATE,@CurrentDate), @CurrentDate,CONVERT(DATETIME,CONVERT(DATE, T.[Date])) + '23:59:59')) - (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0)))% 60 AS VARCHAR(50)) + 'm',
	-- 										 CAST((DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00'))- (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0)))/60 AS VARCHAR(50)) + 'h ' +
	-- 										 CAST((DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00'))- (ISNULL(Minutes_Difference,0) + ISNULL(CountOfUserBreak,0)))%60 AS VARCHAR(50)) + 'm')
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


