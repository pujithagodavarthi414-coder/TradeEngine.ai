CREATE PROCEDURE [dbo].[Marker212]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	MERGE INTO [dbo].[ActivityTrackerApplicationUrl] AS Target 
	USING ( VALUES 
	(NEWID(), N'8119B40C-834C-4721-80E0-0C8257C3E977', N'===Productive Time usage===', @UserId, CAST(N'2020-11-11 16:51:56.543' AS DateTime), @CompanyId, 1,NULL),
	(NEWID(), N'8119B40C-834C-4721-80E0-0C8257C3E977', N'===UnProductive Time usage===', @UserId, CAST(N'2020-11-11 16:51:56.543' AS DateTime), @CompanyId, 0,NULL)
	)
	AS Source ([Id], [ActivityTrackerAppUrlTypeId], [AppUrlName], [CreatedByUserId], [CreatedDateTime], [CompanyId],[IsProductive],[AppUrlImage]) 
	ON Target.[ActivityTrackerAppUrlTypeId] = Source.[ActivityTrackerAppUrlTypeId] AND Target.[AppUrlName] = Source.[AppUrlName] AND Target.[CompanyId] = Source.[CompanyId]
	WHEN MATCHED THEN 
	UPDATE SET 
			   [ActivityTrackerAppUrlTypeId] = Source.[ActivityTrackerAppUrlTypeId],		   
			   [AppUrlName] = Source.[AppUrlName],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CompanyId] = Source.[CompanyId],
			   [IsProductive] = Source.[IsProductive],
			   [AppUrlImage] = Source.[AppUrlImage]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [ActivityTrackerAppUrlTypeId], [AppUrlName], [CreatedByUserId], [CreatedDateTime], [CompanyId],[IsProductive],[AppUrlImage]) VALUES
		   ([Id], [ActivityTrackerAppUrlTypeId], [AppUrlName], [CreatedByUserId], [CreatedDateTime], [CompanyId],[IsProductive],[AppUrlImage]);  


	DECLARE @UrlRoleCount INT = (SELECT TOP 1 COUNT(AUR.Id) FROM ActivityTrackerApplicationUrlRole AUR
	JOIN [ActivityTrackerApplicationUrl] AU ON AU.Id = AUR.ActivityTrackerApplicationUrlId
	WHERE AU.AppUrlName IN (N'===Productive Time usage===', N'===UnProductive Time usage===') AND AU.CompanyId = @CompanyId) 	

	IF(@UrlRoleCount = 0)
	BEGIN
		INSERT INTO ActivityTrackerApplicationUrlRole(Id,ActivityTrackerApplicationUrlId,RoleId,CompanyId,IsProductive,CreatedByUserId,CreatedByDateTime)
		SELECT NEWID(),A.Id AS ActivityTrackerApplicationUrlId,R.Id AS RoleId,@CompanyId AS CompanyId,
				CASE WHEN A.AppUrlName IN (N'===Productive Time usage===') THEN 1 
							ELSE 0 END
				,@UserId AS CreatedByUserId,GETDATE() AS CreatedByDateTime
					FROM ActivityTrackerApplicationUrl AS A ,Role AS R 
				WHERE A.CompanyId = @CompanyId AND R.CompanyId = @CompanyId AND (R.IsHidden <> 1 OR R.IsHidden IS NULL OR R.IsHidden= 0)
				AND A.AppUrlName IN (N'===Productive Time usage===', N'===UnProductive Time usage===')
	END

END
GO
