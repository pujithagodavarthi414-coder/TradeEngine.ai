--SELECT EmployeeId FROM [dbo].[Ufn_GetAccessibleBranchLevelEmployees]('A9FA8B8F-4239-4FEC-8808-93E139392C97',NULL)
CREATE FUNCTION [dbo].[Ufn_GetAccessibleBranchLevelEmployees]
(
	@LoginEmployeeId UNIQUEIDENTIFIER NULL,
	@LoginUserId UNIQUEIDENTIFIER NULL
)
RETURNS TABLE AS RETURN
(
	SELECT E.EmployeeId 
	FROM EmployeeBranch E 
	WHERE E.[ActiveFrom] IS NOT NULL AND (E.[ActiveTo] IS NULL OR E.[ActiveTo] >= GETDATE())
	      AND E.BranchId IN (SELECT BranchId FROM EmployeeEntityBranch EEB
		                     WHERE EEB.InactiveDateTime IS NULL
							       AND ((@LoginEmployeeId IS NOT NULL AND EEB.EmployeeId = @LoginEmployeeId) 
							             OR (@LoginUserId IS NOT NULL AND EEB.EmployeeId = (SELECT Id FROM Employee WHERE InActiveDateTime IS NULL AND UserId = @LoginUserId))))
)
GO