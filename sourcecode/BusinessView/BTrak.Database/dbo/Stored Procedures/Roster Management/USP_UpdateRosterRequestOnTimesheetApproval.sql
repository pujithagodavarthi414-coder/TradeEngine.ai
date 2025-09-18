CREATE PROCEDURE [dbo].[USP_UpdateRosterRequestOnTimesheetApproval]
(
	@UserId UNIQUEIDENTIFIER,
	@FromDate DATETIME,
	@ToDate DATETIME,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))


	DECLARE @ApprovedEmployee as Table
	(
		Id INT IDENTITY(1,1),
		RequestId UNIQUEIDENTIFIER,
		TotalUserCount INT,
		ActualApprovedUsers INT
	)

	INSERT INTO @ApprovedEmployee
	SELECT RAP.RequestId, COUNT(DISTINCT RAP.ActualEmployeeId), COUNT(distinct T.UserId) from RosterActualPlan RAP
	INNER JOIN RosterRequest RR ON RR.Id = RAP.RequestId AND RR.IsTimesheetApproved IS NULL
	INNER JOIN RosterPlanStatus RS on RS.Id = RAP.PlanStatusId and RS.StatusName = 'Approved'
	INNER JOIN Employee E on E.Id = RAP.ActualEmployeeId
	INNER JOIN [User] U on U.Id = E.UserId --AND U.Id = @UserId
	LEFT JOIN TimeSheetPunchCard T on T.UserId = U.Id AND T.Date = CONVERT(DATE, RAP.PlanDate)
	LEFT JOIN [Status] S on S.Id = T.StatusId and S.StatusName = 'Approved'
	WHERE RAP.CompanyId = @CompanyId
	GROUP BY RAP.RequestId

	UPDATE RR SET RR.IsTimesheetApproved = 1, RR.UpdatedDateTime = GETUTCDATE(), RR.UpdatedByUserId = @OperationsPerformedBy FROM @ApprovedEmployee AE
	INNER JOIN RosterRequest RR ON RR.Id = AE.RequestId
	WHERE TotalUserCount = ActualApprovedUsers

	select distinct ae.RequestId FROM @ApprovedEmployee AE
	INNER JOIN RosterRequest RR ON RR.Id = AE.RequestId
	WHERE TotalUserCount = ActualApprovedUsers
END