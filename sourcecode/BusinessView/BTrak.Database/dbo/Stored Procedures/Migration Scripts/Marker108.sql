CREATE PROCEDURE [dbo].[Marker108]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


         
UPDATE Widget set WidgetName = 'Work report' WHERE WidgetName  = 'Historical work report' AND CompanyId = @CompanyId

UPDATE WorkspaceDashboards set [Name] = 'Work report' WHERE [Name]  = 'Historical work report' AND CompanyId = @CompanyId AND CustomWidgetId IS NULL 
                                     AND InActiveDateTime IS NULL AND (IsCustomWidget IS NULL OR IsCustomWidget = 0)


END

