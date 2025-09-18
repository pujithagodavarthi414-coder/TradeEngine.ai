CREATE FUNCTION [dbo].[Ufn_GetRoleIdsBasedOnUserId]
(
    @UserId UNIQUEIDENTIFIER,
    @CompanyId UNIQUEIDENTIFIER
)
RETURNS TABLE AS RETURN
(
    SELECT RoleId FROM [UserRole] (NOLOCK) WHERE UserId = @UserId AND CompanyId = @CompanyId AND InActiveDateTime IS NULL
)