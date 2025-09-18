-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-11 00:00:00.000'
-- Purpose      To Get the Employee Attendance for Day By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetEmployeeAttendanceByDay_New] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308',@Date='2020-01-11'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetEmployeeAttendanceByDay_New]
(
   @Date DATETIME,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @TeamLeadId UNIQUEIDENTIFIER = NULL,
   @DepartmentId UNIQUEIDENTIFIER = NULL,
   @DesignationId UNIQUEIDENTIFIER = NULL,
   @SearchText VARCHAR(500) = NULL,
  @EntityId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   SET NOCOUNT ON 
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

         DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
         DECLARE @DateFrom DATETIME
         DECLARE @DateTo DATETIME
         SELECT @DateFrom = DATEADD(DAY,1,EOMONTH(DATEADD(MONTH,-1,@Date)))
         SELECT @DateTo = EOMONTH(@Date)   
         CREATE TABLE #EmployeeAttendanceByDay 
         (
           CompanyId UNIQUEIDENTIFIER  NULL,
           --CompanyName NVARCHAR(800),
           UserId UNIQUEIDENTIFIER NOT NULL,
		   EmployeeId UNIQUEIDENTIFIER NOT NULL,
           FullName NVARCHAR(800),
           [Date] DATETIME,
           InTime TIME,
           OutTime TIME,
           --LunchBreakStartTime TIME,
           --LunchBreakEndTime TIME,
           IsHoliday BIT,
		   ShiftId UNIQUEIDENTIFIER,
           IsShift BIT,
           DeadlineTime TIME,
           InTimeStartFrom TIME,
           IsAbsent FLOAT,
           LeaveTypeId UNIQUEIDENTIFIER NULL,
           --LeaveType NVARCHAR(800),
           --LateBy VARCHAR(800),
           IsActive BIT,
           SummaryValue INT,
           Summary VARCHAR(800),
           YesterDayOut TIME,
           OverWorkOut TIME,
           DayOfWeekValue NVARCHAR(100),
		   --ProfileImage VARCHAR(500),
		   --DepartmentName VARCHAR(100),
		   --DesignationName VARCHAR(100),
		   --BranchName VARCHAR(100),
		   LeaveSession INT,
		   JoiningDate DATETIME       
         )
         --DECLARE @Users TABLE
         --(
         --    UserId UNIQUEIDENTIFIER
         --)
		 DECLARE @EmployeeId UNIQUEIDENTIFIER = (SELECT Id FROM Employee WHERE UserId = @OperationsPerformedBy)
		 
         IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL
		 
         IF (@BranchId = '00000000-0000-0000-0000-000000000000')
         BEGIN
         SET @BranchId = NULL
         END
         IF (@TeamLeadId = '00000000-0000-0000-0000-000000000000' OR @TeamLeadId IS NULL)
         BEGIN
         SET @TeamLeadId = @OperationsPerformedBy
		 END
		 IF (@DepartmentId = '00000000-0000-0000-0000-000000000000')
         BEGIN
         SET @DepartmentId = NULL
         END
		 IF (@DesignationId = '00000000-0000-0000-0000-000000000000')
         BEGIN
         SET @DesignationId = NULL
         END
         IF (@CompanyId = '00000000-0000-0000-0000-000000000000')
         BEGIN
         SET @CompanyId = NULL
         END
		 SET @SearchText = '%'+ @SearchText +'%'
		
         INSERT INTO #EmployeeAttendanceByDay(UserId,EmployeeId,FullName,[Date],CompanyId,JoiningDate,DayOfWeekValue)
         SELECT U.Id,E.Id,ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),[Date],U.CompanyId --,C.CompanyName
                ,J.JoinedDate,DATENAME(DW,[Date])
         FROM [User] U WITH (NOLOCK)
          --    JOIN UserActiveDetails UAD WITH (NOLOCK) ON UAD.UserId = U.Id AND U.InActiveDateTime IS NULL
			       --AND (CompanyId = @CompanyId)
			  JOIN Company C ON C.Id = U.CompanyId AND U.CompanyId = @CompanyId
              JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id 
			       AND E.InactiveDateTime IS NULL AND U.InactiveDateTime IS NULL
			  JOIN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](@TeamLeadId,@CompanyId) GROUP BY ChildId)ERT ON ERT.ChildId = U.Id 
              JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
				   AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
				   AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
			  JOIN Job J ON J.EmployeeId = E.Id 
			       AND (J.DepartmentId = @DepartmentId OR @DepartmentId IS NULL) AND (J.DesignationId = @DesignationId OR @DesignationId IS NULL)
			  JOIN Designation D ON D.Id = J.DesignationId 
			  --JOIN Department DT ON DT.Id = J.DepartmentId 
			  --JOIN Branch B ON B.Id = EB.BranchId
              LEFT JOIN ExcludedUser EU ON EU.UserId = U.Id
              INNER JOIN (SELECT CAST(DATEADD( day,-(number-1),@DateTo) AS date) [Date]
	                  FROM master..spt_values
	                  WHERE Type = 'P' and number between 1 and 
					  datediff(day, @DateFrom, DATEADD(DAY,1,@DateTo)))T ON 1 = 1
             WHERE ((J.JoinedDate >= @DateFrom AND J.JoinedDate <= @DateTo) OR @DateFrom >= J.JoinedDate) 
				 AND (@EntityId IS NULL OR EB.BranchId IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId))
                 AND (@DateFrom <= J.InActiveDateTime OR J.InActiveDateTime IS NULL)
				 AND (@SearchText IS NULL 
					          OR ISNULL(FirstName,'') + ' ' + ISNULL(SurName,'') LIKE @SearchText
							  OR (FORMAT([Date],'dd-MMM-yyyy')  LIKE @SearchText) 
							  --OR (CONVERT(VARCHAR,DATEPART(DAY,[Date])) +  '-' + SUBSTRING(CONVERT(VARCHAR, [Date], 106),4,3) +  '-' + CONVERT(VARCHAR,DATEPART(YEAR,[Date])) LIKE @SearchText)
							  OR CONVERT(DATE,[Date]) LIKE @SearchText)
           GROUP BY U.Id,E.Id,FirstName,SurName,[Date],U.CompanyId,JoinedDate
                 
         --UPDATE #EmployeeAttendanceByDay SET BranchName = STUFF((SELECT ',' + LOWER(CONVERT(NVARCHAR(50),B.BranchName))
         --                                                        FROM Branch B
         --                                                             INNER JOIN [EmployeeBranch] EB ON B.Id = EB.BranchId 
         --                                                                        AND B.InactiveDateTime IS NULL
         --                                                        WHERE EB.EmployeeId = E.EmployeeId
         --                                                        GROUP BY BranchName
         --                                                        ORDER BY BranchName
         --                                                        FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
         --                                       FROM #EmployeeAttendanceByDay E

         UPDATE #EmployeeAttendanceByDay SET InTime = SWITCHOFFSET(TS.InTime, '+00:00'),OutTime = SWITCHOFFSET(TS.OutTime, '+00:00')
         --,LunchBreakStartTime = TS.LunchBreakStartTime,LunchBreakEndTime = TS.LunchBreakEndTime
         FROM TimeSheet TS WITH (NOLOCK)  
         JOIN #EmployeeAttendanceByDay EADB  ON TS.UserId = EADB.UserId AND TS.[Date] = EADB.[Date]
         
         UPDATE #EmployeeAttendanceByDay SET YesterDayOut = SWITCHOFFSET(TS.OutTime, '+00:00')
         FROM TimeSheet TS WITH (NOLOCK) 
         JOIN #EmployeeAttendanceByDay EADB  ON TS.UserId = EADB.UserId AND DATEADD(DAY,1,TS.[Date]) = EADB.[Date]
         UPDATE #EmployeeAttendanceByDay SET IsHoliday = CASE WHEN H.[Date] IS NULL THEN 0 ELSE 1 END
         FROM Holiday H  WITH (NOLOCK) 
         RIGHT JOIN #EmployeeAttendanceByDay EADB ON H.[Date] = EADB.[Date] AND H.InactiveDateTime IS NULL JOIN [User] U ON U.Id = EADB.UserId AND U.CompanyId = H.CompanyId
         
		 --UPDATE #EmployeeAttendanceByDay SET DayOfWeekValue=DATENAME(DW,[Date])

         --UPDATE #EmployeeAttendanceByDay SET IsSunday = CASE WHEN DATENAME(DW,[Date]) = 'SUNDAY' THEN 1 ELSE 0 END
         
         UPDATE #EmployeeAttendanceByDay SET DeadlineTime = ISNULL(SE.DeadLine,SW.Deadline), InTimeStartFrom = SW.StartTime,OverWorkOut = DATEADD(MINUTE,780,ISNULL(SE.StartTime,SW.StartTime))
         FROM #EmployeeAttendanceByDay EADB JOIN Employee E WITH (NOLOCK) ON E.UserId = EADB.UserId
                                            JOIN EmployeeShift ES WITH (NOLOCK) ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL 
											AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,EADB.[Date]) 
											AND	(ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,EADB.[Date]))))
                                            JOIN ShiftTiming ST WITH (NOLOCK) ON ST.Id = ES.ShiftTimingId 
											JOIN ShiftWeek SW WITH (NOLOCK) ON SW.ShiftTimingId = ST.Id AND SW.[DayOfWeek] = DATENAME(WEEKDAY,EADB.[Date])
											LEFT JOIN ShiftException SE WITH (NOLOCK) ON SE.ShiftTimingId = ST.Id AND SE.ExceptionDate = EADB.[Date]
         
         --UPDATE #EmployeeAttendanceByDay SET IsShift = 1 WHERE IsShift IS NULL AND IsHoliday <> 1 AND IsSunday <> 1

         UPDATE #EmployeeAttendanceByDay SET IsAbsent = LA.Cnt, LeaveTypeId = LT.MasterLeaveTypeId --, LeaveType = LT.LeaveTypeName
         FROM (SELECT LAP.UserId, CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND (LT.IsIncludeHolidays = 0 OR LT.IsIncludeHolidays IS NULL) THEN 0 
			                                           ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                                           ELSE 1 END END AS Cnt,T.[Date],LAP.LeaveTypeId FROM
			 (SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
			        FROM MASTER..SPT_VALUES MSPT
				    JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = 'P' AND LA.InActiveDateTime IS NULL
				                            AND (LA.LeaveDateFrom BETWEEN @DateFrom AND @DateTo OR LA.LeaveDateTo BETWEEN @DateFrom AND @DateTo)
											AND LA.UserId IN (SELECT Id FROM [User] WHERE CompanyId = @CompanyId AND IsActive = 1)
											) T
				    JOIN LeaveApplication LAP ON LAP.Id = T.Id 
					JOIN [User] U ON U.Id = LAP.UserId AND U.IsActive = 1
					JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND LS.IsApproved = 1
					JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId = U.CompanyId
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN MasterLeaveType MLT ON MLT.Id = LT.MasterLeaveTypeId
					JOIN Employee E ON E.UserId = LAP.UserId
					JOIN Job J ON J.EmployeeId = E.Id
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL))
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek]
					LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = @CompanyId AND H.WeekOffDays IS NULL
		            WHERE T.[Date] BETWEEN @DateFrom AND @DateTo) LA
              JOIN #EmployeeAttendanceByDay EADB ON EADB.UserId = LA.UserId  AND EADB.[Date] = LA.[Date]
              JOIN LeaveType LT WITH (NOLOCK) ON LT.Id = LA.LeaveTypeId 
			  JOIN MasterLeaveType MLT WITH (NOLOCK) ON LT.MasterLeaveTypeId = MLT.Id
         
		 UPDATE #EmployeeAttendanceByDay 
         SET IsAbsent = 0 
         WHERE IsAbsent IS NULL

		 UPDATE #EmployeeAttendanceByDay SET IsShift = CASE WHEN SW.Id IS NULL THEN 0 ELSE 1 END,ShiftId = ES.Id
         FROM #EmployeeAttendanceByDay EADB JOIN Employee E WITH (NOLOCK) ON E.UserId = EADB.UserId AND EADB.IsAbsent = 0
                                            LEFT JOIN EmployeeShift ES WITH (NOLOCK) ON ES.EmployeeId = E.Id  AND ES.InActiveDateTime IS NULL 
											AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,EADB.[Date]) 
											AND	(ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,EADB.[Date])))) 
                                            LEFT JOIN ShiftTiming ST WITH (NOLOCK) ON ST.Id = ES.ShiftTimingId 
                                            LEFT JOIN ShiftWeek SW WITH (NOLOCK) ON SW.ShiftTimingId = ST.Id AND DATENAME(WEEKDAY,EADB.[Date]) = SW.[DayOfWeek]
											LEFT JOIN ShiftException SE WITH (NOLOCK) ON SE.ShiftTimingId = ST.Id AND SE.ExceptionDate = EADB.[Date]
         
         --UPDATE #EmployeeAttendanceByDay 
         --SET LateBy = CASE WHEN InTime > DeadlineTime THEN (CASE WHEN CAST(DATEDIFF(MINUTE,InTimeStartFrom,InTime)/60 AS VARCHAR(50)) = '0' THEN CAST(DATEDIFF(MINUTE, InTimeStartFrom,InTime)%60 AS VARCHAR(50)) + 'min'
         --ELSE CAST(DATEDIFF(MINUTE,InTimeStartFrom,InTime)/60 AS VARCHAR(50)) + 'hr:' + CAST(DATEDIFF(MINUTE, InTimeStartFrom,InTime)%60 AS VARCHAR(50)) + 'min' END) ELSE '' END
         
         UPDATE #EmployeeAttendanceByDay 
         SET IsActive = CASE WHEN (EADB.[Date] >= J.JoinedDate 
         AND (EADB.[Date] <= J.InActiveDateTime OR J.InActiveDateTime IS NULL)) THEN 1 ELSE 0 END
         FROM #EmployeeAttendanceByDay EADB JOIN  Job J WITH (NOLOCK) ON EADB.EmployeeId = J.EmployeeId 
		 		  
         UPDATE #EmployeeAttendanceByDay SET SummaryValue = CASE WHEN IsHoliday = 1 AND IsShift = 1 AND InTime IS NULL THEN 6
                                                                 WHEN IsAbsent <> 0 THEN (CASE 
																 WHEN (IsAbsent = 0.5) THEN 12
																       WHEN LeaveTypeId = (SELECT Id FROM MasterLeaveType WHERE IsSickLeave = 1 AND @CompanyId = CompanyId) THEN 3 
																       WHEN LeaveTypeId = (SELECT Id FROM MasterLeaveType WHERE IsCasualLeave = 1 AND @CompanyId = CompanyId) THEN 4 
																       WHEN LeaveTypeId = (SELECT Id FROM MasterLeaveType WHERE IsWithoutIntimation = 1 AND @CompanyId = CompanyId) THEN 11 
																 ELSE 5 END)
                                                                 WHEN IsAbsent = 0 AND IsShift = 1 AND InTime IS NOT NULL AND [Date] <= GETUTCDATE() THEN (CASE WHEN (InTime <= DeadlineTime) THEN 0 
                                                                                               WHEN CONVERT(VARCHAR(8),YesterDayOut,108) >= CONVERT(VARCHAR(8),OverWorkOut,108) AND (InTime > DeadlineTime AND DeadlineTime IS NOT NULL) THEN 8
																							   WHEN (InTime > DeadlineTime AND DeadlineTime IS NOT NULL) THEN 1 END)
                                                                 WHEN IsAbsent = 0 THEN (CASE WHEN UserId IN (SELECT UserId FROM ExcludedUser) AND [Date] <= CONVERT(DATE,GETUTCDATE()) THEN 9
                                                                 WHEN ([Date] > CONVERT(DATE,GETUTCDATE()) OR IsActive = 0 OR ShiftId IS NULL)
                                                                THEN 7
																WHEN (IsActive = 1 AND IsShift = 0 AND InTime IS NULL AND ShiftId IS NOT NULL) 
                                                                        THEN 10
																WHEN (IsActive = 1 AND IsShift = 0 AND InTime IS NOT NULL) 
                                                                        THEN 0
															    WHEN ((IsActive = 1 AND IsShift = 1))
                                                                      AND (([Date] <= CONVERT(DATE,GETUTCDATE()))) AND InTime IS NULL THEN 2 END)
																ELSE 1
                                                                END 
         ----UPDATE #EmployeeAttendanceByDay SET Summary = CASE WHEN SummaryValue = 0 THEN  FullName + ',' + ISNULL(ProfileImage, '') + ',' + DepartmentName + ',' + DesignationName + ',' + BranchName + ',' + ' Present on '+CONVERT(VARCHAR, [Date], 106) 
         --                                                   WHEN Summaryvalue = 1 THEN FullName + ',' + ISNULL(ProfileImage, '') + ',' + DepartmentName + ',' + DesignationName + ',' + BranchName + ',' +' Late by '+LateBy+'('+CAST(InTime AS VARCHAR(5))+') '+' on '+ CONVERT(VARCHAR, [Date], 106)
         --                                                   WHEN Summaryvalue = 2 THEN 'Record not inserted'
         --                                                   WHEN Summaryvalue = 3 THEN FullName + ',' + ISNULL(ProfileImage, '') + ',' + DepartmentName + ',' + DesignationName + ',' + BranchName + ',' +' sick leave on '+CONVERT(VARCHAR, [Date], 106)
         --                                                   WHEN Summaryvalue = 4 THEN FullName + ',' +' casual leave on '+CONVERT(VARCHAR, [Date], 106)
         --                                                   WHEN Summaryvalue = 5 AND LeaveTypeId = (SELECT Id FROM MasterLeaveType WHERE IsWorkFromHome = 1 AND @CompanyId = CompanyId) THEN FullName + ',' + ISNULL(ProfileImage, '') + ',' + DepartmentName + ',' + DesignationName + ',' + BranchName + ',' +' work from home on '+  ',' + CONVERT(VARCHAR, [Date], 106)
         --                                                   WHEN Summaryvalue = 5 AND LeaveTypeId = (SELECT Id FROM MasterLeaveType WHERE IsOnSite = 1 AND @CompanyId = CompanyId) THEN FullName + ',' + ISNULL(ProfileImage, '') + ',' + DepartmentName + ',' + DesignationName + ',' + BranchName + ',' +' on-site on '+  ',' + CONVERT(VARCHAR, [Date], 106)
         --                                                   WHEN Summaryvalue = 6 THEN 'Holiday '+  ',' + CONVERT(VARCHAR, [Date], 106)
         --                                                   WHEN Summaryvalue = 7 AND IsShift = 1 AND [Date] > CONVERT(DATE,GETUTCDATE())THEN FullName + ',' + ISNULL(ProfileImage, '') + ',' + DepartmentName + ',' + DesignationName + ',' + BranchName + ','+' inactive'
         --                                                   WHEN Summaryvalue = 7 AND IsShift = 0 THEN FullName + ',' + ISNULL(ProfileImage, '') + ',' + DepartmentName + ',' + DesignationName + ',' + BranchName + ',' +' no shift'
         --                                                   WHEN Summaryvalue = 8 THEN FullName + ',' + ISNULL(ProfileImage, '') + ',' + DepartmentName + ',' + DesignationName + ',' + BranchName + ',' +' Night & Morning late'
         --                                                   WHEN Summaryvalue = 9 THEN 'Not to be track'
         --                                                   WHEN Summaryvalue = 10 THEN 'WeekOff '+ ',' + CONVERT(VARCHAR, [Date], 106)
									--						WHEN Summaryvalue = 11 THEN FullName + ',' +' without intimation leave on '+CONVERT(VARCHAR, [Date], 106)
									--						WHEN Summaryvalue = 12 THEN FullName + ',' +'leave on first half or second half'+CONVERT(VARCHAR, [Date], 106)
         --                                                END
           SELECT * FROM #EmployeeAttendanceByDay ORDER BY [Date] ASC,FullName ASC
    END TRY 
    BEGIN CATCH 
        
          THROW
    
	END CATCH
                                       
END
GO