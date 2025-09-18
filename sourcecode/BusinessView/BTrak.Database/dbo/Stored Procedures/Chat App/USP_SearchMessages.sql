--WITHOUT CHANNEL Id
--EXEC [dbo].[USP_SearchMessages] 
--@SenderId = '0B2921A9-E930-4013-9047-670B5352F308', @ReceiverId = '0B2921A9-E930-4013-9047-670B5352F308',
--@OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'
--WITH CHANNEL Id
--EXEC [dbo].[USP_SearchMessages] @ChannelId = 'B86F1525-D899-434A-9274-48C52060136E',
--@SenderId = '127133F1-4427-4149-9DD6-B02E0E036972',
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
--WITHOUT CHANNEL Id
--EXEC [dbo].[USP_SearchMessages] 
--@SenderId = '0B2921A9-E930-4013-9047-670B5352F308', @ReceiverId = '127133F1-4427-4149-9DD6-B02E0E036971',
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--WITH CHANNEL Id
--EXEC [dbo].[USP_SearchMessages] @ChannelId = '610DF008-20DE-4BCA-B027-2AC0DA083708',
--@SenderId = '127133F1-4427-4149-9DD6-B02E0E036972',@IsForSingleMessageDetails = 0,
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--FOR SINGLE MESSAGE DETAILS WITH MESSAGEID
--EXEC [dbo].[USP_SearchMessages] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308', 
--@LastMsgId='783120BA-44DD-4040-AA8F-7AC194E4EB8E', @SenderUserId='0B2921A9-E930-4013-9047-670B5352F308',
--@IsForSingleMessageDetails = 1
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_SearchMessages]
(
	@IsForSingleMessageDetails BIT = NULL,
    @MsgCount INT = NULL,
    @LastMsgId UNIQUEIDENTIFIER = NULL,
    @SenderId UNIQUEIDENTIFIER,  -- Logged In UserId
    @ReceiverId UNIQUEIDENTIFIER = NULL, -- Selected UserId 
    @ChannelId UNIQUEIDENTIFIER = NULL, -- Selected ChannelId
    @IsArchived BIT = NULL,
    @DateFrom DateTime = NULL,
    @DateTo DateTime = NULL,
	@ParentMessageId UNIQUEIDENTIFIER = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
     
           DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
           IF(@HavePermission = '1')
				IF (@IsForSingleMessageDetails IS NULL OR @IsForSingleMessageDetails <> 1)
					BEGIN
            
						DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                
						DECLARE @CurrentDate DATETIME = GETDATE()

						IF(@LastMsgId = '00000000-0000-0000-0000-000000000000') SET @LastMsgId = NULL
               
						IF(@ChannelId = '00000000-0000-0000-0000-000000000000') SET @ChannelId = NULL
               
						IF(@ReceiverId = '00000000-0000-0000-0000-000000000000') SET @ReceiverId = NULL

						IF(@MsgCount IS NULL OR @MsgCount = 0)
						SET @MsgCount = 15

						IF(@ParentMessageId IS NOT NULL) SET @MsgCount = (SELECT COUNT(1) FROM [Message] WHERE InActiveDateTime IS NULL AND ParentMessageId = @ParentMessageId)

						IF(@ChannelId IS NOT NULL)
						BEGIN
                
							SELECT M.Id Id,
									M.ChannelId,
									M.SenderUserId,
									M.TextMessage,
									M.ReceiverUserId,
									M.FilePath,
									(CASE WHEN M.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsDeleted,
									M.[TimeStamp],
									M.OriginalCreatedDateTime AS MessageDateTime,
									M.CreatedByUserId,
									U.FirstName + ' ' + ISNULL(U.SurName,'') AS SenderName,
									U.ProfileImage AS SenderProfileImage,
									M.IsEdited,
									M.IsActivityMessage,
									M.ParentMessageId,
									M.IsPinned,
									M.TaggedMembersIdsXml,
									IIF(SM.Id IS NULL,0,1) AS IsStarred,
									M.LastReplyDateTime,
									ISNULL(P.ThreadCount,0) AS ThreadCount,
									(CASE WHEN (M1.Id IS NULL AND M.SenderUserId <> @OperationsPerformedBy) OR M1.OriginalCreatedDateTime < M.OriginalCreatedDateTime THEN 0 ELSE 1 END) AS IsRead,
									M.PinnedByUserId,
									(SELECT(SELECT ME.Id
													,ME.TextMessage
													,ME.ParentMessageId
													,ME.ReactedByUserId
													,ME.ReactedDateTime
													FROM [Message] ME
													WHERE ME.ReactedDateTime IS NOT NULL 
													AND ME.ReactedByUserId IS NOT NULL 
													AND ME.ParentMessageId IS NOT NULL
													AND ME.InactiveDateTime IS NULL 
													AND ME.ParentMessageId = M.Id
													FOR XML PATH('MessageReactions'), TYPE)FOR XML PATH('MessageReactionModel'), TYPE) AS MessageReactionModel,
									M.ReportMessage
								FROM [Message] M 
									INNER JOIN [User] U ON U.Id = M.SenderUserId
									LEFT JOIN (SELECT ParentMessageId
													,COUNT(1) AS ThreadCount 
													FROM [Message] 
													WHERE InActiveDateTime IS NULL 
													AND ReactedByUserId IS NULL
													GROUP BY ParentMessageId) P ON P.ParentMessageId = M.Id
									LEFT JOIN Channel C ON C.Id = M.ChannelId 
									LEFT JOIN MessageReadReceipt MRR ON MRR.ReceiverUserId = @OperationsPerformedBy  AND M.ChannelId = MRR.SenderUserId AND MRR.IsChannel=1
								    LEFT JOIN [Message] M1 ON M1.ID = MRR.MessageId
									LEFT JOIN StarredMessages SM ON SM.MessageId=M.Id AND SM.CreatedByUserId=@OperationsPerformedBy AND SM.InActiveDateTime IS NULL
							WHERE U.CompanyId = @CompanyId 
									AND M.InactiveDateTime IS NULL
									AND (@ChannelId IS NULL OR M.ChannelId = @ChannelId)
									AND ((@ParentMessageId IS NULL AND M.ParentMessageId IS NULL) OR (@ParentMessageId IS NOT NULL AND M.ParentMessageId = @ParentMessageId AND M.ReactedByUserId IS Null))
									AND (@LastMsgId IS NULL OR (M.OriginalCreatedDateTime < 
									(SELECT OriginalCreatedDateTime FROM [dbo].[Message] WHERE Id = @LastMsgId )))
									AND (@IsArchived IS NULL OR (@IsArchived = 1 AND M.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND M.InActiveDateTime IS NULL)) 
							ORDER BY M.OriginalCreatedDateTime DESC OFFSET 0 ROWS
							FETCH NEXT @MsgCount ROWS ONLY
		
						END
						ELSE
						BEGIN
                 
							SELECT M.Id,
									M.ChannelId,
									M.SenderUserId,
									M.ReceiverUserId,
									M.TextMessage,
									M.FilePath,
									(CASE WHEN M.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsDeleted,
									M.[TimeStamp],
									M.OriginalCreatedDateTime AS MessageDateTime,
									M.CreatedByUserId,
									SU.FirstName + ' ' + ISNULL(SU.SurName,'') AS SenderName,
									SU.ProfileImage AS SenderProfileImage,
									RU.ProfileImage AS ReceiverProfileImage,
									RU.FirstName + ' ' + ISNULL(RU.SurName,'') AS ReceiverName,
									M.IsEdited,
									M.ParentMessageId,
									M.IsPinned,
									M.TaggedMembersIdsXml,
									IIF(SM.Id IS NULL,0,1) AS IsStarred,
									M.LastReplyDateTime,
									ISNULL(P.ThreadCount,0) AS ThreadCount,
									(CASE WHEN (M1.Id IS  NULL AND M.SenderUserId = @SenderId) OR  M1.OriginalCreatedDateTime < M.OriginalCreatedDateTime THEN 0 ELSE 1 END) AS IsRead,
									M.PinnedByUserId,
									(SELECT(SELECT ME.Id
													,ME.TextMessage
													,ME.ParentMessageId
													,ME.ReactedByUserId
													,ME.ReactedDateTime
													FROM [Message] ME
													WHERE ME.ReactedDateTime IS NOT NULL 
													AND ME.ReactedByUserId IS NOT NULL 
													AND ME.ParentMessageId IS NOT NULL
													AND ME.InactiveDateTime IS NULL 
													AND ME.ParentMessageId = M.Id
													FOR XML PATH('MessageReactions'), TYPE)FOR XML PATH('MessageReactionModel'), TYPE) AS MessageReactionModel,
									M.ReportMessage
									FROM [Message] M 
									INNER JOIN [User] SU ON SU.Id = M.SenderUserId
									LEFT JOIN (SELECT ParentMessageId
													,COUNT(1) AS ThreadCount 
													FROM [Message] 
													WHERE InActiveDateTime IS NULL 
													AND ReactedByUserId IS NULL
													GROUP BY ParentMessageId) P ON P.ParentMessageId = M.Id
									LEFT JOIN [User] RU ON RU.Id = M.ReceiverUserId
									LEFT JOIN MessageReadReceipt MRR ON MRR.ReceiverUserId = @OperationsPerformedBy  AND M.SenderUserId = MRR.SenderUserId AND MRR.IsChannel=0
								    LEFT JOIN [Message] M1 ON M1.ID = MRR.MessageId
									LEFT JOIN StarredMessages SM ON SM.MessageId=M.Id AND SM.CreatedByUserId=@OperationsPerformedBy AND SM.InActiveDateTime IS NULL
							WHERE ((M.SenderUserId = @SenderId AND M.ReceiverUserId = @ReceiverId) OR (M.SenderUserId = @ReceiverId AND M.ReceiverUserId = @SenderId))
									AND M.ChannelId IS NULL 
									AND M.InactiveDateTime IS NULL
									AND ((@ParentMessageId IS NULL AND M.ParentMessageId IS NULL) OR (@ParentMessageId IS NOT NULL AND M.ParentMessageId = @ParentMessageId AND M.ReactedByUserId IS Null))
									AND SU.CompanyId = @CompanyId
									AND (@LastMsgId IS NULL OR (M.OriginalCreatedDateTime < (SELECT OriginalCreatedDateTime FROM [Message] WHERE Id = @LastMsgId )))
							ORDER BY M.OriginalCreatedDateTime DESC OFFSET 0 ROWS
							FETCH NEXT @MsgCount ROWS ONLY
                   
						END
					END
				ELSE 
					BEGIN
						SELECT M.Id,
                          M.ChannelId,
                          M.SenderUserId,
						  M.ReceiverUserId,
                          M.TextMessage,
                          M.FilePath,
                          (CASE WHEN M.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsDeleted,
                          M.[TimeStamp],
                          M.OriginalCreatedDateTime AS MessageDateTime,
                          M.CreatedByUserId,
                          U.FirstName + ' ' + ISNULL(U.SurName,'') AS SenderName,
                          U.ProfileImage AS SenderProfileImage,
                          M.IsEdited,
                          M.IsActivityMessage,
						  M.ParentMessageId,
						  M.IsPinned,
						  M.TaggedMembersIdsXml,
						  ISNULL((SELECT IIF(SM.MessageId IS NULL,0,1) FROM [StarredMessages] SM WHERE SM.MessageId = M.Id AND SM.InActiveDateTime IS NULL),0) AS IsStarred,
						  M.LastReplyDateTime,
						  (SELECT COUNT(1) FROM [Message] M WHERE M.ParentMessageId = @LastMsgId AND M.InActiveDateTime IS NULL AND M.ReactedByUserId IS NULL) AS ThreadCount,
						  M.PinnedByUserId,
						    (SELECT(SELECT ME.Id
						                  ,ME.TextMessage
                                          ,ME.ParentMessageId
										  ,ME.ReactedByUserId
										  ,ME.ReactedDateTime
	                                      FROM [Message] ME
	                                      WHERE ME.ReactedDateTime IS NOT NULL 
	                                       AND ME.ReactedByUserId IS NOT NULL 
		                                   AND ME.ParentMessageId IS NOT NULL
										   AND ME.InactiveDateTime IS NULL 
										   AND ME.ParentMessageId = M.Id
										  FOR XML PATH('MessageReactions'), TYPE)FOR XML PATH('MessageReactionModel'), TYPE) AS MessageReactionModel,
							M.ReportMessage
					 FROM [Message] M INNER JOIN [User] U ON M.SenderUserId = U.Id AND M.Id=@LastMsgId
					END
			ELSE
				BEGIN
           
						RAISERROR (@HavePermission,10, 1)
           
				   END
    END TRY
    BEGIN CATCH
    
            THROW
    END CATCH
END
GO