CREATE PROCEDURE [dbo].[Marker349]
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
     (NEWID(),'This app can be used to configure expense bookings', N'Expense Bookings', CAST(N'2021-10-07 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
     ,(NEWID(),'This app can be used to configure payment receipt recordings', N'Payment Receipts', CAST(N'2021-10-07 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
     ,(NEWID(),'This app can be used to configure credit notes', N'Credit Notes', CAST(N'2021-10-07 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
     ,(NEWID(),'This app can be used to configure master accounts', N'Master Accounts', CAST(N'2021-10-07 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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
	(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Expense Bookings' AND CompanyId = @CompanyId),'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',@UserId,@Currentdate)
	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Payment Receipts' AND CompanyId = @CompanyId),'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',@UserId,@Currentdate)
	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Credit Notes' AND CompanyId = @CompanyId),'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',@UserId,@Currentdate)
	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Master Accounts' AND CompanyId = @CompanyId),'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',@UserId,@Currentdate)
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
	(NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Expense Bookings'),@RoleId,GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Payment Receipts'),@RoleId,GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Credit Notes'),@RoleId,GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Master Accounts'),@RoleId,GETDATE(),@UserId)
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
		(NEWID(), @RoleId, N'ECA06EFD-312B-41DA-902A-B0AED4A5DFF6', CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId)
		,(NEWID(), @RoleId, N'D3DE5D81-3CDA-4067-A61B-0D20EAA4E351', CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId)
		,(NEWID(), @RoleId, N'82E563BD-8B27-4222-9EFE-E1711FCF8F22', CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId)
		,(NEWID(), @RoleId, N'8BBF8457-2BFC-4397-B237-3A04261C32B7', CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId)
    )
    AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
    ON Target.[RoleId] = Source.[RoleId] AND Target.[FeatureId] = Source.[FeatureId]  
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
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_advancedinvoices' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,  'Expense Bookings',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_advancedinvoices' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,  'Payment Receipts',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_advancedinvoices' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,  'Credit Notes',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_advancedinvoices' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,  'Master Accounts',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     
    )AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows],[Order], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId])
    	ON Target.[Name] = Source.[Name] AND Target.[WorkspaceId] = Source.[WorkspaceId]  
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