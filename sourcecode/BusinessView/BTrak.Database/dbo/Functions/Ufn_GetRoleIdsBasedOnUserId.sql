CREATE FUNCTION [dbo].[Ufn_GetRoleIdsBasedOnUserId]
(
    @UserId UNIQUEIDENTIFIER
)
RETURNS TABLE AS RETURN
(
    SELECT RoleId FROM [UserRole] (NOLOCK) WHERE UserId = @UserId AND InActiveDateTime IS NULL
)