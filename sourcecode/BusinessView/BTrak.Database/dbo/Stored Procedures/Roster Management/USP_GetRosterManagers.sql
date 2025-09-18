CREATE PROCEDURE [dbo].[USP_GetRosterManagers]
(
	@RequestId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		SELECT DISTINCT u1.Id UserId, u1.FirstName + COALESCE(' '+ u1.SurName, '') UserName, u1.UserName Email
		FROM RosterRequest R
		INNER JOIN [USER] U ON U.Id = R.CreatedByUserId 
		INNER JOIN [Employee] E ON E.UserId = U.Id
		INNER JOIN EmployeeEntityBranch EEB1 ON EEB1.EmployeeId = E.Id 
		INNER JOIN EmployeeEntityBranch EEB2 ON EEB1.BranchId = EEB2.BranchId
		INNER JOIN [Employee] E1 ON EEB2.EmployeeId = E1.Id 
		INNER JOIN [User] U1 ON E1.UserId = U1.Id 
		INNER JOIN [UserRole] UR ON UR.UserId = U1.Id AND UR.RoleId = (SELECT R.Id FROM ROLE R WHERE CompanyId = @CompanyId AND RoleName	= 'Manager')
		INNER JOIN RosterPlanStatus RPS on RPS.Id = R.StatusId
		WHERE R.CompanyId = @CompanyId AND R.Id = @RequestId
END