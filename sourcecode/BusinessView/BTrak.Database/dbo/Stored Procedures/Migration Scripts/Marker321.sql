CREATE PROCEDURE [dbo].[Marker321]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	DELETE FROM DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = 'Time productivity' AND CompanyId = @CompanyId AND ISNULL(IsCustomWidget,0) = 0)
		  
	DELETE FROM WorkspaceDashboards WHERE [Name] = 'Time productivity' AND CompanyId = @CompanyId AND ISNULL(IsCustomWidget,0) = 0

	UPDATE dbo.[WorkspaceDashboards] SET X = 22, Y = 25, COL = 15, [Row] = 12 WHERE CompanyId = @CompanyId AND DashboardName = 'Team top 5 unproductive websites & applications'
	UPDATE dbo.[WorkspaceDashboards] SET X = 37, Y = 25, COL = 13, [Row] = 12 WHERE CompanyId = @CompanyId AND DashboardName = 'Team top five productive websites and applications'
	UPDATE dbo.[WorkspaceDashboards] SET X = 11, Y = 25, COL = 11, [Row] = 12 WHERE CompanyId = @CompanyId AND DashboardName = 'Team top 5 websites and applications'
	UPDATE dbo.[WorkspaceDashboards] SET X = 0, Y = 25, COL = 11, [Row] = 12 WHERE CompanyId = @CompanyId AND DashboardName = 'Min Working Hours'
END
GO