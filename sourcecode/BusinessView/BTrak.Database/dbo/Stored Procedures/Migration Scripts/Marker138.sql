CREATE PROCEDURE [dbo].[Marker138]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

UPDATE [dbo].[WorkspaceDashboards] SET [Name] = 'Activity tracker configuration' WHERE [Name] = 'Activity' AND WorkspaceId IN (SELECT Id FROM workspace WHERE WorkspaceName='Manage activity tracker')
  
END
GO
