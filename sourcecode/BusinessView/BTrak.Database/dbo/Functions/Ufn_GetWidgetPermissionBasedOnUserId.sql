CREATE FUNCTION [dbo].[Ufn_GetWidgetPermissionBasedOnUserId]
(
	@WidgetRoles NVARCHAR(MAX),
	@UserId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
	RETURN
	(SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](@WidgetRoles,',')
	WHERE IIF([Value]= '',NULL,[Value]) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@UserId)))
END
