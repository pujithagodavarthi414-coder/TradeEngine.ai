CREATE PROCEDURE [dbo].[Marker180]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_systemsettings',0, GETDATE(), @UserId, @CompanyId, 'SystemSettings')
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

MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_hrsettings',0, GETDATE(), @UserId, @CompanyId, 'hrSettings')
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

MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_projectsettings',0, GETDATE(), @UserId, @CompanyId, 'projectsettings')
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
   
MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_timesheetsettings',0, GETDATE(), @UserId, @CompanyId, 'timesheetsettings')
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
    
MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_payrolesettings',0, GETDATE(), @UserId, @CompanyId, 'payrolesettings')
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
    
MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_leavesettings',0, GETDATE(), @UserId, @CompanyId, 'leavesettings')
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
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_systemsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,    'Company settings',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_systemsettings' AND CompanyId = @CompanyId),27,0, 23,16, 5,  5, 2,   'User management',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_systemsettings' AND CompanyId = @CompanyId),0,16, 27,10, 5,  5, 3,   'Soft label configuration',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_systemsettings' AND CompanyId = @CompanyId),27,16, 23,10, 5,  5, 4,  'Time zone',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_systemsettings' AND CompanyId = @CompanyId),0,23, 26,13, 5,  5,6,  'Country',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_systemsettings' AND CompanyId = @CompanyId),0,36, 50,12, 5,  5, 8, 'Currency',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_systemsettings' AND CompanyId = @CompanyId),0,90, 50,16, 5,  5,14,  'State',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,0, 1,1, 5,  5, 1,   'Badges',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,1, 1,2, 5,  5, 2,   'Contract type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,2, 1,3, 5,  5, 3,   'Configure Employee bonus',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,3, 1,4, 5,  5, 4,   'Department',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,4, 1,5, 5,  5, 5,   'Education levels',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,5, 1,6, 5,  5, 6,   'Job category',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,6, 1,7, 5,  5, 7,   'Nationalities',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,7, 1,8, 5,  5, 8,   'Shift timing',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,8, 1,9, 5,  5, 9,   'Skills',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,9, 1,10, 5,  5, 10,   'Designation',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,10, 23,10, 5,  5, 11,   'Employment type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,11, 23,10, 5,  5, 12,   'Company hierarchy',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,12, 23,10, 5,  5, 13,   'Region',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,13, 23,10, 5,  5, 14,   'Country',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,14, 23,10, 5,  5, 15,   'Currency',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,15, 23,10, 5,  5, 16,   'Identification type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,16, 23,10, 5,  5, 17,   'Languages',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,17, 23,10, 5,  5, 18,   'Pay frequency',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,18, 23,10, 5,  5, 19,   'Paygrade',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,19, 23,10, 5,  5, 20,   'Memberships',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,20, 23,10, 5,  5, 21,   'Payment method',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,21, 23,10, 5,  5, 22,   'Rate type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,23, 23,10, 5,  5, 23,   'Reporting methods',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,24, 23,10, 5,  5, 24,   'State',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,25, 23,10, 5,  5, 25,   'Time zone',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

    
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

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,    'Work item type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Project type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 3,    'Work item status',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 4,    'Board type workflow management',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,    'Workflow management',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 6,    'Bug priority',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 7,    'Goal replan type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 8,    'Manage Goal Performance Indicator',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 9,    'Work item replan type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 10,    'Test case type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 11,    'Test case status',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 12,    'Test case automation type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 13,    'Time configuration settings',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    
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

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_timesheetsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,    'Accessible IP address',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_timesheetsettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Button type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

    
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

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,    'Configure Employee bonus',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Creditor details',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 3,    'Financial year configurations',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 4,    'Leave encashment settings',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,    'Payroll branch configuration',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 6,    'Payroll calculation configurations',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 7,    'Payroll component',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 8,    'Payroll gender configuration',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 9,    'Payroll marital status configuration',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 10,    'Payroll role configuration',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 11,    'Payroll template',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 12,    'Professional tax ranges',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 13,    'Tax allowance',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 14,    'Tax slabs',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 15,    'Company hierarchy',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 16,    'Employee loans',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

    
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

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_leavesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,    'Leave formula',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_leavesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Leave session',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_leavesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 3,    'Leave status',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_leavesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 4,    'Restriction type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_leavesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,    'Payroll branch configuration',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

    
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