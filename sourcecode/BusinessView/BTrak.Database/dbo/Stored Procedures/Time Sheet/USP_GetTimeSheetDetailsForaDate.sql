CREATE PROCEDURE [dbo].[USP_GetTimeSheetDetailsForaDate]
(
    @DateFrom DATETIME,
    @DateTo DATETIME,
    @BranchId UniqueIdentifier,
    @TeamLeadId UniqueIdentifier,
    @UserId UniqueIdentifier
)
AS
BEGIN

IF(@BranchId = '00000000-0000-0000-0000-000000000000')
BEGIN
  SET @BranchId = NULL
END

IF(@TeamLeadId = '00000000-0000-0000-0000-000000000000')
BEGIN
  SET @TeamLeadId = NULL
END

IF(@UserId = '00000000-0000-0000-0000-000000000000')
BEGIN
  SET @UserId = NULL
END

DECLARE @TimesheetDetails TABLE
(
       TimeSheetId UniqueIdentifier,
       UserId UniqueIdentifier,
       IsAdmin bit,
       [Date] Datetime,
       BranchId UniqueIdentifier,
       TimingId UniqueIdentifier,
       BranchName VARCHAR(50),
       TimesheetDate DateTime,
       LeaveAppliedDate DATETIME,
       FirstName VARCHAR(200),
       SurName VARCHAR(200),
       TeamLeadId UniqueIdentifier,
       LunchBreakEndTime DATETIME,
       LunchBreakStartTime DATETIME,
       InTime DATETIME,
       OutTime DATETIME,
       DeadLine Time,
       LeaveReason VARCHAR(800),
       ToLeaveSessionId UniqueIdentifier,
       LeaveTypeId UniqueIdentifier,
       LunchDuration int,
       LunchBreakDiff VARCHAR(800),
       Minutes_Difference int,
       DeadLineTimeVal VARCHAR(800),
       LeaveTypeName VARCHAR(800),
       LeaveSessionName VARCHAR(800),
       TotalTimeSpend Numeric(18,5),
	   CreatedDateTime DATETIME,
	   FeedThrough VARCHAR(100)
)

IF(@UserId IS NULL)
BEGIN
	INSERT INTO @TimesheetDetails(TimeSheetId,UserId,[Date],IsAdmin,BranchId,TimingId,BranchName,TimesheetDate,LeaveAppliedDate,FirstName,SurName,TeamLeadId,
	                              LunchBreakEndTime,LunchBreakStartTime,InTime,OutTime,DeadLine,LeaveReason,ToLeaveSessionId,LeaveTypeId,
	                              LunchBreakDiff,Minutes_Difference,LeaveTypeName,LeaveSessionName,TotalTimeSpend,CreatedDateTime,FeedThrough)
	SELECT TS.Id,U.Id UserId,Ts.[Date],U.IsAdmin,EB.BranchId,ES.ShiftTimingId,B.[BranchName],TS.[Date],NULL,U.FirstName,U.SurName,@TeamLeadId,
	       TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.InTime,TS.OutTime,ISNULL(SE.Deadline,SW.DeadLine),NULL,NULL,NULL,
	       CAST(DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime)/60 AS VARCHAR(50)) + 'hr:' + CAST(DATEDIFF(MINUTE, LunchBreakStartTime,LunchBreakEndTime)%60 AS VARCHAR(50)) + 'min' LunchBreakDiff,
	        DATEDIFF(MINUTE, LunchBreakStartTime,LunchBreakEndTime) as Minutes_Difference,NULL,NULL,
	        DATEDIFF(SECOND,InTime,OutTime)*1.00/(60*60) TotalTimeSpend,TS.CreatedDateTime,CASE WHEN IsFeed = 1 THEN 'Feed Time Sheet' WHEN ISFeed = 0 THEN 'Button' ELSE '-' END
	FROM [User] U WITH (NOLOCK) LEFT JOIN TimeSheet TS WITH (NOLOCK) ON U.Id = TS.UserId AND TS.[Date] >= @DateFrom AND TS.[Date] <= @DateTo
	     LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id
	     LEFT JOIN EmployeeShift ES ON  ES.EmployeeId = E.Id AND ES.ActiveFrom <= CONVERT(DATE,TS.[Date]) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,TS.[Date]))
	     LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	     LEFT JOIN [ShiftTiming] T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
		 LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,TS.[Date])) 
		 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL AND SE.ExceptionDate = TS.[Date]
		 LEFT JOIN [Branch] B ON B.Id = EB.BranchId
	WHERE (@BranchId IS NULL OR EB.BranchId = @BranchId)
	      AND U.Id NOT IN (SELECT UserId from ExcludedUser)
	      AND U.IsActive = 1
	GROUP BY TS.Id,U.Id,U.IsAdmin,EB.BranchId,ES.ShiftTimingId,B.[BranchName],TS.[Date],u.FirstName,u.SurName,
	       TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.InTime,TS.OutTime,ISNULL(SE.Deadline,SW.DeadLine),TS.CreatedDateTime,IsFeed
	ORDER BY TotalTimeSpend DESC,FirstName
	
	UPDATE @TimesheetDetails SET UserId = LA.UserId, [Date] = LA.LeaveDateFrom, LeaveAppliedDate = LA.LeaveDateFrom, LeaveReason = LA.LeaveReason, ToLeaveSessionId = LA.ToLeaveSessionId,
	                             LeaveTypeId = LA.LeaveTypeId, LeaveTypeName = LT.LeaveTypeName, LeaveSessionName = LS.LeaveSessionName
	FROM [LeaveApplication] LA WITH (NOLOCK)
	    LEFT JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId
	    LEFT JOIN LeaveSession LS ON LS.Id = LA.ToLeaveSessionId
		JOIN @TimesheetDetails TD ON TD.UserId = LA.UserId
	WHERE LeaveDateFrom >= @DateFrom AND LeaveDateFrom <= @DateTo
	      AND LeaveDateTo >= @DateFrom AND LeaveDateTo <= @DateTo
