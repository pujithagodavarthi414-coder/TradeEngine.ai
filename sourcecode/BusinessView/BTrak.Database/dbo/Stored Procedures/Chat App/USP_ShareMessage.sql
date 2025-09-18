--------------------------------------------------------------------------------------------------
-- Author       Akhil Ankireddy
-- Created      '2019-11-01 00:00:00.000'
-- Purpose      To share messages
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
--------------------------------------------------------------------------------------------------
--EXEC USP_ShareMessage @MessageId = 'D6D64E36-019A-409D-8C81-F7B1FC91F0D4',
--						@OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308',
--						@ChannelIdsXml = N'<?xml version="1.0" encoding="utf-16"?><ArrayOfGuid xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
--						xmlns:xsd="http://www.w3.org/2001/XMLSchema"><guid>A575F96A-55AE-4561-90EC-5897BAE41582</guid></ArrayOfGuid>',
--						@ReceiverIdsXml = N'<?xml version="1.0" encoding="utf-16"?><ArrayOfGuid xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
--						xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--						<guid>127133f1-4427-4149-9dd6-b02e0e036971</guid>
--						<guid>5e22e01a-bf81-46c5-8a64-600600e0313d</guid>
--						<guid>1c90bbeb-d85d-4bfb-97f5-48626f6ceb27</guid>
--						<guid>e38b057f-aa4e-4e63-b10a-74aa252aa004</guid>
--						</ArrayOfGuid>'
--------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ShareMessage]
(
 @MessageId UNIQUEIDENTIFIER,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @MessagesXml XML
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
		BEGIN
		    
			IF (@MessagesXml IS NULL)
			BEGIN

				RAISERROR('ReceiversDataShouldNotBeEmpty',11,1)

			END
			ELSE
			BEGIN

			DECLARE @TextMessage NVARCHAR(MAX), @TaggedUserXml XML, @FilePath NVARCHAR(MAX), @MessageTypeId UNIQUEIDENTIFIER 

            SELECT @FilePath = FilePath, @TextMessage = TextMessage, @TaggedUserXml = TaggedMembersIdsXml, @MessageTypeId = MessageTypeId FROM [Message] WHERE Id = @MessageId

			CREATE TABLE #ReceiverIds (
			                           Id UNIQUEIDENTIFIER,
									   IsChannel BIT,
									   MessageId UNIQUEIDENTIFIER,
									   ReceiverId UNIQUEIDENTIFIER,
									   MessageDateTime DATETIME
			                          )
            IF (@MessagesXml IS NOT NULL)
			BEGIN
			
			INSERT INTO #ReceiverIds(Id,IsChannel,ReceiverId,MessageId,MessageDateTime)
			SELECT NEWID(),CH.IsChannel, CH.ReceiverId, CH.MessageId, CH.MessageDateTIme
			       FROM (SELECT X.Y.value('IsChannel[1]', 'bit') AS IsChannel,
								X.Y.value('ReceiverId[1]', 'uniqueidentifier') AS ReceiverId,
								X.Y.value('MessageId[1]', 'uniqueidentifier') AS MessageId,
								X.Y.value('MessageCreatedDateTime[1]', 'datetime') AS MessageDateTIme 
								FROM @MessagesXml.nodes('/ArrayOfMessageMiniModel/MessageMiniModel') AS X(Y)) CH


				    INSERT INTO [dbo].[Message](
		        						  [Id],
		        						  [ChannelId],
		        						  [SenderUserId],
										  [ReceiverUserId],
		        						  [TextMessage],
		        						  [MessageTypeId],
		        						  [FilePath],
		        						  [CreatedByUserId],
		        						  [OriginalCreatedDateTime],
		        						  [CreatedDateTime],
										  [TaggedMembersIdsXml]
										 )
								  SELECT  R.MessageId,
								          CASE WHEN R.IsChannel = 1 THEN R.ReceiverId ELSE NULL END,
										  @OperationsPerformedBy,
										  CASE WHEN R.IsChannel = 0 THEN R.ReceiverId ELSE NULL END,
										  @TextMessage,
										  @MessageTypeId,
										  @FilePath,
										  @OperationsPerformedBy,
										  R.MessageDateTime,
										  R.MessageDateTime,
										  @TaggedUserXml
								          FROM #ReceiverIds R WHERE ReceiverId IS NOT NULL
			END

		   SELECT M.Id AS MessageId,
				  M.[TimeStamp],
				  CASE WHEN M.ChannelId IS NULL THEN 0 ELSE 1 END AS IsChannel,
				  CASE WHEN M.ChannelId IS NULL THEN M.ReceiverUserId ELSE M.ChannelId END AS ReceiverId
				FROM [dbo].[Message] M WHERE Id IN (SELECT MessageId FROM #ReceiverIds)

		END
		END
		ELSE
			
			RAISERROR(@HavePermission,11,1)

	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO