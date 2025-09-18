CREATE PROCEDURE [dbo].[Marker235]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'This month food orders bill' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Food order dashboard' AND CompanyId = @CompanyId) AND Name='This month food orders bill'

END