CREATE PROCEDURE [dbo].[Marker347]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @Currentdate DATETIME = GETDATE()

	MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
     (NEWID(),'This app can be used to configure messages for entry form', N'Message Field type', CAST(N'2021-10-07 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
    )
    AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.[WidgetName] = Source.[WidgetName] AND Target.[CompanyId] = Source.[CompanyId]
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
    VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);
 

	MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
		USING (VALUES 
	(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Message Field type' AND CompanyId = @CompanyId),'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',@UserId,@Currentdate)
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

	MERGE INTO [dbo].[WidgetRoleConfiguration] AS Target 
		USING (VALUES 
	(NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Message Field type'),@RoleId,GETDATE(),@UserId)
	 )
	AS Source (Id,WidgetId,RoleId,CreatedDateTime,CreatedByUserId)
	ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[RoleId] = Source.[RoleId]  
	WHEN MATCHED THEN 
	UPDATE SET
			   [Id] = Source.[Id],
			   [WidgetId] = Source.[WidgetId],
			   [RoleId] = Source.[RoleId],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[RoleId] IS NOT NULL THEN 
	INSERT (Id,WidgetId,RoleId,CreatedDateTime,CreatedByUserId) VALUES (Id,WidgetId,RoleId,CreatedDateTime,CreatedByUserId);   


	MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
		(NEWID(), @RoleId, N'193013F3-3EBA-44AD-8790-2D89A735F6B4', CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId)
    )
    AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
    ON Target.Id = Source.Id  
    WHEN MATCHED THEN 
    UPDATE SET [RoleId] = Source.[RoleId],
               [FeatureId] = Source.[FeatureId],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
    VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

	MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_advancedinvoices' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,  'Message Field type',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     
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