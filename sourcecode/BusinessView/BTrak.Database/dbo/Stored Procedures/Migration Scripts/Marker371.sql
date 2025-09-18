CREATE PROCEDURE [dbo].[Marker371]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @Currentdate DATETIME = GETDATE()

    MERGE INTO [dbo].[ContractStatus] AS Target 
            USING ( VALUES
                (NEWID(), 'Draft', 'Draft', '#6c757d', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Draft shared', 'Draft shared', '#B1D3F8', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Draft approved', 'Draft approved', '#76E8E0', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Draft rejected', 'Draft rejected', '#FF0038', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Signature inprogress', 'Signature inprogress', '#FAC000', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Signatures done', 'Signatures done', '#F97FBC', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Contract cancelled', 'Contract cancelled', '#FAC000', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Linked', 'Linked', '#00D1FF', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'In exceution', 'In exceution', '#4E00FF', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Closed', 'Closed', '#91C483', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Sealed/Open', 'Sealed/Open', '#00D1FF', @Currentdate, @UserId,@CompanyId)
            )
            AS Source ([Id], [StatusName], [ContractStatusName], [StatusColor], [CreatedDateTime], [CreatedByUserId],[CompanyId])
            ON Target.[StatusName] = Source.[StatusName]  AND Target.CompanyId=Source.CompanyId
            WHEN MATCHED THEN 
            UPDATE SET [StatusName] = Source.[StatusName],
                       [StatusColor] = Source.[StatusColor],
                       [CompanyId] = Source.[CompanyId],
                       [CreatedDateTime] = Source.[CreatedDateTime],
                       [CreatedByUserId] = Source.[CreatedByUserId]
            WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([Id], [StatusName],[ContractStatusName], [StatusColor], [CreatedDateTime], [CreatedByUserId], [CompanyId]) 
            VALUES ([Id], [StatusName],[ContractStatusName], [StatusColor], [CreatedDateTime], [CreatedByUserId], [CompanyId]);

  
    MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
     (NEWID(),'This app can be used to update the name and color of a contract status. These contract status are used in purchased, sales and vessel contracts and its process.', N'Contract status', CAST(N'2021-10-07 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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
    (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Contract status' AND CompanyId = @CompanyId),'05E222F2-6EA3-4CA6-8788-52416E67475F',@UserId,@Currentdate)
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
           (NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Contract status'),@RoleId,GETDATE(),@UserId)
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
            (NEWID(), @RoleId, N'B98A20A9-46B6-4E5C-8109-3E8F01F0B71A', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
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