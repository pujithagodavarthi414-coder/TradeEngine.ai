CREATE PROCEDURE [dbo].[Marker215]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
   
    MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
    USING ( VALUES    
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId), 11, 0, 5,5,5,5,  12 ,'Employee over time report'               ,'Employee over time report'               ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee over time report' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Employee over time report'  AND VisualizationName = 'Overt-Time By Month' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId), 12, 0, 5,5,5,5,  13 ,'Employees with 0 keystrokes'		      ,'Employees with 0 keystrokes'			 ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employees with 0 keystrokes'	AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Employees with 0 keystrokes' AND VisualizationName = 'Employees with 0 keystrokes_table' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId), 13, 0, 5,5,5,5,  14 ,'Employees with keystrokes more than 200' ,'Employees with keystrokes more than 200' ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employees with keystrokes more than 200' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Employees with keystrokes more than 200' AND VisualizationName = 'Employees with keystrokes more than 200_table' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
      
    )AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows],[Order], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId])
        ON Target.Id = Source.Id
        WHEN MATCHED THEN
        UPDATE SET [WorkspaceId] = Source.[WorkspaceId],
    			    [X] = Source.[X],	
    			    [Y] = Source.[Y],	
    			    [Col] = Source.[Col],	
    			    [Order] = Source.[Order],	
    			    [Row] = Source.[Row],	
    			    [MinItemCols] = Source.[MinItemCols],	
    			    [MinItemRows] = Source.[MinItemRows],	
                    [DashboardName] = Source.[DashboardName],
    			    [Name] = Source.[Name],	
    			    [CustomWidgetId] = Source.[CustomWidgetId],	
    			    [IsCustomWidget] = Source.[IsCustomWidget],	
    			    [CreatedDateTime] = Source.[CreatedDateTime],
    			    [CompanyId] = Source.[CompanyId],
    			    [CreatedByUserId] = Source.[CreatedByUserId]
        WHEN NOT MATCHED BY TARGET AND Source.[WorkspaceId] IS NOT NULL THEN 
        INSERT([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]) VALUES
              ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]);		

END