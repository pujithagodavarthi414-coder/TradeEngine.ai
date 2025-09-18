-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-14 00:00:00.000'
-- Purpose      To Get the Employee Presence By Appliying Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetMorningandAfternoonTopLateEmployees_New]  @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@Type='Month',@Date='2019-03-01'

CREATE PROCEDURE [dbo].[USP_GetMorningandAfternoonTopLateEmployees_New]
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

  DECLARE @StartDate DATETIME
  DECLARE @EndDate DATETIME
  DECLARE @CompanyId UNIQUEIDENTIFIER 
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

  IF ((@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') OR (@OperationsPerformedBy = NULL))
  BEGIN
  SET @CompanyId = NULL
  END
	SELECT  A.UserId,
	        (ISNULL(U.FirstName,'') + ' ' + ISNULL(U.SurName,'')) AS EmployeeName,
		    COUNT(1) AS LateDaysEmployee 
	FROM(SELECT M.UserId AS UserId,
	            M.[Date],
				COUNT(1) AS LateDaysEmployeeCount 
		 FROM((SELECT TS.UserId,
		              [Date]
	           FROM TimeSheet TS WITH (NOLOCK) INNER JOIN [User] U WITH (NOLOCK) ON U.Id = TS.UserId
	                                           INNER JOIN Employee E WITH (NOLOCK) ON E.UserId = U.Id 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.ActiveFrom <= CONVERT(DATE,GETDATE()) AND (ES.ActiveTo IS NULL OR ES.ActiveTo >= CONVERT(DATE,GETDATE()))
		                                       INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND [DayOfWeek] = (DATENAME(WEEKDAY,GETDATE())) 
											   LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL
	           WHERE CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) AND [Date] >= @StartDate AND [Date] <= @EndDate AND (U.CompanyId = @CompanyId))M
		       INNER JOIN (SELECT UserId,[Date] FROM TimeSheet
	                       WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 
						   AND [Date] >= @StartDate AND [Date] <= @EndDate)Z ON M.UserId=Z.UserId AND M.[Date]=Z.[Date])
                           GROUP  BY M.UserId,M.[Date]
				)A JOIN [USER]U ON U.Id=A.UserId GROUP BY A.UserId,U.FirstName,U.SurName
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