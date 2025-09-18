CREATE PROCEDURE [dbo].[USP_GetLateEmployee]
(
   @Type VARCHAR(100),
   @Date DATETIME,
   @CompanyId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
  DECLARE @LateEmployeesCount TABLE
  (
     UserId UniqueIdentifier,
     FullName VARCHAR(500),
     DaysLateFor VARCHAR(500),
     DaysLate INT,
     PermittedDays INT
  )

  DECLARE @Top5LateDays TABLE
  (
     DaysLate INT
  )

 DECLARE @StartDate DATETIME
 DECLARE @EndDate DATETIME

  IF(@Type = 'Month')
  BEGIN
      SELECT @StartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @Date), 0)
      SELECT @EndDate = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @Date) + 1, 0))
  END

  ELSE IF(@Type = 'Week')
  BEGIN
      SELECT @EndDate = DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Date), CAST(@Date AS DATE))
      SELECT @StartDate = DATEADD(dd, -(DATEPART(dw, @EndDate)-1), CAST(@EndDate AS DATE))
  END

  IF (@CompanyId = '00000000-0000-0000-0000-000000000000')
  BEGIN
  SET @CompanyId = NULL
  END

  IF(@EndDate >= CONVERT(DATE,GETUTCDATE()))
	BEGIN
		SELECT @EndDate = CONVERT(DATE,GETUTCDATE())
	END

  DECLARE @PresentDate DATETIME
  DECLARE @DimDate TABLE
  (
       [Date] DATETIME
  )
  ;WITH CTE AS
  (
   SELECT CAST(@StartDate AS DATETIME) AS Result
   UNION ALL
   SELECT Result+1 FROM CTE WHERE Result+1 <= CAST(@EndDate AS DATETIME)
  )

  INSERT INTO @DimDate([Date])
  SELECT Result FROM CTE
  DECLARE DATE_CURSOR CURSOR FOR
  SELECT [Date] FROM @DimDate

  DECLARE @LateEmployees TABLE
  (
      UserId UniqueIdentifier,
     [Date] DATETIME,
     LateTime VARCHAR(100)
  )

  OPEN DATE_CURSOR
  FETCH NEXT FROM DATE_CURSOR INTO @PresentDate
  WHILE @@FETCH_STATUS = 0
  BEGIN
     INSERT INTO @LateEmployees(UserId,[Date],LateTime)
     SELECT U.Id,[Date],CASE WHEN CAST(TS.InTime AS TIME) > ISNULL(SE.DeadLine, SW.Deadline) THEN (CAST(DATEADD(SECOND, DATEDIFF(SECOND, ISNULL(SE.DeadLine, SW.Deadline),  CAST(TS.InTime AS TIME)), 0) AS TIME)) ELSE '' END
     FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id JOIN EmployeeShift ES WITH (NOLOCK) ON ES.EmployeeId = E.Id 
								 LEFT JOIN ShiftTiming T WITH (NOLOCK) ON T.Id = ES.ShiftTimingId AND ES.ActiveFrom <= CONVERT(DATE,GETDATE()) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,GETDATE()))
								 LEFT JOIN UserActiveDetails UAD WITH (NOLOCK) ON UAD.UserId = U.Id 
								 LEFT JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id
								 LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,GETDATE())) AND  SW.InActiveDateTime IS NULL
								 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND  SE.InActiveDateTime IS NULL
     WHERE [Date] = @PresentDate AND CAST(TS.InTime AS TIME) > ISNULL(SE.DeadLine, SW.Deadline) AND (U.CompanyId = @CompanyId)
     GROUP BY U.Id,TS.[Date],CASE WHEN CAST(TS.InTime AS TIME) > ISNULL(SE.DeadLine, SW.Deadline) THEN (CAST(DATEADD(SECOND, DATEDIFF(SECOND, ISNULL(SE.DeadLine, SW.Deadline),  CAST(TS.InTime AS TIME)), 0) AS TIME)) ELSE '' END
  FETCH NEXT FROM DATE_CURSOR INTO @PresentDate
  END
  CLOSE DATE_CURSOR
  DEALLOCATE DATE_CURSOR

  INSERT INTO @Top5LateDays(DaysLate)
  SELECT COUNT(1)
  FROM @LateEmployees
  GROUP BY UserId

  INSERT INTO @LateEmployeesCount(UserId,FullName,DaysLate,DaysLateFor)
  SELECT UserId,ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),COUNT(1),@Type
  FROM @LateEmployees LE  JOIN [User] U WITH (NOLOCK) ON U.Id = LE.UserId
  GROUP BY UserId,FirstName,SurName

  UPDATE @LateEmployeesCount SET PermittedDays = ISNULL(LECInner.PermittedDays,0)
  FROM @LateEmployeesCount LEC
       LEFT JOIN (SELECT P.UserId,COUNT(1) PermittedDays
                FROM Permission P JOIN [User] U WITH (NOLOCK) ON U.Id = P.UserId JOIN TimeSheet TS WITH (NOLOCK) ON TS.[Date] = P.[Date] AND TS.UserId = P.UserId 
				JOIN  Employee E WITH (NOLOCK) ON E.UserId = U.Id JOIN EmployeeShift ES WITH (NOLOCK) ON ES.EmployeeId = E.Id AND ES.ActiveFrom <= CONVERT(DATE,GETDATE()) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,GETDATE()))
					JOIN ShiftTiming T WITH (NOLOCK) ON T.Id = ES.ShiftTimingId  AND T.InActiveDateTime IS NULL JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,GETDATE())) 
					LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL
                WHERE P.[Date] >= @StartDate AND P.[Date] <= @EndDate AND TS.[Date] >= @StartDate AND TS.[Date] <= @EndDate AND CAST(TS.InTime AS TIME) > ISNULL(SE.DeadLine,SW.Deadline) AND IsMorning = 1
                AND (IsDeleted IS NULL OR IsDeleted = 0)
                AND U.CompanyId = @CompanyId
                GROUP BY P.UserId) LECInner ON LECInner.UserId = LEC.UserId
  SELECT * FROM @LateEmployeesCount WHERE DaysLate IN (SELECT TOP 5 DaysLate FROM @Top5LateDays GROUP BY DaysLate ORDER BY DaysLate DESC) ORDER BY DaysLate DESC,FullName
END