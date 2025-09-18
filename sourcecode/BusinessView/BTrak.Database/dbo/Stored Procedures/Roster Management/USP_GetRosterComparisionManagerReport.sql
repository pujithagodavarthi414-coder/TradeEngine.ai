CREATE PROCEDURE [dbo].[USP_GetRosterComparisionManagerReport]
(
	@RequestId UNIQUEIDENTIFIER,	
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	--DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	--IF (@HavePermission = '1')
	--BEGIN
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		SELECT	RosterName,
				CONVERT(DATE, RequiredFromDate) RequiredFromDate,
				CONVERT(DATE, RequiredToDate) RequiredToDate,
				userroles.EmployeeId,
				userroles.EmployeeName,
				userroles.UserName,
				SUM(coalesce(ActualRate,0)) ActualRate,
				SUM(PlannedRate) PlannedRate,
				SUM(CASE WHEN ActualEmployeeId IS NOT NULL AND ActualFromTime IS NOT NULL THEN 1 ELSE 0 END ) ActualEmployeeId,
				COUNT(PlannedEmployeeId) PlannedEmployeeId,
				userroles.UserId
		FROM RosterActualPlan RAP
		INNER JOIN RosterRequest RR ON RR.Id = RAP.RequestId
		INNER JOIN RosterPlanStatus RAS ON RAS.Id = rr.StatusId and StatusName = 'Approved'
		CROSS APPLY (

			select distinct E1.Id EmployeeId , u1.Id UserId, u1.FirstName + COALESCE(' '+ u1.SurName, '') EmployeeName, u1.UserName from [USER] U 
			INNER JOIN [Employee] E ON E.UserId = U.Id
			INNER JOIN EmployeeEntityBranch EEB1 ON EEB1.EmployeeId = E.Id 
			INNER JOIN EmployeeEntityBranch EEB2 ON EEB1.BranchId = EEB2.BranchId
			INNER JOIN [Employee] E1 ON EEB2.EmployeeId = E1.Id 
			INNER JOIN [User] U1 ON E1.UserId = U1.Id 
			INNER JOIN [UserRole] UR ON UR.UserId = U1.Id AND UR.RoleId = (SELECT R.Id FROM ROLE R WHERE CompanyId = @CompanyId AND RoleName	= 'Manager')
			INNER JOIN RosterPlanStatus RPS on RPS.Id = RR.StatusId
			where U.Id = RR.CreatedByUserId 
		) as userroles
		WHERE RequestId = @RequestId
		--and CONVERT(DATE, RequiredToDate) <= CONVERT(DATE, GETDATE())
		GROUP BY RosterName, RequiredFromDate, RequiredToDate, userroles.EmployeeId, userroles.EmployeeName, userroles.UserName, userroles.UserId
	--END
	--ELSE
	--BEGIN
	--	RAISERROR (@HavePermission,11, 1)
	--END
END