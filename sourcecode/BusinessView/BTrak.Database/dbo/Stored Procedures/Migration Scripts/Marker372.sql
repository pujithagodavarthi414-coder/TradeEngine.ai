CREATE PROCEDURE [dbo].[Marker372]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @Currentdate DATETIME = GETDATE()

    MERGE INTO [dbo].[ClientInvoiceStatus] AS Target 
            USING ( VALUES
		        (NEWID(), 'Created', 'Created', '#00B4D8', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Shared', 'Shared', '#2666CF', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Signature Inprogress', 'Signature Inprogress', '#06FF00', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Signature Rejected', 'Signature Rejected', '#F05454', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Signature Completed', 'Signature Completed', '#009DAE', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Invoice Accepted', 'Invoice Accepted', '#FF0000', @Currentdate, @UserId,@CompanyId)
            )
            AS Source ([Id], [StatusName], [InvoiceStatusName], [StatusColor], [CreatedDateTime], [CreatedByUserId],[CompanyId])
            ON Target.[StatusName] = Source.[StatusName]  AND Target.CompanyId=Source.CompanyId
            WHEN MATCHED THEN 
            UPDATE SET [StatusName] = Source.[StatusName],
                       [StatusColor] = Source.[StatusColor],
                       [CompanyId] = Source.[CompanyId],
                       [CreatedDateTime] = Source.[CreatedDateTime],
                       [CreatedByUserId] = Source.[CreatedByUserId]
            WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([Id], [StatusName],[InvoiceStatusName], [StatusColor], [CreatedDateTime], [CreatedByUserId], [CompanyId]) 
            VALUES ([Id], [StatusName],[InvoiceStatusName], [StatusColor], [CreatedDateTime], [CreatedByUserId], [CompanyId]);
            
    MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
     (NEWID(),'This app can be used to update the name and color of a invoice status. These invoice status are used in purchased, sales and vessel contracts invoice queues.', N'Trade invoice status', CAST(N'2022-02-15 15:18:34.877' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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
    (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Trade invoice status' AND CompanyId = @CompanyId),'05E222F2-6EA3-4CA6-8788-52416E67475F',@UserId,@Currentdate)
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
           (NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Trade invoice status'),@RoleId,GETDATE(),@UserId)
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
            (NEWID(), @RoleId, N'662DDC92-7F9B-41B0-814C-72423D6033C9', CAST(N'2022-02-15 15:20:43.270' AS DateTime),@UserId)
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