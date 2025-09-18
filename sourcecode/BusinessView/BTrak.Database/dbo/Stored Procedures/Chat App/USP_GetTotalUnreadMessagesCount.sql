CREATE PROCEDURE [dbo].[USP_GetTotalUnreadMessagesCount]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
            IF (@HavePermission = '1')
                BEGIN
                        DECLARE @CompanyId UNIQUEIDENTIFIER

                        SELECT @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

                        DECLARE @ChannelUnreads INT,@Memberunreads INT

                        SET @ChannelUnreads = (SELECT COUNT(1) AS UnreadChannelMessageCount
                                               FROM [Message] M
                                                   INNER JOIN ChannelMember CM ON CM.MemberUserId = @OperationsPerformedby AND CM.ChannelId = M.ChannelId
                                                   INNER JOIN Channel C ON C.Id = CM.ChannelId AND C.InActiveDateTime IS NULL
                                                   LEFT JOIN (
                                                               SELECT MR.SenderUserId,MR.ReceiverUserId,MR.Id,M.OriginalCreatedDateTime 
                                                               FROM MessageReadReceipt MR INNER JOIN [Message] M ON MR.MessageId = M.Id AND MR.IsChannel = 1
                                                              ) MR ON MR.SenderUserId = M.ChannelId AND MR.ReceiverUserId = @OperationsPerformedby 
                                               WHERE (MR.Id IS NULL OR M.OriginalCreatedDateTime > MR.OriginalCreatedDateTime)
                                               AND M.ChannelId IS NOT NULL
                                               AND M.SenderUserId <> @OperationsPerformedby
                                               AND M.InactiveDateTime IS NULL
                                               AND CM.InactiveDateTime IS NULL
                                               AND M.ParentMessageId IS NULL)

                        SET @Memberunreads = (SELECT COUNT(1) AS UnreadMessageCount 
                                              FROM [Message] M 
                                              LEFT JOIN MessageReadReceipt MR ON MR.SenderUserId = M.SenderUserId AND MR.ReceiverUserId = M.ReceiverUserId
                                              WHERE (MR.Id IS NULL OR M.OriginalCreatedDateTime > (SELECT OriginalCreatedDateTime FROM [Message] WHERE Id = MR.MessageId))
                                              AND M.ChannelId IS NULL
                                              AND (MR.Id IS NULL OR MR.IsChannel = 0)
                                              AND M.InactiveDateTime IS NULL 
                                              AND M.ParentMessageId IS NULL
                                              AND M.ReceiverUserId = @OperationsPerformedBy
                                              AND M.SenderUserId <> @OperationsPerformedBy)

                        SELECT @ChannelUnreads AS ChannelsUnreadMessagesCount, @Memberunreads AS UsersUnreadMessagesCount
                END
            ELSE
            BEGIN
                RAISERROR(@HavePermission,11,1)
            END
     END TRY
     BEGIN CATCH
        
           THROW

    END CATCH
END
GO