END
ELSE
BEGIN
	INSERT INTO @TimesheetDetails(TimeSheetId,UserId,[Date],IsAdmin,BranchId,TimingId,BranchName,TimesheetDate,LeaveAppliedDate,FirstName,SurName,TeamLeadId,
	                              LunchBreakEndTime,LunchBreakStartTime,InTime,OutTime,DeadLine,LeaveReason,ToLeaveSessionId,LeaveTypeId,
	                              LunchBreakDiff,Minutes_Difference,LeaveTypeName,LeaveSessionName,TotalTimeSpend)
	SELECT TS.Id,U.Id UserId,Ts.[Date],U.IsAdmin,EB.BranchId,ES.ShiftTimingId,B.[BranchName],TS.[Date],NULL,u.FirstName,u.SurName,@TeamLeadId,
	       TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.InTime,TS.OutTime,ISNULL(SE.Deadline,SW.DeadLine),NULL,NULL,NULL,
	       CAST(DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime)/60 AS VARCHAR(50)) + 'hr:' + CAST(DATEDIFF(MINUTE, LunchBreakStartTime,LunchBreakEndTime)%60 AS VARCHAR(50)) + 'min' LunchBreakDiff,
	        DATEDIFF(MINUTE, LunchBreakStartTime,LunchBreakEndTime) as Minutes_Difference,NULL,NULL,
	        DATEDIFF(SECOND,InTime,OutTime)*1.00/(60*60) TotalTimeSpend
	FROM [User] U JOIN TimeSheet TS WITH (NOLOCK) ON U.Id = TS.UserId AND TS.[Date] >= @DateFrom AND TS.[Date] <= @DateTo
	     LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id
	     LEFT JOIN EmployeeShift ES ON  ES.EmployeeId = E.Id  AND ES.ActiveFrom <= CONVERT(DATE,TS.[Date]) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,TS.[Date]))	
	     LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
	     LEFT JOIN [ShiftTiming] T ON T.Id = ES.ShiftTimingId  AND T.InActiveDateTime IS NULL
		 LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,TS.[Date])) 
		 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL AND SE.ExceptionDate = TS.[Date]
		 LEFT JOIN [Branch] B ON B.Id = EB.BranchId
	WHERE (@BranchId IS NULL OR EB.BranchId = @BranchId)
	      AND U.Id NOT IN (SELECT UserId from ExcludedUser)
	      AND U.IsActive = 1
		  AND TS.UserId = @UserId
	GROUP BY TS.Id,U.Id,U.IsAdmin,EB.BranchId,ES.ShiftTimingId,B.[BranchName],TS.[Date],u.FirstName,u.SurName,
	       TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.InTime,TS.OutTime,ISNULL(SE.Deadline,SW.DeadLine)
	UNION ALL
	SELECT NULL,U.Id UserId,LA.LeaveDateFrom,U.IsAdmin,EB.BranchId,ES.ShiftTimingId,B.[BranchName],LA.LeaveDateFrom,LA.LeaveDateFrom,U.FirstName,u.SurName,@TeamLeadId,
	       NULL,NULL,NULL,NULL,NULL,LA.LeaveReason,LA.ToLeaveSessionId,LA.LeaveTypeId,
	       NULL LunchBreakDiff,
	       NULL Minutes_Difference,LT.LeaveTypeName,LS.LeaveSessionName,
	       NULL TotalTimeSpend
	FROM [User] U WITH (NOLOCK) JOIN [LeaveApplication] LA ON LA.UserId = U.Id
		 LEFT JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId
		 LEFT JOIN LeaveSession LS ON LS.Id = LA.ToLeaveSessionId
		 LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id
		 LEFT JOIN EmployeeShift ES ON  ES.EmployeeId = E.Id AND ES.ActiveFrom <= CONVERT(DATE,@DateFrom) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,@DateTo))
		 LEFT JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
		 --LEFT JOIN [ShiftTiming] T ON T.Id = ES.ShiftTimingId  AND T.InActiveDateTime IS NULL
		 --LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,Ts.[Date])) 
		 --LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND  SE.InActiveDateTime IS NULL AND TS.[Date] = SE.ExceptionDate
		 LEFT JOIN [Branch] B ON B.Id = EB.BranchId
	WHERE LeaveDateFrom >= @DateFrom AND LeaveDateFrom <= @DateTo AND LeaveDateTo >= @DateFrom AND LeaveDateTo <= @DateTo AND LA.UserId = @UserId

END

SELECT * FROM @TimesheetDetails

END