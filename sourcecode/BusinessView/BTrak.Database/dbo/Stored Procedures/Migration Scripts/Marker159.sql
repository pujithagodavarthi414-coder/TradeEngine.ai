CREATE PROCEDURE [dbo].[Marker159]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
	
  UPDATE WorkspaceDashboards SET [Name] ='Manage Goal Performance Indicator' WHERE [Name] ='Manage Process Dashboard Status' AND CompanyId = @CompanyId AND ISNULL(IsCustomWidget,0) = 0
  UPDATE Widget SET WidgetName ='Manage Goal Performance Indicator' WHERE WidgetName ='Manage Process Dashboard Status' AND CompanyId = @CompanyId

END
GO

