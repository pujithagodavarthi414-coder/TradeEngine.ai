-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-08 00:00:00.000'
-- Purpose      To Get the  Top And Bottom Spent Employee By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetTopAndBottomSpentEmployee] @CompanyId= '4AFEB444-E826-4F95-AC41-2175E36A0C16',@Type='Month',@Date='2018-01-01',@Order=''

CREATE PROCEDURE [dbo].[USP_GetTopAndBottomSpentEmployee]
 (
    @Type VARCHAR(100),
    @Date DATETIME,
    @Order VARCHAR(10),
    @CompanyId UNIQUEIDENTIFIER = NULL
 )
 AS
 BEGIN    
 DECLARE @MoreTimeSpentEmployeesCount TABLE
  (
     UserId UNIQUEIDENTIFIER,
     FullName VARCHAR(500),
     DaysMoreTimeSpentFor VARCHAR(500),
     DaysMoreTimeSpent INT,
     SpentTime INT
  )
  DECLARE @Top5LateMoreTimeSpentDays TABLE
  (
     DaysMoreTimeSpent INT
  )
 
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
 
  DECLARE @MoreTimeSpentTimeEmployees TABLE
  (
     UserId UNIQUEIDENTIFIER,
     [Date] DATETIME,
     MoreTimeSpentTime INT
      
  )
 
  OPEN DATE_CURSOR  
  FETCH NEXT FROM DATE_CURSOR INTO @PresentDate  
 
  WHILE @@FETCH_STATUS = 0  
  BEGIN
 
     INSERT INTO @MoreTimeSpentTimeEmployees(UserId,[Date],MoreTimeSpentTime)
     SELECT U.Id,[Date],DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00'))
     FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id 
	      LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId LEFT JOIN TimeSheet TS ON TS.UserId = U.Id
     WHERE U.Id NOT IN (SELECT UserId FROM ExcludedUser) AND [Date] = @PresentDate AND (U.CompanyId = @CompanyId)
 
  FETCH NEXT FROM DATE_CURSOR INTO @PresentDate  
  END  
 
  CLOSE DATE_CURSOR  
  DEALLOCATE DATE_CURSOR

	 INSERT INTO @Top5LateMoreTimeSpentDays(DaysMoreTimeSpent)
     SELECT SUM(MoreTimeSpentTime)
     FROM @MoreTimeSpentTimeEmployees
     GROUP BY UserId
	 
     INSERT INTO @MoreTimeSpentEmployeesCount(UserId,FullName,DaysMoreTimeSpent,DaysMoreTimeSpentFor,SpentTime)
     SELECT UserId,ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),SUM(MoreTimeSpentTime),@Type,
            CASE WHEN SUM(MoreTimeSpentTime) % 60  >= 30 THEN SUM(MoreTimeSpentTime)/ 60 + 1 ELSE  SUM(MoreTimeSpentTime)/ 60 END
     FROM @MoreTimeSpentTimeEmployees LE JOIN [User] U ON U.Id = LE.UserId
     GROUP BY UserId,ISNULL(FirstName,'') + ' ' + ISNULL(SurName,'')

     SELECT * FROM @MoreTimeSpentEmployeesCount WHERE DaysMoreTimeSpent IN (SELECT TOP 50 PERCENT DaysMoreTimeSpent FROM @Top5LateMoreTimeSpentDays 
     GROUP BY DaysMoreTimeSpent ORDER BY CASE WHEN  @Order='Top' THEN DaysMoreTimeSpent END DESC,
     CASE WHEN  @Order='Bottom' THEN DaysMoreTimeSpent END ASC) ORDER BY DaysMoreTimeSpent DESC,FullName
 
   END