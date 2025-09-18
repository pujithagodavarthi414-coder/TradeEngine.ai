-------------------------------------------------------------------------------------------------
-- EXEC USP_GetAllStarredMessages @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308' , @ChannelId='60A88538-21D9-40B0-A15E-AC54D132232A'
-------------------------------------------------------------------------------------------------

CREATE PROCEDURE USP_GetAllStarredMessages
(
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@ChannelId UNIQUEIDENTIFIER = NULL,
	@ReceiverId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
			DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			IF(@HavePermission = '1')
			BEGIN
				IF @OperationsPerformedBy IS NULL
				BEGIN
					RAISERROR('OperationPerformedByIdShouldNotBeEmpty',11,1);
				END
				ELSE
					IF @ReceiverId IS NOT NULL
					BEGIN
					SELECT M.Id AS MessageId,
						M.ChannelId,
						M.OriginalCreatedDateTime AS MessageCreatedDateTime,
						M.TextMessage AS Message,
						M.FilePath,
						(SELECT MR.TextMessage AS 'Reaction'
										FROM [Message] MR WHERE MR.ParentMessageId = M.Id AND MR.ReactedByUserId IS NOT NULL AND MR.InActiveDateTime IS NULL 
										FOR JSON AUTO) AS ReactionsJson,
						(SELECT Count(1) FROM [Message] MR WHERE MR.ParentMessageId = S.MessageId AND MR.ReactedByUserId IS  NULL AND MR.InActiveDateTime IS NULL 
										) AS ThreadMessagesCount,
						M.SenderUserId,
						M.ReceiverUserId,
						M.TaggedMembersIdsXml AS TaggedMembersXml,
						M.[TimeStamp],
						M.ParentMessageId,
						M.IsPinned,
						M.PinnedByUserId,
						S.CreatedDateTime AS StarredDateTime
						 FROM StarredMessages S LEFT JOIN [Message] M 
											ON M.Id = S.MessageId AND S.InActiveDateTime IS NULL 
												AND M.InActiveDateTime Is NULL
												AND ((M.SenderUserId = @OperationsPerformedBy AND ReceiverUserId = @ReceiverId) OR (M.SenderUserId = @ReceiverId AND ReceiverUserId = @OperationsPerformedBy)) 
												AND S.CreatedByUserId=@OperationsPerformedBy
												WHERE M.Id IS NOT NULL;
												
				END
					ELSE IF @ChannelId IS NOT NULL
					BEGIN
					SELECT M.Id AS MessageId,
						M.ChannelId,
						M.OriginalCreatedDateTime AS MessageCreatedDateTime,
						M.TextMessage AS Message,
						M.FilePath,
						(SELECT MR.TextMessage AS 'Reaction'
										FROM [Message] MR WHERE MR.ParentMessageId = M.Id AND MR.ReactedByUserId IS NOT NULL AND MR.InActiveDateTime IS NULL 
										FOR JSON AUTO) AS ReactionsJson,
						(SELECT COUNT(1) FROM [Message] MR WHERE MR.ParentMessageId = S.MessageId AND MR.ReactedByUserId IS  NULL AND MR.InActiveDateTime IS NULL 
										) AS ThreadMessagesCount,
						M.SenderUserId,
						M.ReceiverUserId,
						M.TaggedMembersIdsXml AS TaggedMembersXml,
						M.[TimeStamp],
						M.ParentMessageId,
						M.IsPinned,
						M.PinnedByUserId,
						S.CreatedDateTime AS StarredDateTime
						 FROM StarredMessages S LEFT JOIN [Message] M 
											ON M.Id = S.MessageId AND S.InActiveDateTime IS NULL 
												AND M.InActiveDateTime Is NULL 
												AND (M.ChannelId=@ChannelId) 
												AND S.CreatedByUserId=@OperationsPerformedBy
												WHERE M.Id IS NOT NULL;
				END 
					ELSE
					BEGIN
					SELECT M.Id AS MessageId,
						M.ChannelId,
						M.OriginalCreatedDateTime AS MessageCreatedDateTime,
						M.TextMessage AS Message,
						M.FilePath,
						(SELECT MR.TextMessage AS 'Reaction'
										FROM [Message] MR WHERE MR.ParentMessageId = M.Id AND MR.ReactedByUserId IS NOT NULL AND MR.InActiveDateTime IS NULL 
										FOR JSON AUTO) AS ReactionsJson,
						(SELECT Count(1) FROM [Message] MR WHERE MR.ParentMessageId = S.MessageId AND MR.ReactedByUserId IS  NULL AND MR.InActiveDateTime IS NULL 
										) AS ThreadMessagesCount,
						M.SenderUserId,
						M.ReceiverUserId,
						M.TaggedMembersIdsXml AS TaggedMembersXml,
						M.[TimeStamp],
						M.ParentMessageId,
						M.IsPinned,
						M.PinnedByUserId,
						S.CreatedDateTime AS StarredDateTime
						 FROM StarredMessages S LEFT JOIN [Message] M 
											ON M.Id = S.MessageId AND S.InActiveDateTime IS NULL 
												AND M.InActiveDateTime Is NULL
												AND (M.SenderUserId=@OperationsPerformedBy OR M.ReceiverUserId=@OperationsPerformedBy) 
												AND S.CreatedByUserId=@OperationsPerformedBy
												WHERE M.Id IS NOT NULL

												--SELECT @OperationsPerformedBy

				END
			END
			ELSE
			BEGIN
				RAISERROR('HavePermission',11,1);
			END
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END
GO
