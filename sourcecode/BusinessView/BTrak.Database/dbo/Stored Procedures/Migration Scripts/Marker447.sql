CREATE PROCEDURE [dbo].[Marker447]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
END

DECLARE @Currentdate DATETIME = GETDATE()
MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
 (NEWID(),N'By using this app we can calculate the position,profit and loss for a particular instance.', N'Sunflower Oil Instance level dashboard', CAST(N'2023-03-17 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
 (NEWID(),N'By using this app we can calculate the position,profit and loss for a particular instance.', N'Glycerin Instance level dashboard', CAST(N'2023-03-17 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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
	(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Sunflower Oil Instance level dashboard' AND CompanyId = @CompanyId),'3DC59A11-F589-42A5-8F7A-925EC9B9542B',@UserId,@Currentdate)
   ,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Glycerin Instance level dashboard' AND CompanyId = @CompanyId),'3DC59A11-F589-42A5-8F7A-925EC9B9542B',@UserId,@Currentdate)
	
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
	(NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Sunflower Oil Instance level dashboard'),@RoleId,GETDATE(),@UserId)
   ,(NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Glycerin Instance level dashboard'),@RoleId,GETDATE(),@UserId)

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

GO