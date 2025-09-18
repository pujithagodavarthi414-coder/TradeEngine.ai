CREATE PROCEDURE [dbo].[Marker169]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

	MERGE INTO [dbo].[UserStoryType] AS Target 
	USING ( VALUES 
			(NEWID(),@CompanyId, N'Activity', '2020-10-19 05:00:03.2633333 +00:00', @UserId, NULL, NULL, N'ACTIVITY', NULL, NULL, NULL, NULL, 1, NULL, N'#008000')
	) 
	AS Source ([Id],[CompanyId], [UserStoryTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ShortName], [IsBug], [IsUserStory], [IsFillForm], [IsQaRequired], [IsLogTimeRequired], [IsAction], [Color]) 
	ON Target.[CompanyId] = Source.[CompanyId] AND Target.[UserStoryTypeName] = Source.[UserStoryTypeName]
	AND Target.[CreatedDateTime] = Source.[CreatedDateTime]
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId] = Source.[CompanyId],
		       [UserStoryTypeName] = Source.[UserStoryTypeName],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId],
			   [ShortName] = Source.[ShortName],
			   [IsBug] = Source.[IsBug],
			   [IsUserStory] = Source.[IsUserStory],
			   [IsFillForm] = Source.[IsFillForm],
			   [IsQaRequired] = Source.IsQaRequired,
			   [IsLogTimeRequired] = Source.IsLogTimeRequired,
			   [IsAction] = Source.IsAction
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],[CompanyId], [UserStoryTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[ShortName],[IsBug],[IsUserStory],[IsFillForm],[IsQaRequired],[IsLogTimeRequired],[IsAction],[Color]) 
	VALUES ([Id],[CompanyId], [UserStoryTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[ShortName],[IsBug],[IsUserStory],[IsFillForm],[IsQaRequired],[IsLogTimeRequired],[IsAction],[Color]);

END
GO