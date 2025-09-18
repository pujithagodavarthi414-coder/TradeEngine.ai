CREATE PROCEDURE [dbo].[USP_GetEmployeeUponTimesheetApproval]
(
	@UserId UNIQUEIDENTIFIER,
	@FromDate datetime,
	@Todate datetime,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	declare @currencycode varchar(10)
	select @currencycode = COALESCE(s.Symbol, s.currencyCode)  from company C
	INNER JOIN SYS_CURRENCY S ON C.CurrencyId = s.Id
	where c.id = @CompanyId

	SELECT DISTINCT CONVERT(DATE,TSP.[DATE]) [LogDate],U.Id [EmployeeId], U.UserName, U.FirstName + COALESCE(' ' + U.SurName, '') [EmployeeName],
	DATEDIFF(MINUTE, tsp.StartTime, tsp.EndTime) TotalMinutesWorked,  TSP.Breakmins, RAP.ActualRate, U.UserName [Email], U.Id UserId, @currencycode CurrencyCode
	FROM RosterActualPlan RAP
	INNER JOIN Employee E on E.Id = RAP.ActualEmployeeId
	INNER JOIN [User] U ON U.Id = E.UserId AND U.Id = @UserId
	INNER JOIN TimeSheetPunchCard TSP ON TSP.UserId = U.Id AND CONVERT(DATE, RAP.PlanDate) = CONVERT(DATE, TSP.Date)
	INNER JOIN Status s on s.Id = TSP.StatusId and s.CompanyId = TSP.CompanyId AND S.StatusName='Approved'
	WHERE U.CompanyId = @CompanyId and CONVERT(DATE, TSP.[DATE]) between @FromDate and @Todate

END