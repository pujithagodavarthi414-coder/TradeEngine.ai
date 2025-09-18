CREATE PROCEDURE [dbo].[Marker373]
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
     (NEWID(),'This app can be used to add and update the name of a tolerances. These tolerances are used in purchase and sale contracts.', N'Tolerances', CAST(N'2022-02-15 15:18:34.877' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
     (NEWID(),'This app can be used to add and update the name of a payment conditions. These payment conditions are used in vessel contracts.', N'Payment conditions', CAST(N'2022-02-15 15:18:34.877' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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
    (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Tolerances' AND CompanyId = @CompanyId),'05E222F2-6EA3-4CA6-8788-52416E67475F',@UserId,@Currentdate),
    (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Payment conditions' AND CompanyId = @CompanyId),'05E222F2-6EA3-4CA6-8788-52416E67475F',@UserId,@Currentdate)
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
           (NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Tolerances'),@RoleId,GETDATE(),@UserId),
           (NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Payment conditions'),@RoleId,GETDATE(),@UserId)
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
        USING ( VALUES
            (NEWID(), @RoleId, N'2FEA469E-93C0-48E2-B27B-382895A4F782', CAST(N'2022-02-15 15:20:43.270' AS DateTime),@UserId),
            (NEWID(), @RoleId, N'81FF012E-B1C9-44BD-9B41-D39879B39A48', CAST(N'2022-02-15 15:20:43.270' AS DateTime),@UserId)
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