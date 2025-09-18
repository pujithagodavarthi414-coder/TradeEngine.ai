-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-13 00:00:00.000'
-- Purpose      To Get the More  Time Spent Employees By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetMoreSpentTimeEmployees_New] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@Type='Month',@Date='2018-01-01'

CREATE PROCEDURE [dbo].[USP_GetMoreSpentTimeEmployees_New]
(
   @Type VARCHAR(100),
   @Date DATETIME,
   @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
   SET NOCOUNT ON

	   BEGIN TRY
	   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
              
    IF (@HavePermission = '1')
    BEGIN

     DECLARE @MoreTimeSpentEmployeesCount TABLE
     (
        UserId UNIQUEIDENTIFIER,
        FullName VARCHAR(500),
        DaysMoreTimeSpentFor VARCHAR(500),
        DaysMoreTimeSpent INT,
        SpentTime VARCHAR(100)
    )

  DECLARE @Top5LateMoreTimeSpentDays TABLE
  (
     DaysMoreTimeSpent INT
  )

  DECLARE @StartDate DATETIME
  DECLARE @EndDate DATETIME
  DECLARE @CompanyId UNIQUEIDENTIFIER

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

 SET @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

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

  
  DECLARE @MoreTimeSpentTimeEmployees TABLE
  (
       UserId UniqueIdentifier,
       [Date] DATETIME,
       MoreTimeSpentTime INT
  )

    INSERT INTO @MoreTimeSpentTimeEmployees(UserId,[Date],MoreTimeSpentTime)
    SELECT U.Id,
	       TS.[Date],
		   DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'),SWITCHOFFSET(OutTime, '+00:00'))
    FROM [User] U WITH (NOLOCK) LEFT JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id JOIN EmployeeShift ES ON ES.EmployeeId = E.Id 
	              LEFT JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId LEFT JOIN TimeSheet TS ON TS.UserId = U.Id  INNER JOIN @DimDate D ON D.[Date]=TS.[Date]
     WHERE (U.CompanyId = @CompanyId )

     INSERT INTO @Top5LateMoreTimeSpentDays(DaysMoreTimeSpent)
     SELECT SUM(MoreTimeSpentTime)
     FROM @MoreTimeSpentTimeEmployees
     GROUP BY UserId
     
     INSERT INTO @MoreTimeSpentEmployeesCount(UserId,FullName,DaysMoreTimeSpent,DaysMoreTimeSpentFor,SpentTime)
     SELECT UserId,
	        ISNULL(FirstName,'') + ' ' + ISNULL(SurName,''),
			SUM(MoreTimeSpentTime),
			@Type,[dbo].[Ufn_GetMinutesToHours](SUM(MoreTimeSpentTime))
     FROM @MoreTimeSpentTimeEmployees LE JOIN [User] U ON U.Id = LE.UserId
     GROUP BY UserId,FirstName,SurName

  SELECT * FROM @MoreTimeSpentEmployeesCount WHERE DaysMoreTimeSpent IN (SELECT TOP 5 DaysMoreTimeSpent FROM @Top5LateMoreTimeSpentDays GROUP BY DaysMoreTimeSpent ORDER BY DaysMoreTimeSpent DESC) ORDER BY DaysMoreTimeSpent DESC,FullName

  END
	ELSE
    BEGIN
            
	RAISERROR (@HavePermission,11, 1)
                  
    END 
  END TRY  
	   BEGIN CATCH 
		
		   SELECT ERROR_NUMBER() AS ErrorNumber,
			      ERROR_SEVERITY() AS ErrorSeverity, 
			      ERROR_STATE() AS ErrorState,  
			      ERROR_PROCEDURE() AS ErrorProcedure,  
			      ERROR_LINE() AS ErrorLine,  
			      ERROR_MESSAGE() AS ErrorMessage

	  END CATCH
END