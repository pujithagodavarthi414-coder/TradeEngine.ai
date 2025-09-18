-------------------------------------------------------------------------------
-- WITHOUT CHANNEL Id
-- EXEC [dbo].[USP_UpsertMessage]
-- @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
-- @SenderUserId = '127133F1-4427-4149-9DD6-B02E0E036971',
-- @ReceiverUserId = '127133F1-4427-4149-9DD6-B02E0E036972',@TextMessage ='test',
-- @MessageType = 'Text'

-- WITH CHANNEL Id
-- EXEC [dbo].[USP_UpsertMessage] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-- ,@SenderUserId = '127133F1-4427-4149-9DD6-B02E0E036971',
-- @ReceiverUserId = '127133F1-4427-4149-9DD6-B02E0E036972',@TextMessage  ='test',
-- @MessageType = 'Text',@ChannelId = 'B86F1525-D899-434A-9274-48C52060136E'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertMessage]
(
    @MessageId UNIQUEIDENTIFIER = NULL,
	@ChannelId UNIQUEIDENTIFIER = NULL,
	@SenderUserId UNIQUEIDENTIFIER = NULL,
	@ReceiverUserId UNIQUEIDENTIFIER = NULL,
	@TextMessage NVARCHAR(800) = NULL,
	@IsDeleted BIT = NULL,
	@FilePath NVARCHAR(800) = NULL,
	@MessageType NVARCHAR(100) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@TimeStamp TIMESTAMP = NULL,
	@IsActivityMessage BIT =  NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	       DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		  IF (@HavePermission = '1')
          BEGIN

	                  IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
	                  
	                  IF (@SenderUserId = '00000000-0000-0000-0000-000000000000') SET @SenderUserId = NULL

					  IF (@MessageId = '00000000-0000-0000-0000-000000000000' OR @MessageId IS NULL) SET @MessageId = NEWID()
	                  
	                  IF (@MessageType = '') SET @MessageType = NULL

					  DECLARE @IsChannelMember BIT = (CASE WHEN EXISTS(SELECT 1 FROM ChannelMember 
					                                                   WHERE ChannelId = @ChannelId 
																	     AND MemberUserId = @SenderUserId 
																	     AND AsAtInactiveDateTime IS NULL 
																		 AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)

					  IF(@ChannelId IS NOT NULL AND @IsChannelMember = 0)
					  BEGIN

						RAISERROR('SeemsYouAreRemovedFromTheChannel',11,1)

					  END

					  --DECLARE @MessageIdCount INT = (SELECT COUNT(1) FROM [dbo].[Message] WHERE OriginalId = @MessageId AND AsAtInactiveDateTime IS NULL)
	                  
	                  IF(@SenderUserId IS NULL)
	                  BEGIN
		           
		                RAISERROR(50011,16, 2, 'Sender')
		        
	                  END
	                  ELSE IF(@MessageType IS NULL)
	                  BEGIN
		                  
		                  RAISERROR(50011,16, 2, 'MessageType')
	                 
	                  END
	                  ELSE 
	                  BEGIN
		        			
		        			 IF (@MessageId = '00000000-0000-0000-0000-000000000000') SET @MessageId = NULL
		        			   
		        			 IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		        			   
		        			 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		        
				             DECLARE @IsEdited BIT = 0

							 DECLARE @IsOldEdited BIT = 0

		        		     IF(@MessageId IS NOT NULL AND (@IsDeleted = 0 OR @IsDeleted IS NULL))
							 BEGIN

							 SET @IsEdited = 1 

							 END 
							 
							 DECLARE @Currentdate DATETIME = GETDATE()
		        
		        		     DECLARE @NewMessageId UNIQUEIDENTIFIER = NEWID()
		        		
		        		     DECLARE @MessageTypeId UNIQUEIDENTIFIER = (SELECT Id FROM [MessageType] M WHERE M.MessageTypeName = @MessageType)
		        			   
		        		     DECLARE @VersionNumber INT , @OriginalCreatedDateTime DATETIME
     	        		      
		        		     SELECT @IsOldEdited = IsEdited, @VersionNumber = VersionNumber, @OriginalCreatedDateTime = OriginalCreatedDateTime  FROM [Message] WHERE OriginalId = @MessageId AND AsAtInActiveDateTime IS NULL
		        
		        			 UPDATE [Message] SET AsAtInactiveDateTime = @CurrentDate WHERE OriginalId = @MessageId AND AsAtInActiveDateTime IS NULL
		        		
		        		     INSERT INTO [dbo].[Message](
		        						  [Id],
		        						  [ChannelId],
		        						  [SenderUserId],
		        						  [ReceiverUserId],
		        						  [TextMessage],
		        						  [InActiveDateTime],
										  [IsEdited],
										  [IsDeleted],
										  [IsActivityMessage],
		        						  [MessageTypeId],
		        						  [FilePath],
		        						  [VersionNumber],
		        						  [OriginalId],
		        						  [CreatedByUserId],
		        						  [OriginalCreatedDateTime],
		        						  [CreatedDateTime])
		        			   	  VALUES (CASE WHEN  @VersionNumber IS NULL THEN @MessageId ELSE @NewMessageId END,
		        					 	  @ChannelId,
		        					 	  @SenderUserId,
		        						  @ReceiverUserId,
		        					 	  @TextMessage,
		        					 	  (CASE WHEN @IsDeleted = 1 THEN @Currentdate ELSE NULL END),
										  (CASE WHEN  @VersionNumber IS NULL THEN 0 ELSE 1 END),
										  (CASE WHEN @IsDeleted = 1 THEN 1 ELSE NULL END),
										  @IsActivityMessage,
		        					 	  @MessageTypeId,
		        					 	  @FilePath,
		        						  ISNULL(@VersionNumber,0) + 1,
		        						  ISNULL(@MessageId,@NewMessageId),
		        						  @OperationsPerformedBy,
		        						  ISNULL(@OriginalCreatedDateTime,@Currentdate),
		        						  @Currentdate)
		        			  		
								   IF (@VersionNumber IS NULL)
								     
		        					EXEC [dbo].[USP_UpsertMessageReadReceipt] @MessageId,@ChannelId,@ReceiverUserId,NULL,NULL,@SenderUserId
		        
		        			       SELECT OriginalId,[TimeStamp] FROM [dbo].[Message] WHERE Id = (CASE WHEN  @VersionNumber IS NULL THEN @MessageId ELSE @NewMessageId END)
		        
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