	
CREATE PROCEDURE [dbo].[Marker247]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_myproductivity',0, GETDATE(), @UserId, @CompanyId, 'myproductivity')
	)
	AS Source ([Id], [WorkSpaceName], [IsHidden], [CreatedDateTime], [CreatedByUserId], [CompanyId], [IsCustomizedFor])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [WorkSpaceName] = Source.[WorkSpaceName],
			   [IsHidden] = Source.[IsHidden],
			   [CompanyId] = Source.[CompanyId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsCustomizedFor] = Source.[IsCustomizedFor]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId],[IsCustomizedFor]) VALUES ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId], [IsCustomizedFor]);

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
         (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,    'Work report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Work allocation summary',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

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

MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_companyproductivity',0, GETDATE(), @UserId, @CompanyId, 'companyproductivity')
	)
	AS Source ([Id], [WorkSpaceName], [IsHidden], [CreatedDateTime], [CreatedByUserId], [CompanyId], [IsCustomizedFor])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [WorkSpaceName] = Source.[WorkSpaceName],
			   [IsHidden] = Source.[IsHidden],
			   [CompanyId] = Source.[CompanyId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsCustomizedFor] = Source.[IsCustomizedFor]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId],[IsCustomizedFor]) VALUES ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId], [IsCustomizedFor]);

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
         (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,    'Company productivity',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Company productivity' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Company productivity' AND VisualizationName = 'Company productivity_kpi' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Employee index',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 3,    'Work allocation summary',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 4,    'Branch wise monthly productivity report',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Branch wise monthly productivity report' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Branch wise monthly productivity report' AND VisualizationName = 'Branch wise monthly productivity report_donut' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,    'Spent time VS productive time',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Spent time VS productive time' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Spent time VS productive time' AND VisualizationName = 'Spent time VS productive time_table' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 6,    'QA productivity report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 7,    'Live dashboard',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 8,    'Red goals list',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Red goals list' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Red goals list' AND VisualizationName = 'Red goals list_table' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 9,    'Bugs count on priority basis',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs count on priority basis' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Bugs count on priority basis' AND VisualizationName = 'Bugs count on priority basis_donut' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 10,    'Qa performance',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 11,    'Work items waiting for qa approval',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 12,    'Dev quality',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

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

MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_myteamproductivity',0, GETDATE(), @UserId, @CompanyId, 'myteamproductivity')
	)
	AS Source ([Id], [WorkSpaceName], [IsHidden], [CreatedDateTime], [CreatedByUserId], [CompanyId], [IsCustomizedFor])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [WorkSpaceName] = Source.[WorkSpaceName],
			   [IsHidden] = Source.[IsHidden],
			   [CompanyId] = Source.[CompanyId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsCustomizedFor] = Source.[IsCustomizedFor]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId],[IsCustomizedFor]) VALUES ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId], [IsCustomizedFor]);

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
          (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,    'Employee index',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Qa performance',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 3,    'Work items waiting for qa approval',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 4,    'Dev quality',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,    'Work allocation summary',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 6,    'Red goals list',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Red goals list' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Red goals list' AND VisualizationName = 'Red goals list_table' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)

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