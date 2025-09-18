CREATE PROCEDURE [dbo].[Marker344]
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
     (NEWID(),'This app can be used to configure fields for entry form', N'Entry form field', CAST(N'2021-10-07 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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
	(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Entry form field' AND CompanyId = @CompanyId),'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',@UserId,@Currentdate)
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
	(NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Entry form field'),@RoleId,GETDATE(),@UserId)
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
		(NEWID(), @RoleId, N'63E8ACFE-3FB9-4AD3-8942-81C5202845C0', CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId)
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
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_advancedinvoices' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,  'Entry form field',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     
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

    MERGE INTO [dbo].[EntryFormFieldType] AS Target 
    USING ( VALUES
		(NEWID(), 'PRA', @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'DF', @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId)
    )
    AS Source ([Id], [FieldTypeName], [CompanyId], [CreatedDateTime], [CreatedByUserId])
    ON Target.Id = Source.Id  AND Target.CompanyId = Source.CompanyId
    WHEN MATCHED THEN 
    UPDATE SET [FieldTypeName] = Source.[FieldTypeName],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [FieldTypeName], [CompanyId], [CreatedDateTime], [CreatedByUserId]) 
    VALUES ([Id], [FieldTypeName], [CompanyId], [CreatedDateTime], [CreatedByUserId]);

    MERGE INTO [dbo].[EntryFormField] AS Target 
    USING ( VALUES
		(NEWID(), 'PRA Field 1','PRAField1',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'PRA'),'CHF',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'PRA Field 2','PRAField2',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'PRA'),'CHF',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'PRA Field 3','PRAField3',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'PRA'),'CHF',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'PRA Field 4','PRAField4',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'PRA'),'CHF',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'PRA Field 5','PRAField5',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'PRA'),'CHF',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'PRA Field 6','PRAField6',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'PRA'),'CHF',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'PRA Field 7','PRAField7',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'PRA'),'CHF',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'PRA Field 8','PRAField8',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'PRA'),'CHF',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'DF Field 1','DFField1',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'DF'),'kWh',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'DF Field 2','DFField2',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'DF'),'kWh',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'DF Field 3','DFField3',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'DF'),'kWh',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'DF Field 4','DFField4',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'DF'),'kWh',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'DF Field 5','DFField5',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'DF'),'kWh',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'DF Field 6','DFField6',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'DF'),'kWh',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'DF Field 7','DFField7',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'DF'),'kWh',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId),
        (NEWID(), 'DF Field 8','DFField8',(SELECT Id FROM EntryFormFieldType WHERE CompanyId = @CompanyId AND FieldTypeName = 'DF'),'kWh',1, @CompanyId, CAST(N'2021-10-08 17:39:32.367' AS DateTime),@UserId)
    )
    AS Source ([Id], [DisplayName],[FieldName],[FieldTypeId],[Unit],[IsDisplay], [CompanyId], [CreatedDateTime], [CreatedByUserId])
    ON Target.Id = Source.Id  AND Target.CompanyId = Source.CompanyId
    WHEN MATCHED THEN 
    UPDATE SET [DisplayName] = Source.[DisplayName],
               [FieldName] = Source.[FieldName],
               [FieldTypeId] = Source.[FieldTypeId],
               [Unit] = Source.[Unit],
               [IsDisplay] = Source.[IsDisplay],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [DisplayName],[FieldName],[FieldTypeId],[Unit],[IsDisplay], [CompanyId], [CreatedDateTime], [CreatedByUserId]) 
    VALUES ([Id], [DisplayName],[FieldName],[FieldTypeId],[Unit],[IsDisplay], [CompanyId], [CreatedDateTime], [CreatedByUserId]);

    
	

END