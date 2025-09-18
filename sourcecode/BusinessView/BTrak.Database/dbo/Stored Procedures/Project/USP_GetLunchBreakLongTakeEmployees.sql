-------------------------------------------------------------------------------
-- Author       Aswani Katam
-- Created      '2019-02-16 00:00:00.000'
-- Purpose      To Get the LunchBreak Long Take Employees
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetLunchBreakLongTakeEmployees]@CompanyId='4AFEB444-E826-4F95-AC41-2175E36A0C16',@Type='Month',@Date='2018-08-01'

CREATE PROCEDURE [dbo].[USP_GetLunchBreakLongTakeEmployees]
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
     DaysLate INT
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
     SELECT U.Id,[Date],CASE WHEN DATEDIFF(MINUTE, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')) > 70 THEN DATEADD(MI, - 70, (CAST(DATEADD(SECOND, DATEDIFF(SECOND, SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')), 0) AS TIME))) ELSE '' END
     FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id JOIN EmployeeShift ES ON ES.EmployeeId = E.Id LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId LEFT JOIN UserActiveDetails UAD ON UAD.UserId = U.Id LEFT JOIN TimeSheet TS ON TS.UserId = U.Id
     WHERE [Date] = @PresentDate AND DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')) > 70 AND (U.CompanyId = @CompanyId)

      FETCH NEXT FROM DATE_CURSOR INTO @PresentDate

  END

  CLOSE DATE_CURSOR
  DEALLOCATE DATE_CURSOR

  INSERT INTO @Top5LateDays(DaysLate)
  SELECT COUNT(1) FROM @LateEmployees GROUP BY UserId

  INSERT INTO @LateEmployeesCount(UserId,FullName,DaysLate,DaysLateFor)
  SELECT UserId,ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),COUNT(1),@Type
  FROM @LateEmployees LE JOIN [User] U WITH (NOLOCK) ON U.Id = LE.UserId
  GROUP BY UserId,FirstName,SurName

  SELECT * FROM @LateEmployeesCount WHERE DaysLate IN (SELECT TOP 5 DaysLate FROM @Top5LateDays GROUP BY DaysLate ORDER BY DaysLate DESC) ORDER BY DaysLate DESC,FullName

END