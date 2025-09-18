CREATE PROCEDURE [dbo].[USP_MessageInsertWithRead]
(
	@Id uniqueidentifier,
	@ChannelId uniqueidentifier,
	@SenderUserId uniqueidentifier,
	@ReceiverUserId uniqueidentifier,
	@MessageTypeId uniqueidentifier,
	@TextMessage nvarchar(800),
	@IsDeleted bit,
	@CreatedDateTime datetime,
	@CreatedByUserId uniqueidentifier,
	@FilePath nvarchar(800)
)
AS
BEGIN
SET NOCOUNT ON
		INSERT INTO [Message]([Id],[ChannelId],[SenderUserId],[ReceiverUserId],[MessageTypeId],[TextMessage],[IsDeleted],[CreatedDateTime],[CreatedByUserId],[FilePath]) 
		VALUES (@Id,@ChannelId,@SenderUserId,@ReceiverUserId,@MessageTypeId,@TextMessage,@IsDeleted,@CreatedDateTime,@CreatedByUserId, @FilePath)

		IF(@ChannelId = '00000000-0000-0000-0000-000000000000')
			SET @ChannelId = NULL
		
		IF(@ChannelId IS NULL)
		BEGIN
			INSERT INTO MessageCount VALUES(NEWID(),@Id,@SenderUserId,@ReceiverUserId,@ChannelId,0)
		END
		
		ELSE
			IF(@ReceiverUserId = '00000000-0000-0000-0000-000000000000')
			SET @ReceiverUserId = NULL

				BEGIN
					DECLARE @ChannelMember TABLE
					(
						UserId UNIQUEIDENTIFIER
					)

					INSERT INTO @ChannelMember
					SELECT MemberUserId FROM ChannelMember
					WHERE ChannelId = @ChannelId AND MemberUserId <> @SenderUserId
					
					INSERT INTO MessageCount([Id],[MessageId],[SenderId],[ReceiverId],[ChannelId],[IsMessageRead]) 
					SELECT NEWID(),@Id,@SenderUserId,UserId,@ChannelId,0
					FROM @ChannelMember
				END
	select * from @ChannelMember
END	
