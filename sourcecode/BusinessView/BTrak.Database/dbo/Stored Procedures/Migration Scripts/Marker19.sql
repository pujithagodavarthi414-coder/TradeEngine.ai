CREATE PROCEDURE [dbo].[Marker19]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

DELETE FROM [dbo].[WidgetRoleConfiguration]
WHERE WidgetId IN (SELECT Id FROM [dbo].[Widget] WHERE WidgetName in ('Crud operation','Manage transition deadline'))
DELETE FROM [dbo].[Widget] WHERE WidgetName IN ('Crud operation','Manage transition deadline')

END
GO