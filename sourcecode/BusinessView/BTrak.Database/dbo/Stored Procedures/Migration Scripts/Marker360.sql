CREATE PROCEDURE [dbo].[Marker360]
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
    (NEWID(),N'This app is used to save the legal entity types. In this application we can save legal entity and confirm. These legal entity types are used in kyc form creation and client creation',N'Legal entity types', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
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
    (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Legal entity types' AND CompanyId = @CompanyId),'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',@UserId,@Currentdate)
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
    USING ( VALUES
    (NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Legal entity types'),@RoleId,GETDATE(),@UserId)
    )
    AS Source (Id,WidgetId,RoleId,CreatedDateTime,CreatedByUserId)
    ON Target.WidgetId = Source.WidgetId AND Target.RoleId = Source.RoleId  
    WHEN MATCHED THEN 
    UPDATE SET [RoleId] = Source.[RoleId],
               WidgetId = Source.WidgetId,
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], WidgetId, RoleId, [CreatedDateTime], [CreatedByUserId]) 
    VALUES ([Id], WidgetId, RoleId, [CreatedDateTime], [CreatedByUserId]);

    MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES(NEWID(),@Roleid,'94BE8B48-5E64-4566-B820-89C40CD946E0', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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
    

         
END