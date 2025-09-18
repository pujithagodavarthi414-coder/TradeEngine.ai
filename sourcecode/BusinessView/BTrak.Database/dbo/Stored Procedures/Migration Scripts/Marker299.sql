CREATE PROCEDURE [dbo].[Marker299]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN

UPDATE WorkspaceDashboards SET [Name] ='Regression run report'
WHERE [Name] = 'Regression test run report' AND CompanyId = @CompanyId   AND CustomWidgetId IS NOT NULL AND InActiveDateTime IS NULL
       AND CustomWidgetId
	    = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Regression test run report' AND CompanyId =  @CompanyId)  
										  
UPDATE CustomWidgets SET CustomWidgetName = 'Regression run report' 
WHERE CustomWidgetName = 'Regression test run report' AND CompanyId =  @CompanyId

END