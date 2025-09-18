CREATE PROCEDURE [dbo].[Marker203]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
	
   MERGE INTO [dbo].[AuditRating] AS Target 
	USING (VALUES 
			 (NEWID(),@CompanyId, N'Outstanding',  CAST(N'2019-07-08T12:12:41.667' AS DateTime), @UserId),
			 (NEWID(),@CompanyId, N'Good',  CAST(N'2019-07-08T12:12:41.667' AS DateTime), @UserId),
			 (NEWID(),@CompanyId, N'Requires improvement',  CAST(N'2019-07-08T12:12:41.667' AS DateTime), @UserId),
			 (NEWID(),@CompanyId, N'Inadequate',  CAST(N'2019-07-08T12:12:41.667' AS DateTime), @UserId)
			)
	AS Source ([Id], [CompanyId], [AuditRatingName],  [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET
			   [CompanyId] = Source.[CompanyId],
			   [AuditRatingName] = Source.[AuditRatingName],
			 
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [AuditRatingName],  [CreatedDateTime], [CreatedByUserId])
	 VALUES ([Id], [CompanyId], [AuditRatingName],  [CreatedDateTime], [CreatedByUserId]);
	 
	  MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES 
	 (NEWID(),'By using this app, user can define the ratings for an audit. User can edit the audit rating. User can search and sort information in this app.',N'Audit rating',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	  	)
	AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	ON Target.[WidgetName] = Source.[WidgetName]
		AND Target.[CompanyId] = Source.[CompanyId]

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
	
END
GO


