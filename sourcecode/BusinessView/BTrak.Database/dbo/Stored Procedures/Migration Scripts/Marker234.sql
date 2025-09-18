CREATE PROCEDURE [dbo].[Marker234]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
MERGE INTO [dbo].[UserStoryType] AS Target 
	USING ( VALUES 
		    (NEWID(),@CompanyId, N'Approve/Decline', CAST(N'2020-10-03 08:11:13.540' AS DateTime), @UserId, NULL, NULL,N'AD',NULL,NULL,NULL,1,1,1,N'#FE0204')
	) 
	AS Source ([Id],[CompanyId], [UserStoryTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[ShortName],[IsBug],[IsUserStory],[IsFillForm],[IsQaRequired],[IsLogTimeRequired],[IsApproveOrDecline],[Color]) 
	ON Target.UserStoryTypeName = Source.UserStoryTypeName AND Target.CompanyId = Source.CompanyId  
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
			   [IsApproveOrDecline] = SOURCe.IsApproveOrDecline,
			   [IsLogTimeRequired] = Source.IsLogTimeRequired
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],[CompanyId], [UserStoryTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[ShortName],[IsBug],[IsUserStory],[IsFillForm],[IsQaRequired],[IsLogTimeRequired],[IsApproveOrDecline],[Color]) 
	VALUES ([Id],[CompanyId], [UserStoryTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[ShortName],[IsBug],[IsUserStory],[IsFillForm],[IsQaRequired],[IsLogTimeRequired],[IsApproveOrDecline],[Color]);

END    
GO