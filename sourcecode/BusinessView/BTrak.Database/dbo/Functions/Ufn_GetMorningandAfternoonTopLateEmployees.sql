CREATE FUNCTION [dbo].[Ufn_GetMorningandAfternoonTopLateEmployees]
(
    @Type VARCHAR(100),
    @Date DATETIME,
    @CompanyId UNIQUEIDENTIFIER = NULL
)
RETURNS @MorningandAfternoonTopLateEmployees TABLE
(
	UserId UNIQUEIDENTIFIER,
	EmployeeName NVARCHAR(800),
	LateDaysCount INT
)
BEGIN
   
  DECLARE @StartDate DATETIME
  DECLARE @EndDate DATETIME
   
   IF(@Type = 'Month')
  BEGIN
      SELECT @StartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @Date), 0)
      SELECT @EndDate = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @Date) + 1, 0))
  END

  IF(@Type = 'Week')
  BEGIN
      SELECT @EndDate = DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Date), CAST(@Date AS DATE))
      SELECT @StartDate = DATEADD(dd, -(DATEPART(dw, @EndDate)-1), CAST(@EndDate AS DATE))
  END

  IF (@CompanyId = '00000000-0000-0000-0000-000000000000')
  BEGIN
  SET @CompanyId = NULL
  END

    DECLARE @MorningLateEmployees TABLE
    (
       UserId UNIQUEIDENTIFIER,
       [Date] DATETIME
    )

	INSERT INTO @MorningLateEmployees(UserId,[Date])
	SELECT TS.UserId,[Date]
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId
	     LEFT JOIN Employee E ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.ActiveFrom <= CONVERT(DATE,GETDATE()) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,GETDATE()))
		      LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL 
			  LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = DATENAME(WEEKDAY,GETDATE()) 
			  LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND  SE.InActiveDateTime IS NULL
	WHERE CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) AND [Date] >= @StartDate AND [Date] <= @EndDate AND (U.CompanyId = @CompanyId)

	DECLARE @LunchLateEmployees TABLE
	(
	   UserId UNIQUEIDENTIFIER,
	   [Date] DATETIME
	)

	INSERT INTO @LunchLateEmployees(UserId,[Date])
	SELECT UserId,[Date]
	FROM TimeSheet
	WHERE DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')) > 70 AND [Date] >= @StartDate AND [Date] <= @EndDate

	DECLARE @LateEmployeesWithCount TABLE
	(
	    UserId UNIQUEIDENTIFIER,
	    LateDaysCount INT
	)
	INSERT INTO @LateEmployeesWithCount(UserId,LateDaysCount)
	SELECT M.UserId,COUNT(1) FROM @MorningLateEmployees M JOIN @LunchLateEmployees L ON  M.UserId =  L.UserId AND M.[Date] =  L.[Date]
	GROUP BY M.UserId

	INSERT INTO @MorningandAfternoonTopLateEmployees(UserId,EmployeeName,LateDaysCount)
	SELECT UserId,ISNULL(FirstName,'') + ' ' + ISNULL(SurName,'') AS EmployeeName, LateDaysCount
	FROM @LateEmployeesWithCount LE JOIN [User] U ON U.Id = LE.UserId
	WHERE LateDaysCount IN (SELECT TOP 5 LateDaysCount FROM @LateEmployeesWithCount ORDER BY LateDaysCount DESC)
	ORDER BY LateDaysCount DESC,UserId

RETURN

END