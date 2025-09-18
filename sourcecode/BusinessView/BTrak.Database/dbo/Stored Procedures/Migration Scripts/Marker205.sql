CREATE PROCEDURE [dbo].[Marker205]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
	           (NEWID(), @RoleId, N'6C966874-025C-465B-9D9E-C69546DC58D9', GETDATE(),@UserId),
	           (NEWID(), @RoleId, N'E467AA34-60DD-4821-95DF-989DB2E1B7B1', GETDATE(),@UserId),
	           (NEWID(), @RoleId, N'83D2EE67-0359-44DF-A1D3-9B9CE3F4F4EC', GETDATE(),@UserId),
	           (NEWID(), @RoleId, N'EE98BB8F-E5A6-40B8-A3C4-49AA57CC0061', GETDATE(),@UserId)
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

	MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES 
	 (NEWID(),N'By using this app user can see all the configured business unit details for the site, can add, archive and edit the configured business unit details.Also users can view the archived configured rate tag configuration details and can search and sort the configured rate tag configuration details from the list.'
	  , N'Business unit', CAST(N'2020-11-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
	 )
	AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	ON Target.WidgetName = Source.WidgetName AND Target.CompanyId = Source.CompanyId 
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

	INSERT INTO WidgetModuleConfiguration([Id],[WidgetId],[ModuleId],[CreatedDateTime],[CreatedByUserId])
	SELECT NEWID(),(SELECT Id FROM Widget WHERE WidgetName = N'Business unit' AND CompanyId = @CompanyId),N'94410E90-BC12-4A39-BCA4-57576761F6CB',GETDATE(),@UserId


END
GO
