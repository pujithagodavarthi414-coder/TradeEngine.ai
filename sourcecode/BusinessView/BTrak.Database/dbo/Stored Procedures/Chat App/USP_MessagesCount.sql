CREATE PROCEDURE [dbo].[USP_MessagesCount]
(
    @SenderId uniqueidentifier=null,
    @ReceiverId uniqueidentifier=null,
    @ChannelId uniqueidentifier=null
)
AS
BEGIN
    IF (@ChannelId = '00000000-0000-0000-0000-000000000000')
    BEGIN
        SET @ChannelId = null
    END
    IF (@ReceiverId = '00000000-0000-0000-0000-000000000000')
    BEGIN
        SET @ReceiverId = null
    END
    IF(@ReceiverId IS NOT NULL)
    BEGIN
        UPDATE [MessageCount] SET IsMessageRead = 1 WHERE SenderId = @SenderId AND ReceiverId = @ReceiverId
    END
    IF(@ChannelId IS NOT NULL)
    BEGIN
        UPDATE [MessageCount] SET IsMessageRead = 1 WHERE SenderId = @SenderId AND ReceiverId = @ReceiverId
    END
    DECLARE @MessageCountvalues TABLE
        (
            SenderUserId UNIQUEIDENTIFIER,
            ReceiverUserId UNIQUEIDENTIFIER,
            ChannelId UNIQUEIDENTIFIER,
            MessageCount INT
        )
    
    INSERT INTO @MessageCountvalues(SenderUserId,ReceiverUserId,MessageCount)
    SELECT SenderId ,ReceiverId, COUNT(Id) MessageCount FROM MessageCount 
    WHERE  ReceiverId = @ReceiverId AND (IsMessageRead = 0 OR IsMessageRead IS NULL)
        AND ChannelId IS NULL
    GROUP BY SenderId,ReceiverId
     
    INSERT INTO @MessageCountvalues(ReceiverUserId,ChannelId,MessageCount)
    SELECT ReceiverId ,ChannelId, COUNT(Id) MessageCount FROM MessageCount 
    WHERE  ReceiverId = @ReceiverId AND (IsMessageRead = 0 OR IsMessageRead IS NULL)
        AND ChannelId IS NOT NULL
    GROUP BY ReceiverId,ChannelId
    
    SELECT * FROM @MessageCountvalues
END
GO

