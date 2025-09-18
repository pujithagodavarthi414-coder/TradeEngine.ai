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
	@ParentMessageId UNIQUEIDENTIFIER = NULL,
	@IsActivityMessage BIT =  NULL,
	@IsPinned BIT =  NULL,
	@IsStarred BIT =  NULL,
	@PinnedByUserId UNIQUEIDENTIFIER=Null,
	@ReactedByUserId UNIQUEIDENTIFIER=Null,
	@TaggedMembersIdsXml XML = NULL,
	@IsFromBackend BIT = 0,
	@ReportMessage NVARCHAR(MAX) = NULL,
	@LastReplayDateTime datetime = NULL
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

					  DECLARE @IsAlreadyExistingMessage BIT = IIF((SELECT Id FROm [Message] WHERE Id = @MessageId) IS NULL,0,1)

					IF(@IsStarred IS NULL)
						BEGIN

								IF(@ReportMessage IS NULL)
								BEGIN

									DECLARE @IsChannelMember BIT = (CASE WHEN EXISTS(SELECT 1 FROM ChannelMember 
																				WHERE ChannelId = @ChannelId 
																					AND MemberUserId = @SenderUserId
																					AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)

									IF(@ChannelId IS NOT NULL AND @IsChannelMember = 0)
									BEGIN

										RAISERROR('SeemsYouAreRemovedFromTheChannel',11,1)

									END
								
								END
	                  
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
		        		
		        						DECLARE @MessageTypeId UNIQUEIDENTIFIER = (SELECT Id FROM [MessageType] M WHERE M.MessageTypeName = @MessageType AND CompanyId = @CompanyId)
		        			 
										DECLARE @Pinned BIT = (SELECT IsPinned FROM [Message] WHERE Id = @MessageId)
							 
										DECLARE @PinnedUser UNIQUEIDENTIFIER = (SELECT PinnedByUserId FROM [Message] WHERE Id = @MessageId)

		        						DECLARE @VersionNumber INT , @OriginalCreatedDateTime DATETIME
     	        		      
		        						SELECT @IsOldEdited = IsEdited, @OriginalCreatedDateTime = OriginalCreatedDateTime  FROM [Message] WHERE Id = @MessageId
										
										IF(@ChannelId IS NOT NULL)
										BEGIN
											
											UPDATE Channel SET LastMessageDateTime = @Currentdate
											WHERE Id = @ChannelId

										END

										IF (@ParentMessageId IS NOT NULL AND @LastReplayDateTime Is Null)
										BEGIN
										
											UPDATE [Message] SET LastReplyDateTime = @CurrentDate WHERE Id = @ParentMessageId

										END

										IF (@ParentMessageId IS NOT NULL  AND @ReactedByUserId IS NOT NULL)
										BEGIN

											DELETE From [Message] WHERE Id  IN (SELECT Id FROM [Message] M WHERE M.TextMessage = @TextMessage AND M.ReactedByUserId = @ReactedByUserId AND M.ParentMessageId = @ParentMessageId)

										END

										IF (@IsAlreadyExistingMessage = 0)
										BEGIN
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
		        														[CreatedByUserId],
																		[ParentMessageId],
		        														[OriginalCreatedDateTime],
		        														[CreatedDateTime],
																		[IsPinned],
																		[PinnedByUserId],
																		[ReactedByUserId],
																		[ReactedDateTime],
																		[TaggedMembersIdsXml],
																		[ReportMessage])
																 SELECT @MessageId,
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
		        														@OperationsPerformedBy,
																		@ParentMessageId,
		        														ISNULL(@OriginalCreatedDateTime,@Currentdate),
		        														@Currentdate,
																		@Pinned,
																		@PinnedByUserId,
																		@ReactedByUserId,
																		@Currentdate,
																		@TaggedMembersIdsXml,
																		@ReportMessage

				     IF(@ChannelId IS NULL AND @ReceiverUserId IS NOT NULL)
					 BEGIN

						DECLARE @IsNew UNIQUEIDENTIFIER = (SELECT Id From RecentConversations 
					   WHERE ((SenderId = @SenderUserId AND ReceiverId = @ReceiverUserId) 
					   OR (ReceiverId = @SenderUserId AND SenderId = @ReceiverUserId)))
					   IF (@IsNew IS NULL)
					   BEGIN
							INSERT INTO [dbo].[RecentConversations](
										Id
										,SenderId
										,ReceiverId
										,RecentMessageDateTime)
								SELECT NEWID()
										,@SenderUserId
										,@ReceiverUserId
										,@Currentdate
									
						END
						ELSE
						BEGIN

							UPDATE [dbo].[RecentConversations]
									  SET RecentMessageDateTime = @Currentdate
								WHERE Id = @IsNew

						END
						END
										END
										ELSE IF (@IsAlreadyExistingMessage = 1)
										BEGIN
                    			     		UPDATE [Message] SET TextMessage = @TextMessage, IsEdited = @IsEdited WHERE Id = @MessageId
											 
										IF (@IsDeleted IS NOT NULL)
										BEGIN

											IF (@ParentMessageId IS NOT NULL AND @LastReplayDateTime Is Not Null)
										BEGIN
										
											UPDATE [Message] SET LastReplyDateTime = @LastReplayDateTime WHERE Id = @ParentMessageId

										END

											UPDATE [Message] SET IsDeleted = @IsDeleted,InActiveDateTime = CASE WHEN @IsDeleted = 1 THEN @Currentdate ELSE NULL END WHERE Id = @MessageId

										END
										IF (@IsPinned IS NOT NULL)
										BEGIN

											DECLARE @OldIsPinned BIT = (SELECT IsPinned FROM [Message] WHERE Id = @MessageId)

											IF((@OldIsPinned IS NULL OR @OldIsPinned = 0) AND @IsPinned = 1)
											BEGIN

												INSERT INTO UsefulFeatureAudit(Id,UsefulFeatureId,CreatedByUserId,CreatedDateTime)
												VALUES(NEWID(),(SELECT Id FROM UsefulFeature WHERE FeatureName = 'Number of time messages are pinned'),@OperationsPerformedBy,@Currentdate)

											END

											UPDATE [Message] SET IsPinned = @IsPinned, PinnedByUserId=@PinnedByUserId WHERE Id = @MessageId

										END
										IF (@TaggedMembersIdsXml IS NOT NULL)
										BEGIN

											UPDATE [Message] SET TaggedMembersIdsXml = @TaggedMembersIdsXml WHERE Id = @MessageId

										END

								
								END

								
							 
	  END
	 END
					ELSE
						BEGIN
						DECLARE @StarredMessageId UNIQUEIDENTIFIER = (SELECT [Id] FROM StarredMessages WHERE MessageId=@MessageId and CreatedByUserId=@OperationsPerformedBy)

						IF(@StarredMessageId IS NULL)
							BEGIN

								INSERT INTO StarredMessages
													(Id
													,CreatedByUserId
													,CreatedDateTime
													,MessageId
													,InActiveDateTime) 
												VALUES(NEWID()
														,@OperationsPerformedBy
														,GETDATE()
														,@MessageId
														, CASE WHEN @IsStarred = 0 THEN GETDATE() ELSE NULL END)
							  
							END
						    ELSE
							BEGIN

								UPDATE StarredMessages SET InActiveDateTime = CASE WHEN @IsStarred=0 THEN GETDATE() ELSE NULL END WHERE MessageId=@MessageId AND CreatedByUserId=@OperationsPerformedBy
							  
							END
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