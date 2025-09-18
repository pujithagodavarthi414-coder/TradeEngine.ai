CREATE PROCEDURE [dbo].[USP_GetApprovedRosterRequests]
(
	@UserId UNIQUEIDENTIFIER,
	@ApprovedDate DATETIME,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	IF (@HavePermission = '1')
	BEGIN
		DECLARE @TotalUserCount int, @ActualUserCount int
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
		INNER JOIN ROSTERREQUEST RR ON RR.Id = RAP.RequestId
		INNER JOIN RosterPlanStatus RS on RS.Id = RAP.PlanStatusId and RS.StatusName = 'Approved'
		INNER JOIN Employee E on E.Id = RAP.ActualEmployeeId
		INNER JOIN [User] U on U.Id = E.UserId AND U.Id = @UserId
		LEFT JOIN TimeSheetPunchCard T on T.UserId = U.Id
		LEFT JOIN [Status] S on S.Id = T.StatusId and S.StatusName = 'Approved'
		WHERE RAP.CompanyId = @CompanyId AND CONVERT(DATE, @ApprovedDate) BETWEEN RR.RequiredFromDate AND RR.RequiredToDate
		GROUP BY RAP.RequestId

		SELECT RequestId FROM @ApprovedEmployee where TotalUserCount = ActualApprovedUsers

	END
	ELSE
	BEGIN
		RAISERROR (@HavePermission,11, 1)
	END
END