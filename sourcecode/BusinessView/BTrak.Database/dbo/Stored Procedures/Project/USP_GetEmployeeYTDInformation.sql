CREATE PROCEDURE [dbo].[USP_GetEmployeeYTDInformation]
(
    @UserId UNIQUEIDENTIFIER,
    @Type VARCHAR(50),
    @Year INT
)
AS
BEGIN
DECLARE @EmployeeYTDRecords TABLE
(
   EmployeeId UNIQUEIDENTIFIER,
   FullName VARCHAR(500),
   [Date] DATETIME,
   MorningLate INT,
   LunchLate INT,
   Top5PercentOfMorningLate INT,
   Top5PercentOfLunchLate INT,
   LongSickLeave INT,
   CasualLeave INT,
   MondayLeave INT,
   WorkingHours INT
   
)
   DECLARE @StartDate DATETIME
   DECLARE @EndDate DATETIME
   DECLARE @CurrentDate DATE
   SELECT @CurrentDate = CONVERT(DATE,GETUTCDATE())
   SELECT @StartDate = DATEADD(YEAR,@Year-1900,0)
   SELECT @EndDate = DATEADD(yy, DATEDIFF(yy, 0, @StartDate) + 1, -1)
   IF(@Type = 'Morning Late')
   BEGIN
     INSERT INTO @EmployeeYTDRecords(EmployeeId,FullName,[Date])
     SELECT U.Id, ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),TS.[Date] 
     FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id  AND ES.ActiveFrom <= CONVERT(DATE,GETDATE()) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,GETDATE()))  LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
           LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,GETDATE())) LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id
		   LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL
     WHERE ((UAD.ActiveFrom >= @StartDate AND UAD.ActiveFrom <= @EndDate) OR @StartDate >= UAD.ActiveFrom)  AND (@StartDate <= UAD.ActiveTo OR UAD.ActiveTo IS NULL)
              AND @UserId = U.Id AND ([Date] >= @StartDate AND [Date] <= @EndDate) AND CAST(InTime AS TIME) > ISNULL(SE.DeadLine,SW.DeadLine)
     UPDATE @EmployeeYTDRecords SET MorningLate = 1
   END
   ELSE IF(@Type = 'Lunch Late')
   BEGIN
     INSERT INTO @EmployeeYTDRecords(EmployeeId,FullName,[Date])
     SELECT U.Id, ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),TS.[Date] 
     FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
           LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id
     WHERE ((UAD.ActiveFrom >= @StartDate AND UAD.ActiveFrom <= @EndDate) OR @StartDate >= UAD.ActiveFrom)  AND (@StartDate <= UAD.ActiveTo OR UAD.ActiveTo IS NULL) 
             AND @UserId = U.Id AND ([Date] >= @StartDate AND [Date] <= @EndDate) AND DATEDIFF(MINUTE, LunchBreakStartTime,LunchBreakEndTime) > 70
         
    UPDATE @EmployeeYTDRecords SET LunchLate = 1
   END
   ELSE IF(@Type = 'Top 5 Morning Late')
   BEGIN
     INSERT INTO @EmployeeYTDRecords(EmployeeId,FullName,[Date])
     SELECT U.Id, ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),TS.[Date] 
     FROM [User] U WITH (NOLOCK)  LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
           LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id
     JOIN [dbo].[USP_GetTop5LateEmployee](@StartDate,@EndDate) GE ON U.Id = GE.UserId AND CONVERT(DATE,TS.[Date])= CONVERT(DATE,GE.[Date])
     WHERE ((UAD.ActiveFrom >= @StartDate AND UAD.ActiveFrom <= @EndDate) OR @StartDate >= UAD.ActiveFrom)  AND (@StartDate <= UAD.ActiveTo OR UAD.ActiveTo IS NULL)
             AND @UserId = U.Id AND (TS.[Date] >= @StartDate AND TS.[Date] <= @EndDate)
     UPDATE @EmployeeYTDRecords SET Top5PercentOfMorningLate = 1
   END
   ELSE IF(@Type = 'Top 5 Lunch Late')
   BEGIN
     INSERT INTO @EmployeeYTDRecords(EmployeeId,FullName,[Date])
     SELECT U.Id, ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),TS.[Date] 
     FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
          LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id
     JOIN [dbo].[USP_GetTop5LunchBreakLongTakeEmployees](@StartDate,@EndDate) GE ON U.Id = GE.UserId AND CONVERT(DATE,TS.[Date])= CONVERT(DATE,GE.[Date])
     WHERE ((UAD.ActiveFrom >= @StartDate AND UAD.ActiveFrom <= @EndDate) OR @StartDate >= UAD.ActiveFrom)  AND (@StartDate <= UAD.ActiveTo OR UAD.ActiveTo IS NULL)
             AND @UserId = U.Id AND (TS.[Date] >= @StartDate AND TS.[Date] <= @EndDate)
     UPDATE @EmployeeYTDRecords SET Top5PercentOfLunchLate = 1 
   END
   ELSE IF(@Type = 'Casual Leave')
   BEGIN
    INSERT INTO @EmployeeYTDRecords(EmployeeId,FullName,[Date])
    SELECT U.Id, ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),TS.[Date] 
    FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
         LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id LEFT JOIN LeaveApplication LA ON LA.UserId= TS.UserId AND [Date] >= LeaveDateFrom ANd [Date] <= LeaveDateTo
    WHERE ((UAD.ActiveFrom >= @StartDate AND UAD.ActiveFrom <= @EndDate) OR @StartDate >= UAD.ActiveFrom)  AND (@StartDate <= UAD.ActiveTo OR UAD.ActiveTo IS NULL) 
            AND @UserId = U.Id AND ([Date] >= @StartDate AND [Date] <= @EndDate) AND LeaveTypeId = 'D2184B73-FD09-460B-9B13-81600A0C8084'
    UPDATE @EmployeeYTDRecords SET CasualLeave = 1 
   END
   ELSE IF(@Type = 'Sick Leave')
   BEGIN
    INSERT INTO @EmployeeYTDRecords(EmployeeId,FullName,[Date])
    SELECT U.Id, ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),TS.[Date] 
    FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id LEFT JOIN EmployeeShift ES WITH (NOLOCK) ON ES.EmployeeId = E.Id LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
         LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id LEFT JOIN LeaveApplication LA ON LA.UserId= TS.UserId AND [Date] >= LeaveDateFrom ANd [Date] <= LeaveDateTo
    WHERE ((UAD.ActiveFrom >= @StartDate AND UAD.ActiveFrom <= @EndDate) OR @StartDate >= UAD.ActiveFrom)  AND (@StartDate <= UAD.ActiveTo OR UAD.ActiveTo IS NULL) 
            AND @UserId = U.Id AND ([Date] >= @StartDate AND [Date] <= @EndDate) AND LeaveTypeId = 'F2785350-EF29-42E4-A7D5-7AC4FF086AD6'
    UPDATE @EmployeeYTDRecords SET LongSickLeave = 1 
   END
   ELSE IF(@Type = 'Monday Leave')
   BEGIN
      INSERT INTO @EmployeeYTDRecords(EmployeeId,FullName,[Date],WorkingHours)
      SELECT U.Id, ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),TS.[Date],CAST(DATEDIFF(MINUTE,TS.InTime,TS.OutTime)/60 AS INT) 
      FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
           LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id LEFT JOIN LeaveApplication LA ON LA.UserId= TS.UserId AND [Date] >= LeaveDateFrom ANd [Date] <= LeaveDateTo
      WHERE ((UAD.ActiveFrom >= @StartDate AND UAD.ActiveFrom <= @EndDate) OR @StartDate >= UAD.ActiveFrom)  AND (@StartDate <= UAD.ActiveTo OR UAD.ActiveTo IS NULL)
              AND @UserId = U.Id AND ([Date] >= @StartDate AND [Date] <= @EndDate) AND DATENAME(dw,TS.[Date]) = 'Monday' 
              AND (LeaveTypeId = 'D2184B73-FD09-460B-9B13-81600A0C8084' OR LeaveTypeId = 'F2785350-EF29-42E4-A7D5-7AC4FF086AD6')
      UPDATE @EmployeeYTDRecords SET MondayLeave = 1
   END
   ELSE IF(@Type = 'Working Hours')
   BEGIN
    INSERT INTO @EmployeeYTDRecords(EmployeeId,FullName,[Date],WorkingHours)
    SELECT U.Id, ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),TS.[Date],CAST(DATEDIFF(MINUTE,TS.InTime,TS.OutTime)/60 AS INT) 
    FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
         LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id
    WHERE ((UAD.ActiveFrom >= @StartDate AND UAD.ActiveFrom <= @EndDate) OR @StartDate >= UAD.ActiveFrom)  AND (@StartDate <= UAD.ActiveTo OR UAD.ActiveTo IS NULL)
            AND @UserId = U.Id AND ([Date] >= @StartDate AND [Date] <= @EndDate) 
   END
    SELECT * FROM @EmployeeYTDRecords ORDER BY [Date] 
END