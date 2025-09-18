CREATE PROCEDURE [dbo].[Marker103]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

DECLARE @Currentdate DATETIME = GETDATE()

UPDATE WorkspaceDashboards SET InActiveDateTime = @Currentdate WHERE WorkspaceId IN (SELECT Id FROM Workspace WHERE WorkspaceName IN( 'Customized_goalDashboard','Customized_projectDashboard','Customized_sprintDashboard') AND CompanyId = @CompanyId)

   MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_goalDashboard' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,   'Goal burn down chart',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_goalDashboard' AND CompanyId = @CompanyId),27,0, 23,16, 5,  5, 2,   'Work item status report',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_goalDashboard' AND CompanyId = @CompanyId),0,16, 27,10, 5,  5, 3,   'Goal activity',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_goalDashboard' AND CompanyId = @CompanyId),27,16, 23,10, 5,  5, 4,   'Goal replan history',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),0,23, 26,13, 5,  5,6,    'Employees current work items',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),0,36, 50,12, 5,  5, 8,   'Work logging report',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),0,90, 50,16, 5,  5,14,    'Work items analysys board',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),0,48, 50,17, 5,  5, 9,   'Work items waiting for qa approval',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),17,0, 33,23, 5,  5, 5,   'Work allocation summary',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),26,23, 24,13, 5,  5, 7,   'Users spent time details report',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),0,75, 50,15, 5,  5, 13,   'Bug report',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),0,106, 50,15, 5,  5, 15,   'Historical work report',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),8,17, 9,6, 5,  4, 4,   'Long running items',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Long running items' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Long running items' AND VisualizationName = 'Long running items' AND CompanyId = @CompanyId),@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),0,17, 8,6, 5,  4, 3,   'Goals not ontrack',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Goals not ontrack' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Goals not ontrack' AND VisualizationName = 'Goals not ontrack_kpi' AND CompanyId = @CompanyId),@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),0,8, 17,9, 5,  4, 2,   'Delayed work items',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Delayed work items' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Delayed work items' AND VisualizationName = 'Delayed work items_table' AND CompanyId = @CompanyId),@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),0,0, 17,8, 5,  4, 1,   'Delayed goals',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Delayed goals' AND CompanyId = @CompanyId),1,(SELECT  TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Delayed goals' AND VisualizationName = 'Delayed goals_table' AND CompanyId = @CompanyId),@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),13,65, 13,10, 5,  4, 11,   'Goal work items VS bugs count',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Goal work items VS bugs count' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Goal work items VS bugs count' AND VisualizationName = 'Goal work items VS bugs count_table' AND CompanyId = @CompanyId),@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),0,65, 13,10, 5,  4,10,    'Highest bugs goals list',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Highest bugs goals list' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Highest bugs goals list' AND VisualizationName = 'More bugs goals list_table' AND CompanyId = @CompanyId),@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectDashboard' AND CompanyId = @CompanyId),26,65, 24,10, 5,  4, 12,   'Goals vs Bugs count (p0,p1,p2)',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Goals vs Bugs count (p0,p1,p2)' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Goals vs Bugs count (p0,p1,p2)' AND VisualizationName = 'Goals vs Bugs count (p0,p1,p2)_table' AND CompanyId = @CompanyId),@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_sprintDashboard' AND CompanyId = @CompanyId),0,0, 27,15, 5,  5, 1,   'Goal burn down chart',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_sprintDashboard' AND CompanyId = @CompanyId),26,29, 24,13, 5,  5,4,    'Sprint activity',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_sprintDashboard' AND CompanyId = @CompanyId),27,0, 23,15, 5,  5, 2,   'Work item status report',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_sprintDashboard' AND CompanyId = @CompanyId),0,29, 26,13, 5,  5, 5,   'Sprint replan history',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_sprintDashboard' AND CompanyId = @CompanyId),0,15, 50,14, 5,  5,3,    'Sprint bug report',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
    
    )AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows],[Order], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId])
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
    			   [Name] = Source.[Name],	
    			   [CustomWidgetId] = Source.[CustomWidgetId],	
    			   [IsCustomWidget] = Source.[IsCustomWidget],	
    			   [CreatedDateTime] = Source.[CreatedDateTime],
    			   [CompanyId] = Source.[CompanyId],
    			   [CreatedByUserId] = Source.[CreatedByUserId]
    	WHEN NOT MATCHED BY TARGET AND Source.[WorkspaceId] IS NOT NULL THEN 
    	INSERT([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]) VALUES
    	([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]);		

END
