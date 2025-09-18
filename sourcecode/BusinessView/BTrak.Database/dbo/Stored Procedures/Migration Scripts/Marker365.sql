CREATE PROCEDURE [dbo].[Marker365]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @Currentdate DATETIME = GETDATE()

    MERGE INTO [dbo].[ClientKycFormStatus] AS Target 
            USING ( VALUES
        
		        (NEWID(), 'Pending', 'Pending', '#85adad', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Submitted', 'Submitted', '#33d6ff', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Verified', 'Verified', '#00ff99', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Up for Renewal', 'Up for Renewal', '#d97373', @Currentdate, @UserId,@CompanyId)
		        ,(NEWID(), 'Renewal submitted', 'Renewal submitted', '#65c421', @Currentdate, @UserId,@CompanyId)
            )
            AS Source ([Id], [StatusName], [KycStatusName], [StatusColor], [CreatedDateTime], [CreatedByUserId],[CompanyId])
            ON Target.[StatusName] = Source.[StatusName]  AND Target.CompanyId=Source.CompanyId
            WHEN MATCHED THEN 
            UPDATE SET [Id] = Source.[Id],
                       [StatusName] = Source.[StatusName],
                       [StatusColor] = Source.[StatusColor],
                       [CompanyId] = Source.[CompanyId],
                       [CreatedDateTime] = Source.[CreatedDateTime],
                       [CreatedByUserId] = Source.[CreatedByUserId]
            WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([Id], [StatusName],[KycStatusName], [StatusColor], [CreatedDateTime], [CreatedByUserId], [CompanyId]) 
            VALUES ([Id], [StatusName],[KycStatusName], [StatusColor], [CreatedDateTime], [CreatedByUserId], [CompanyId]);
  
    MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
     (NEWID(),'This app can be used to update the name and color of a kyc status. These kyc status are used in client kyc form verification process', N'KYC form status', CAST(N'2021-10-07 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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
    (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'KYC form status' AND CompanyId = @CompanyId),'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',@UserId,@Currentdate)
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
           (NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'KYC form status'),@RoleId,GETDATE(),@UserId)
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
            (NEWID(), @RoleId, N'9C5BD914-A891-4D6D-B085-330FD24136B7', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
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