CREATE PROCEDURE [dbo].[Marker217]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Actively running projects' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Actively running projects' AND VisualizationName = 'Actively running projects _kpi' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Actively running projects'
    
UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Active goals' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Active goals' AND VisualizationName = 'Active goals_kpi' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Active goals'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs count on priority basis' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Bugs count on priority basis' AND VisualizationName = 'Bugs count on priority basis_donut' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Bugs count on priority basis'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs list' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Bugs list' AND VisualizationName = 'Bugs list_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Bugs list'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Delayed goals' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Delayed goals' AND VisualizationName = 'Delayed goals_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Delayed goals'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Delayed work items' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Delayed work items' AND VisualizationName = 'Delayed work items_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Delayed work items'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Dev wise deployed and bounce back stories count' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Dev wise deployed and bounce back stories count' AND VisualizationName = 'Dev wise deployed and bounce back stories count_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Dev wise deployed and bounce back stories count'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee assigned work items' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Employee assigned work items' AND VisualizationName = 'Employee assigned work items_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Employee assigned work items'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee blocked work items/dependency analysis' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Employee blocked work items/dependency analysis' AND VisualizationName = 'Employee blocked work items/dependency analasys_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Employee blocked work items/dependency analysis'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Goal work items VS bugs count' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Goal work items VS bugs count' AND VisualizationName = 'Goal work items VS bugs count_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Goal work items VS bugs count'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Goals not ontrack' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Goals not ontrack' AND VisualizationName = 'Goals not ontrack_kpi' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Goals not ontrack'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Goals vs Bugs count (p0, p1, p2)' AND VisualizationName = 'Goals vs Bugs count (p0,p1,p2)_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Goals vs Bugs count (p0, p1, p2)'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Highest bugs goals list' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Highest bugs goals list' AND VisualizationName = 'More bugs goals list_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Highest bugs goals list'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Highest replanned goals' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Highest replanned goals' AND VisualizationName = 'More replanned goals_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Highest replanned goals'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Items deployed frequently' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Items deployed frequently' AND VisualizationName = 'Items deployed frequently_KPI' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Items deployed frequently'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Items waiting for QA approval' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Items waiting for QA approval' AND VisualizationName = 'Items waiting for QA approval' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Items waiting for QA approval'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Least work allocated peoples list' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Least work allocated peoples list' AND VisualizationName = 'Least work allocated peoples list_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Least work allocated peoples list'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Project wise bugs count' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Project wise bugs count' AND VisualizationName = 'Project wise missed Bugs count' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Project wise bugs count'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'QA created and executed test cases' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'QA created and executed test cases' AND VisualizationName = 'table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='QA created and executed test cases'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Red goals list' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Red goals list' AND VisualizationName = 'Red goals list_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Red goals list'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Regression test run report' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Regression test run report' AND VisualizationName = 'Talko2  file uploads testrun details_pie' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Regression test run report'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Reports details' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Reports details' AND VisualizationName = 'Reports details_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Reports details'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'All test suites' AND VisualizationName = 'All test suites_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='All test suites'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All testruns' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'All testruns' AND VisualizationName = 'All testruns _table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='All testruns'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All versions' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'All versions' AND VisualizationName = 'All milestones_table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='All versions'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Project Report' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Project Report' AND VisualizationName = 'table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Project Report'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Sprint Report' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Sprint Report' AND VisualizationName = 'table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Sprint Report'

UPDATE WorkspaceDashboards SET
    CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Goal Report' AND CompanyId = @CompanyId),
    IsCustomWidget = 1,
    CustomAppVisualizationId = (SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Goal Report' AND VisualizationName = 'table' AND CompanyId = @CompanyId)
    WHERE WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId) AND Name='Goal Report'

END

