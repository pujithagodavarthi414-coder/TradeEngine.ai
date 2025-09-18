CREATE FUNCTION [dbo].[USP_GetTop5LateEmployee]
(
  @FromDate VARCHAR(500),
  @ToDate VARCHAR(500)
)
    RETURNS @EmployeeLate TABLE
    (
       UserId UniqueIdentifier,
       FullName VARCHAR(500),
       [Date] DATETIME,
       LateBy VARCHAR(100),
       Test VARCHAR(100)
    )
AS
BEGIN
    
    DECLARE @StartDate DATETIME
    DECLARE @EndDate DATETIME
    DECLARE @CurrentDate DATE
    
    SELECT @CurrentDate = CONVERT(DATE,GETUTCDATE())
    SELECT @StartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentDate), 0)
    SELECT @EndDate = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @CurrentDate) + 1, 0))
    
    DECLARE @PresentDate DATETIME
    
    DECLARE @DimDate TABLE
    (
     [Date] DATETIME
    )
    
    ;WITH CTE AS
    (
     SELECT CAST(@FromDate AS DATETIME) AS Result
     UNION ALL
     SELECT Result+1 FROM CTE  WHERE Result+1 <= CAST(@ToDate AS DATETIME) 
    )
    
    INSERT INTO @DimDate([Date])
    SELECT Result FROM CTE option (maxrecursion 0)
    
    DECLARE DATE_CURSOR CURSOR FOR  
    SELECT [Date] FROM @DimDate
    
    DECLARE @Top5 TABLE
    (
       [Date] DATETIME,
       LateTime VARCHAR(100)
    )
    
    OPEN DATE_CURSOR  
    FETCH NEXT FROM DATE_CURSOR INTO @PresentDate  
    
    WHILE @@FETCH_STATUS = 0  
    BEGIN
    
       INSERT INTO @Top5([Date],LateTime)
       SELECT TOP 5 [Date],CASE WHEN CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) THEN (CAST(DATEADD(SECOND, DATEDIFF(SECOND, ISNULL(SE.Deadline,SW.DeadLine),  CAST(TS.InTime AS TIME)), 0) AS TIME)) ELSE '' END
       FROM [User] U LEFT JOIN Employee E ON E.UserId = U.Id 
					 LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id  
					 LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId  AND T.InActiveDateTime IS NULL
					 LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,GETDATE())) 
					 LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id LEFT JOIN TimeSheet TS ON TS.UserId = U.Id
					  LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL
       WHERE U.Id NOT IN (SELECT UserId FROM ExcludedUser) AND [Date] = @PresentDate AND CAST(DATEADD(MINUTE,330,TS.InTime) AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) AND ES.ActiveFrom <= CONVERT( DATE,GETDATE()) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT( DATE,GETDATE()))
       GROUP BY [Date],CASE WHEN CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) THEN (CAST(DATEADD(SECOND, DATEDIFF(SECOND, ISNULL(SE.Deadline,SW.DeadLine),  CAST(TS.InTime AS TIME)), 0) AS TIME)) ELSE '' END
       ORDER BY CASE WHEN CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) THEN (CAST(DATEADD(SECOND, DATEDIFF(SECOND, ISNULL(SE.Deadline,SW.DeadLine),  CAST(TS.InTime AS TIME)), 0) AS TIME)) ELSE '' END DESC
    
    FETCH NEXT FROM DATE_CURSOR INTO @PresentDate  
    END  
    
    CLOSE DATE_CURSOR  
    DEALLOCATE DATE_CURSOR
    
    INSERT INTO @EmployeeLate(UserId,FullName,[Date],Test,LateBy)
    SELECT U.Id,ISNULL(FirstName,'') + ' ' + ISNULL(SurName,'') FullName,Ts.[Date],LateTime,
           [dbo].[Ufn_GetMinutesToHHMM](DATEDIFF(MINUTE, ISNULL(SE.Deadline,SW.DeadLine),CAST(TS.InTime AS TIME)))
    FROM [User] U LEFT JOIN Employee E ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id 
				  LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
				  LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,GETDATE())) 
				  LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id LEFT JOIN TimeSheet TS ON TS.UserId = U.Id
				  LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND  SE.InActiveDateTime IS NULL
         JOIN @Top5 T5 ON T5.[Date] = TS.[Date] AND CAST(DATEADD(SECOND, DATEDIFF(SECOND, ISNULL(SE.Deadline,SW.DeadLine),  CAST(InTime AS TIME)), 0) AS TIME) = T5.LateTime
    WHERE U.Id NOT IN (SELECT UserId FROM ExcludedUser)  AND ES.ActiveFrom <= CONVERT( DATE,GETDATE()) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT( DATE,GETDATE()))
    
    RETURN
END