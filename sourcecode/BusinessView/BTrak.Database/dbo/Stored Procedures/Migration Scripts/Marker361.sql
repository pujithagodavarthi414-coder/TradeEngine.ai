CREATE PROCEDURE [dbo].[Marker361]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

	DECLARE @Currentdate DATETIME = GETDATE()

    MERGE INTO [dbo].[CompanySettings] AS Target
    USING ( VALUES
       (NEWID(), @CompanyId, N'TwilioNumber', N'', N'This number is used for send sms from twilio', CAST(N'2021-09-08T11:37:09.943' AS DateTime), @UserId)
       ,(NEWID(), @CompanyId, N'TwilioAccountSID', N'', N'This is a username for twilio.This SID is used for sending sms from twilio', CAST(N'2021-09-08T11:37:09.943' AS DateTime), @UserId)
       ,(NEWID(), @CompanyId, N'TwilioAuthToken', N'', N'This is a authorization token for twilio account. This auth token is used for sending sms from twilio.', CAST(N'2021-09-08T11:37:09.943' AS DateTime), @UserId)
    )
    AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
    ON Target.Id = Source.Id
    WHEN MATCHED THEN
    UPDATE SET CompanyId = Source.CompanyId,
               [Key] = source.[Key],
               [Value] = Source.[Value],
               [Description] = source.[Description],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]) 
    VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);  
    
    MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
     (NEWID(),'This app can be used to add and save the client types.By using this app we can update and archive the client types', N'Client types', CAST(N'2021-10-07 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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
(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Client types' AND CompanyId = @CompanyId),'EF94A114-B7A0-49B8-B4F7-D99F1E121C4F',@UserId,@Currentdate)
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
       (NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Client types'),@RoleId,GETDATE(),@UserId)
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
        (NEWID(), @RoleId, N'A4037EBC-8EA9-4FA0-AC60-F5E02657F356', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
        ,(NEWID(), @RoleId, N'D56C2E52-C358-4E4B-BEA3-36CB22890B75', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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