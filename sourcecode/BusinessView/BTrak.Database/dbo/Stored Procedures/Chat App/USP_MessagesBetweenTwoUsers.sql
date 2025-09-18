CREATE PROCEDURE [dbo].[USP_MessagesBetweenTwoUsers]
(
    @MsgCount INT = NULL,
    @LastMsgId UNIQUEIDENTIFIER = NULL,
    @SenderId uniqueidentifier,
    @ReceiverId uniqueidentifier=null,
    @ChannelId uniqueidentifier=null
)
AS
BEGIN
SET NOCOUNT ON
    IF (@ChannelId = '00000000-0000-0000-0000-000000000000') SET @ChannelId = null
    IF (@LastMsgId = '00000000-0000-0000-0000-000000000000') SET @LastMsgId = null
    IF (@MsgCount IS NULL) SET @MsgCount = 15
    DECLARE @Required datetime
         IF(@LastMsgId IS NOT NULL) 
         SET @Required = (SELECT CreatedDateTime FROM [Message] WHERE Id = @LastMsgId)
    IF(@ChannelId IS NULL)
         BEGIN
             SELECT M.*,RId.FirstName ReceiverName,RId.ProfileImage ReceiverProfileImage,U.FirstName SenderName,U.ProfileImage SenderProfileImage, M.FilePath
             FROM [Message] M JOIN [User] RId ON RId.Id = M.ReceiverUserId LEFT JOIN [User] U ON U.Id = M.SenderUserId
             WHERE  (([SenderUserId] = @SenderId And [ReceiverUserId] = @ReceiverId) or ([SenderUserId] = @ReceiverId And [ReceiverUserId] = @SenderId))
                   AND (@LastMsgId IS NULL OR (M.CreatedDateTime < @Required))
                   ORDER BY M.CreatedDateTime DESC OFFSET 0 ROWS
             FETCH NEXT @MsgCount ROWS ONLY
                 
             DELETE [MessageCount] WHERE SenderId=@ReceiverId AND ReceiverId=@SenderId AND ChannelId IS NULL
         END 
    ELSE
          BEGIN
            IF (@SenderId = '00000000-0000-0000-0000-000000000000')
            BEGIN
                SET @SenderId = null
            END
            
                SELECT M.*,U.FirstName SenderName,U.SurName,U.ProfileImage SenderProfileImage, M.FilePath
                FROM [Message] M LEFT JOIN Channel C ON C.Id = M.ChannelId  JOIN [User] U on U.Id=M.SenderUserId
                WHERE (@LastMsgId IS NULL OR M.CreatedDateTime < @Required) AND (ChannelId IS NOT NULL AND ChannelId=@ChannelId) 
                ORDER BY M.CreatedDateTime DESC OFFSET 0 ROWS
                FETCH NEXT @MsgCount ROWS ONLY
                
                DELETE [MessageCount] WHERE ChannelId=@ChannelId AND ReceiverId=@ReceiverId
            
          END
END
