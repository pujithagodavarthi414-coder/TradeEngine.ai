CREATE PROCEDURE [dbo].[USP_UpsertMessageReadReceipt]
(
	@MessageId UNIQUEIDENTIFIER,
	@SenderUserId UNIQUEIDENTIFIER,
	@OperationsPerformedBy UNIQUEIDENTIFIER, 
	@MessageDateTime DATETIME,
	@IsChannel BIT
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		  IF (@HavePermission = '1')
          BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		DECLARE @ISLATEST UNIQUEIDENTIFIER = (SELECT Id FROM [MessageReadReceipt] WHERE ReceiverUserId = @OperationsPerformedBy AND SenderUserId = @SenderUserId AND IsChannel = @IsChannel)

		IF(@ISLATEST IS NULL)
		BEGIN
			INSERT INTO MessageReadReceipt
			(Id,SenderUserId,ReceiverUserId,MessageId,UpdatedByUserId,UpdatedDateTime,IsChannel)
			VALUES
			(NEWID(),@SenderUserId,@OperationsPerformedBy,@MessageId,@OperationsPerformedBy,GETDATE(),@IsChannel)
		END
		ELSE

			DECLARE @LastMessageId UNIQUEIDENTIFIER = (SELECT TOP(1) Id from [Message] WHERE OriginalCreatedDateTime >= @MessageDateTime AND ((@IsChannel = 0 AND SenderUserId = @SenderUserId AND ReceiverUserId = @OperationsPerformedBy) OR (@IsChannel = 1 AND ChannelId = @SenderUserId AND SenderUserId <> @OperationsPerformedBy)) ORDER BY OriginalCreatedDateTime DESC)
			UPDATE MessageReadReceipt SET MessageId = ISNULL(@LastMessageId,@MessageId),UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE() WHERE Id = @ISLATEST
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