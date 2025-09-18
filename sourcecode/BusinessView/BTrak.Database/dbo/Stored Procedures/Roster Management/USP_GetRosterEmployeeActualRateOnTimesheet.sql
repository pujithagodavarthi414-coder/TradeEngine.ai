CREATE PROCEDURE [dbo].[USP_GetRosterEmployeeActualRateOnTimesheet]
(
	@DateOfSubmission Datetime,
	@UserId UNIQUEIDENTIFIER,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	
	DECLARE @CURRENCYCODE NVARCHAR(50)

	SELECT @CURRENCYCODE = COALESCE(S.Symbol , CurrencyCode)  FROM Company C
	INNER JOIN SYS_Currency S ON C.CurrencyId = S.Id 
	WHERE C.Id = @CompanyId
	
	SELECT U.UserName Email, E.Id EmployeeId, U.FirstName + COALESCE(' ' + U.SurName, '')  EmployeeName,  U.Id UserId,
	ISNULL(DATEDIFF(MINUTE,tp.InTime, tp.OutTime),0)/ 60 TotalMinutesWorked, ActualRate, BreakTime + (DATEDIFF(MINUTE,tp.LunchBreakStartTime, tp.LunchBreakEndTime)) Breakmins, @CURRENCYCODE CurrencyCode
	FROM RosterActualPlan RAP
	INNER JOIN Employee E on E.Id = RAP.ActualEmployeeId
	INNER JOIN [User] U ON U.Id = E.UserId AND U.Id=@UserId
	INNER JOIN TimeSheet TP ON TP.UserId = U.Id AND TP.Date = CONVERT(DATE, @DateOfSubmission) 
	OUTER APPLY (
		SELECT ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn, UB.BreakOut)),0) AS BreakTime FROM UserBreak UB
		WHERE UB.UserId = U.Id AND CONVERT(DATE, UB.Date) = CONVERT(DATE, RAP.PlanDate)
	) as UserBreak
	WHERE CONVERT(DATE, RAP.PlanDate) = CONVERT(DATE, @DateOfSubmission)
END