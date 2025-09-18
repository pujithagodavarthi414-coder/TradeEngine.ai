CREATE  FUNCTION [dbo].[USP_GetTop5LunchBreakLongTakeEmployees]
(
  @FromDate VARCHAR(500),
  @ToDate VARCHAR(500)
)
    RETURNS @EmployeeLate TABLE
    (
       UserId UNIQUEIDENTIFIER,
       FullName VARCHAR(500),
       LunchBreakStartTime DATETIME,
       [Date] DATETIME,
       LunchBreakEndTime DATETIME,
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
     SELECT Result+1 FROM CTE WHERE Result+1 <= CAST(@ToDate AS DATETIME)
    )
    
    INSERT INTO @DimDate([Date])
    SELECT Result FROM CTE OPTION (maxrecursion 0)
    
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
       SELECT TOP 5 [Date],CASE WHEN DATEDIFF(MINUTE, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')) > 70 THEN DATEADD(MI, - 70, (CAST(DATEADD(SECOND, DATEDIFF(SECOND, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')), 0) AS TIME))) ELSE '' END
       FROM [User] U LEFT JOIN Employee E ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id LEFT JOIN TimeSheet TS ON TS.UserId = U.Id
       WHERE U.Id NOT IN (SELECT UserId FROM ExcludedUser) AND [Date] = @PresentDate AND DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')) > 70 
       GROUP BY [Date],CASE WHEN DATEDIFF(MINUTE, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')) > 70 THEN DATEADD(MI, - 70, (CAST(DATEADD(SECOND, DATEDIFF(SECOND, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')), 0) AS TIME))) ELSE '' END
       ORDER BY CASE WHEN DATEDIFF(MINUTE, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')) > 70 THEN DATEADD(MI, - 70, (CAST(DATEADD(SECOND, DATEDIFF(SECOND, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')), 0) AS TIME))) ELSE '' END DESC
       
    FETCH NEXT FROM DATE_CURSOR INTO @PresentDate  
    END  
    
    CLOSE DATE_CURSOR  
    DEALLOCATE DATE_CURSOR
    
    INSERT INTO @EmployeeLate(UserId,FullName,[Date],LunchBreakStartTime,LunchBreakEndTime,Test,LateBy)
    SELECT U.Id,ISNULL(FirstName,'') + ' ' + ISNULL(SurName,'') FullName,Ts.[Date],LunchBreakStartTime,LunchBreakEndTime,LateTime,
           [dbo].[Ufn_GetMinutesToHHMM](DATEDIFF(MINUTE, '00:00:00', DATEADD(MI,-70, (CAST(DATEADD(SECOND, DATEDIFF(SECOND, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')), 0) AS TIME)))))
    FROM [User] U LEFT JOIN Employee E ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id LEFT JOIN TimeSheet TS ON TS.UserId = U.Id
         JOIN @Top5 T5 ON T5.[Date] = TS.[Date] AND CAST(DATEADD(MI,-70, (CAST(DATEADD(SECOND, DATEDIFF(SECOND, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')), 0) AS TIME))) AS VARCHAR(100)) = T5.LateTime
    WHERE U.Id NOT IN (SELECT UserId FROM ExcludedUser)
    
    RETURN
END