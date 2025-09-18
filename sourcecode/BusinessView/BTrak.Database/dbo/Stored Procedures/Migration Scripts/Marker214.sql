CREATE PROCEDURE [dbo].[Marker214]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

--UPDATE WorkspaceDashboards SET InActiveDateTime = GETDATE() WHERE WorkspaceId IN (SELECT Id FROM Workspace WHERE WorkspaceName IN( 'Customized_hrsettings') AND CompanyId = @CompanyId)

 --  MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	--USING ( VALUES 
 --   (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,0, 1,1, 5,  5, 1,   'Badges',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,1, 1,2, 5,  5, 2,   'Contract type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,2, 1,3, 5,  5, 3,   'Configure Employee bonus',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,3, 1,4, 5,  5, 4,   'Department',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,4, 1,5, 5,  5, 5,   'Education levels',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,5, 1,6, 5,  5, 6,   'Job category',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,6, 1,7, 5,  5, 7,   'Nationalities',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,7, 1,8, 5,  5, 8,   'Shift timing',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,8, 1,9, 5,  5, 9,   'Skills',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,9, 1,10, 5,  5, 10,   'Designation',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,10, 23,10, 5,  5, 11,   'Employment type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,11, 23,10, 5,  5, 12,   'Company hierarchy',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,12, 23,10, 5,  5, 13,   'Region',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,13, 23,10, 5,  5, 14,   'Country',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,14, 23,10, 5,  5, 15,   'Currency',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,15, 23,10, 5,  5, 16,   'Identification type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,16, 23,10, 5,  5, 17,   'Languages',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,17, 23,10, 5,  5, 18,   'Pay frequency',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,18, 23,10, 5,  5, 19,   'Paygrade',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,19, 23,10, 5,  5, 20,   'Memberships',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,20, 23,10, 5,  5, 21,   'Payment method',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,21, 23,10, 5,  5, 22,   'Rate type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,23, 23,10, 5,  5, 23,   'Reporting methods',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,24, 23,10, 5,  5, 24,   'State',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
 --   ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,25, 23,10, 5,  5, 25,   'Time zone',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

 --   )AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows],[Order], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId])
 --   	ON Target.Id = Source.Id
 --   	WHEN MATCHED THEN
 --   	UPDATE SET [WorkspaceId] = Source.[WorkspaceId],
 --   			   [X] = Source.[X],	
 --   			   [Y] = Source.[Y],	
 --   			   [Col] = Source.[Col],	
 --   			   [Order] = Source.[Order],	
 --   			   [Row] = Source.[Row],	
 --   			   [MinItemCols] = Source.[MinItemCols],	
 --   			   [MinItemRows] = Source.[MinItemRows],	
 --   			   [Name] = Source.[Name],	
 --   			   [CustomWidgetId] = Source.[CustomWidgetId],	
 --   			   [IsCustomWidget] = Source.[IsCustomWidget],	
 --   			   [CreatedDateTime] = Source.[CreatedDateTime],
 --   			   [CompanyId] = Source.[CompanyId],
 --   			   [CreatedByUserId] = Source.[CreatedByUserId]
 --   	WHEN NOT MATCHED BY TARGET AND Source.[WorkspaceId] IS NOT NULL THEN 
 --   	INSERT([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]) VALUES
 --   	([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]);		

MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_assetssettings',0, GETDATE(), @UserId, @CompanyId, 'assetssettings')
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
	 (NEWID(), N'Customized_auditssettings',0, GETDATE(), @UserId, @CompanyId, 'auditssettings')
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
	 (NEWID(), N'Customized_rostersettings',0, GETDATE(), @UserId, @CompanyId, 'rostersettings')
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
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_assetssettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,    'Product management',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_assetssettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Vendor management',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_assetssettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 3,    'Location management',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

    
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
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_auditssettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,    'Question type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_auditssettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Audit Priority',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_auditssettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 3,    'Audit Risk',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_auditssettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 4,    'Audit Impact',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

    
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
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_rostersettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,    'Shift timing',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_rostersettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Company hierarchy',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_rostersettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 3,    'Holiday',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    -- ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_rostersettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 4,    'Rate tag',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_rostersettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,    'Employee rate tag',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_rostersettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 6,    'Days of week configuration',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

    
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

MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
	     (NEWID(),N'This app provides the information of leave types',N'Leave Types', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
--	     ,(NEWID(),N'This app provides the information of forms',N'Forms', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
--	     ,(NEWID(),N'This app provides the information of all applications',N'Applications', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
--	     ,(NEWID(),N'This app provides the information related to status reports configuration',N'Configure Status Reports', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
)
    AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.Id = Source.Id 
    WHEN MATCHED THEN 
    UPDATE SET [WidgetName] = Source.[WidgetName],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId] =  Source.[CompanyId],
               [Description] =  Source.[Description],
               [UpdatedDateTime] =  Source.[UpdatedDateTime],
               [UpdatedByUserId] =  Source.[UpdatedByUserId],
               [InActiveDateTime] =  Source.[InActiveDateTime]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;
  
MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
     USING (VALUES 
      (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Leave Types' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
      --,(NEWID(),(SELECT Id FROM CustomHtmlApp WHERE CustomHtmlAppName = 'Forms' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
      --,(NEWID(),(SELECT Id FROM CustomHtmlApp WHERE CustomHtmlAppName = 'Applications' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
      --,(NEWID(),(SELECT Id FROM CustomHtmlApp WHERE CustomHtmlAppName = 'Configure Status Reports' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
     )
    AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
    ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[ModuleId] = Source.[ModuleId]  
    WHEN MATCHED THEN 
    UPDATE SET
         [WidgetId] = Source.[WidgetId],
         [ModuleId] = Source.[ModuleId],
         [CreatedDateTime] = Source.[CreatedDateTime],
         [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
    INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]); 

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
         (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_leavesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 6,    'Leave Types',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
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
	 (NEWID(), N'Customized_projectreports',0, GETDATE(), @UserId, @CompanyId, 'ProjectReports')
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
	 (NEWID(), N'Customized_statusreports',0, GETDATE(), @UserId, @CompanyId, 'StatusReports')
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
	 (NEWID(), N'Customized_appbuilder',0, GETDATE(), @UserId, @CompanyId, 'AppBuilder')
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
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 1,    'Live dashboard',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 2,    'Actively running projects',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 3,    'Active goals',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 4,    'All work items',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 5,    'Productivity index',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 6,    'Bug report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 7,    'Bugs count on priority basis',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 8,    'Bugs list',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 9,    'Delayed goals',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 10,    'Delayed work items',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 11,    'Dev quality',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 12,    'Dev wise deployed and bounce back stories count',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 13,    'Employee assigned work items',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 14,    'Employee blocked work items/dependency analysis',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 15,    'Goal work items VS bugs count',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 16,    'Goals not ontrack',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 17,    'Goals vs Bugs count (p0, p1, p2)',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 18,    'Highest bugs goals list',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 19,    'Highest replanned goals',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 20,    'Imminent deadlines',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 21,    'Items deployed frequently',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 22,    'Items waiting for QA approval',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 23,    'Least work allocated peoples list',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 24,    'Project wise bugs count',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 25,    'QA created and executed test cases',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 26,    'Qa performance',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 27,    'QA productivity report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 28,    'Red goals list',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 29,    'Regression test run report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 30,    'Reports details',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 31,    'Users spent time details report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 32,    'Work items waiting for qa approval',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 33,    'Work logging report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 34,    'Work report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 35,    'All test suites',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 36,    'All testruns',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 37,    'All versions',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

    
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

MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
	     (NEWID(),N'This app provides the information of forms',N'View Forms', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	     ,(NEWID(),N'This app provides the information of all applications',N'Custom Applications', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	     ,(NEWID(),N'This app provides the information related to status reports configuration',N'Configure Status Reports', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
)
    AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.WidgetName = Source.WidgetName AND Target.CompanyId = Source.CompanyId 
    WHEN MATCHED THEN 
    UPDATE SET [WidgetName] = Source.[WidgetName],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId] =  Source.[CompanyId],
               [Description] =  Source.[Description],
               [UpdatedDateTime] =  Source.[UpdatedDateTime],
               [UpdatedByUserId] =  Source.[UpdatedByUserId],
               [InActiveDateTime] =  Source.[InActiveDateTime]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;

  
MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
     USING (VALUES 
     (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'View Forms' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
      ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Custom Applications' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
      ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Configure Status Reports' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Custom applications' ),@UserId,GETDATE())
     )
    AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
    ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[ModuleId] = Source.[ModuleId]  
    WHEN MATCHED THEN 
    UPDATE SET
         [WidgetId] = Source.[WidgetId],
         [ModuleId] = Source.[ModuleId],
         [CreatedDateTime] = Source.[CreatedDateTime],
         [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
    INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]); 

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
         (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_statusreports' AND CompanyId = @CompanyId),0,0, 29,16, 5,  5, 1,    'Form type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_statusreports' AND CompanyId = @CompanyId),0,0, 29,16, 5,  5, 2,    'View Forms',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_statusreports' AND CompanyId = @CompanyId),0,0, 29,16, 5,  5, 3,    'Configure Status Reports',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
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
         (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_appbuilder' AND CompanyId = @CompanyId),0,0, 29,16, 5,  5, 1,    'Form type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_appbuilder' AND CompanyId = @CompanyId),0,0, 29,16, 5,  5, 2,    'View Forms',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_appbuilder' AND CompanyId = @CompanyId),0,0, 29,16, 5,  5, 3,    'Custom Applications',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
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
         (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 38,    'Project Report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 39,    'Sprint Report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,0, 28,16, 5,  5, 40,    'Goal Report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

    
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