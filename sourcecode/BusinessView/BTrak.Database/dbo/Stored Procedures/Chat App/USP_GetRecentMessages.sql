-------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-07-25 00:00:00.000'
-- Purpose      To Get Recent Messages By Appliying Logged in User Id
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetRecentMessages] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ConversationId = '9E30DF2F-71DB-466D-832F-63DDB280DCA8',@MessageId = '75981EC0-AF4B-40C4-8EE5-11D21BF72706'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetRecentMessages]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @ConversationId UNIQUEIDENTIFIER,
    @MessageId UNIQUEIDENTIFIER,
    @IsChannel BIT = 0
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

           DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

           IF(@HavePermission = '1')
           BEGIN
            
                IF(@IsChannel IS NULL) SET @IsChannel = 0
                
                IF(@ConversationId = '00000000-0000-0000-0000-000000000000') SET @ConversationId = NULL

                IF(@MessageId = '00000000-0000-0000-0000-000000000000') SET @MessageId = NULL
				IF(@IsChannel IS NULL OR @IsChannel = 0)
				BEGIN
                SELECT M.Id
                       ,M.ChannelId
                       ,C.ChannelName
                       ,M.SenderUserId
                       ,RU.Id AS ReceiverUserId
                       ,M.MessageTypeId
                       ,M.TextMessage
                       ,M.ParentMessageId
					   ,ISNULL(P.ThreadCount,0) AS ThreadCount
                       ,M.IsDeleted
                       ,M.OriginalCreatedDateTime AS MessageDateTime
                       ,M.LastReplyDateTime
                       ,M.FilePath
                       ,RU.FirstName + ' ' + ISNULL(RU.SurName,'') AS ReceiverName
                       ,RU.ProfileImage AS ReceiverProfileImage
                       ,SU.FirstName + ' ' + ISNULL(SU.SurName,'') AS SenderName
                       ,SU.ProfileImage AS SenderProfileImage
                       ,M.TimeStamp
                       ,M.IsEdited
                       ,M.IsActivityMessage
                       ,M.IsPinned
					   ,IIF(SM.Id IS NULL,0,1) AS IsStarred
                       ,M.PinnedByUserId
                       ,(SELECT(SELECT ME.Id
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
								FOR XML PATH('MessageReactions'), TYPE)
                        FOR XML PATH('MessageReactionModel'), TYPE) AS MessageReactionModel
                       ,M.ReportMessage 
                       ,M.TaggedMembersIdsXml
					   ,(CASE WHEN MRR.MessageId IS NULL THEN 0 ELSE 1 END) AS IsRead
                FROM [Message] M
                     LEFT JOIN Channel C ON C.Id = M.ChannelId AND @IsChannel = 1
                     LEFT JOIN [User] SU ON SU.Id = M.SenderUserId
                     LEFT JOIN [User] RU ON RU.Id = M.ReceiverUserId
                     LEFT JOIN (SELECT ParentMessageId
								       ,COUNT(1) AS ThreadCount 
								FROM [Message] 
								WHERE InActiveDateTime IS NULL 
								AND ReactedByUserId IS NULL
								GROUP BY ParentMessageId
                               ) P ON P.ParentMessageId = M.Id
					 LEFT JOIN StarredMessages SM ON SM.MessageId = M.Id AND SM.CreatedByUserId = @OperationsPerformedBy AND SM.InActiveDateTime IS NULL
					 LEFT JOIN MessageReadReceipt MRR ON M.Id=MRR.MessageId AND MRR.ReceiverUserId = @OperationsPerformedBy  AND M.SenderUserId = MRR.SenderUserId AND MRR.IsChannel=0 
                WHERE ((@IsChannel = 1 AND M.ChannelId = @ConversationId) 
                       OR (@IsChannel = 0 AND ((M.SenderUserId = @ConversationId AND M.ReceiverUserId = @OperationsPerformedBy) 
                                                OR (M.SenderUserId = @OperationsPerformedBy AND M.ReceiverUserId = @ConversationId))
                          ))
                      AND M.CreatedDateTime > (SELECT CreatedDateTime FROM [Message] WHERE Id = @MessageId)
                      AND M.InActiveDateTime IS NULL
			END
			ELSE
			BEGIN

			SELECT M.Id
                       ,M.ChannelId
                       ,C.ChannelName
                       ,M.SenderUserId
                       ,RU.Id AS ReceiverUserId
                       ,M.MessageTypeId
                       ,M.TextMessage
                       ,M.ParentMessageId
					   ,ISNULL(P.ThreadCount,0) AS ThreadCount
                       ,M.IsDeleted
                       ,M.OriginalCreatedDateTime AS MessageDateTime
                       ,M.LastReplyDateTime
                       ,M.FilePath
                       ,RU.FirstName + ' ' + ISNULL(RU.SurName,'') AS ReceiverName
                       ,RU.ProfileImage AS ReceiverProfileImage
                       ,SU.FirstName + ' ' + ISNULL(SU.SurName,'') AS SenderName
                       ,SU.ProfileImage AS SenderProfileImage
                       ,M.TimeStamp
                       ,M.IsEdited
                       ,M.IsActivityMessage
                       ,M.IsPinned
					   ,IIF(SM.Id IS NULL,0,1) AS IsStarred
                       ,M.PinnedByUserId
                       ,(SELECT(SELECT ME.Id
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
								FOR XML PATH('MessageReactions'), TYPE)
                        FOR XML PATH('MessageReactionModel'), TYPE) AS MessageReactionModel
                       ,M.ReportMessage 
                       ,M.TaggedMembersIdsXml
					   ,(CASE WHEN (MRR.MessageId IS NULL AND M.SenderUserId <> @OperationsPerformedBy) THEN 0 ELSE 1 END) AS IsRead
                FROM [Message] M
                     LEFT JOIN Channel C ON C.Id = M.ChannelId AND @IsChannel = 1
                     LEFT JOIN [User] SU ON SU.Id = M.SenderUserId
                     LEFT JOIN [User] RU ON RU.Id = M.ReceiverUserId
                     LEFT JOIN (SELECT ParentMessageId
								       ,COUNT(1) AS ThreadCount 
								FROM [Message] 
								WHERE InActiveDateTime IS NULL 
								AND ReactedByUserId IS NULL
								GROUP BY ParentMessageId
                               ) P ON P.ParentMessageId = M.Id
					 LEFT JOIN StarredMessages SM ON SM.MessageId = M.Id AND SM.CreatedByUserId = @OperationsPerformedBy AND SM.InActiveDateTime IS NULL
					 LEFT JOIN MessageReadReceipt MRR ON M.Id=MRR.MessageId AND MRR.ReceiverUserId = @OperationsPerformedBy  AND M.ChannelId = MRR.SenderUserId AND MRR.IsChannel=1
                WHERE ((@IsChannel = 1 AND M.ChannelId = @ConversationId) 
                       OR (@IsChannel = 0 AND ((M.SenderUserId = @ConversationId AND M.ReceiverUserId = @OperationsPerformedBy) 
                                                OR (M.SenderUserId = @OperationsPerformedBy AND M.ReceiverUserId = @ConversationId))
                          ))
                      AND M.CreatedDateTime > (SELECT CreatedDateTime FROM [Message] WHERE Id = @MessageId)
                      AND M.InActiveDateTime IS NULL

			END

           END
           ELSE
           BEGIN
           
                RAISERROR (@HavePermission,11, 1)
           
           END
    END TRY
    BEGIN CATCH
    
            THROW
    
	END CATCH
END
GO