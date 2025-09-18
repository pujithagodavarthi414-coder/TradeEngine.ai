--------------------------------------------------------------------------------------------------
-- Author       Geetha CH
-- Created      '2020-07-20 00:00:00.000'
-- Purpose      To Update all Unread messages based on filters
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
--------------------------------------------------------------------------------------------------
--EXEC [USP_UpdateUnreadMessages] @MessagetypeEnum = 1,
--						@OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308'
--------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpdateUnreadMessages]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER
	,@MessagetypeEnum INT = NULL
	,@MessageIdsString NVARCHAR(MAX) = NULL
)
AS
BEGIN 

  SET NOCOUNT ON
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

  BEGIN TRY

    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[ufn_getcompanyIdbasedonuserid](@OPerationsperformedBy))

    IF(@MessageIdsString = '') SET @MessageIdsString = NULL
	
	DECLARE @CurrentDate DATETIME = GETDATE()

	DECLARE @SenderIdsTable TABLE
	(
		SenderId UNIQUEIDENTIFIER
		,IsChannel BIT DEFAULT 0
		,LatestMessage UNIQUEIDENTIFIER
	)

	IF(@MessagetypeEnum = 1) --Starred Messages
	BEGIN
	
		INSERT INTO @SenderIdsTable(SenderId,IsChannel)
		SELECT UserId,0 
		FROM MutedOrStarredContacts
		WHERE CreatedByUserId = @OperationsperformedBy
		      AND UserId IS NOT NULL
			  AND IsStarred = 1
		UNION 
		SELECT ChannelId,1
		FROM MutedOrStarredContacts
		WHERE CreatedByUserId = @OperationsperformedBy
		      AND ChannelId IS NOT NULL
			  AND IsStarred = 1
        
		UPDATE @SenderIdstable SET LatestMessage = Temp.MessageId
		FROM @SenderIdstable ST
			LEFT JOIN (
			            SELECT TOP (1) M.ChannelId AS SenderUserId,M.Id AS MessageId
			               FROM (
						          SELECT TOP (1) ChannelId AS SenderUserId,MAX(CreatedDateTime) AS MaxCreatedDateTime
					              FROM [Message] M 
					  	               INNER JOIN @SenderIdsTable ST ON ST.SenderId = M.ChannelId AND ST.IsChannel = 1
					              GROUP BY ChannelId
								 ) T
					INNER JOIN [Message] M ON M.ChannelId = T.SenderUserId AND M.CreatedDateTime = T.MaxCreatedDateTime 
			 ) Temp ON Temp.SenderUserId = ST.SenderId
		WHERE IsChannel = 1

		UPDATE @SenderIdstable SET LatestMessage = Temp.MessageId
		FROM @SenderIdstable ST 
			LEFT JOIN (
			   SELECT TOP (1) M.SenderUserId AS SenderUserId,M.Id AS MessageId
			   FROM (
					 SELECT SenderUserId AS SenderUserId,ReceiverUserId,MAX(CreatedDateTime) AS MaxCreatedDateTime
					 FROM [Message] M 
						  INNER JOIN @SenderIdsTable ST ON ST.SenderId = M.SenderUserId AND M.ReceiverUserId = @OperationsperformedBy
						             AND ST.IsChannel = 0
					 GROUP BY SenderUserId,ReceiverUserId
					) T
					INNER JOIN [Message] M ON M.SenderUserId = T.SenderUserId AND M.CreatedDateTime = T.MaxCreatedDateTime 
							   AND M.ReceiverUserId = @OperationsperformedBy
			 ) Temp ON Temp.SenderUserId = ST.SenderId
		WHERE IsChannel = 0

			 UPDATE MessageReadReceipt SET MessageId = ST.LatestMessage,UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = @CurrentDate 
			 FROM MessageReadReceipt MRR 
				  INNER JOIN @SenderIdstable ST ON ST.SenderId = MRR.SenderUserId AND ST.IsChannel = ISNULL(MRR.IsChannel,0)
							 AND MRR.ReceiverUserId = @OperationsperformedBy
             WHERE ST.LatestMessage IS NOT NULL

			INSERT INTO MessageReadReceipt (Id,SenderUserId,ReceiverUserId,MessageId,UpdatedByUserId,UpdatedDateTime,IsChannel)
			SELECT NEWID(),ST.SenderId,@OperationsperformedBy,ST.LatestMessage,@OperationsperformedBy,@CurrentDate,ST.IsChannel 
			FROM @SenderIdsTable ST 
				 LEFT JOIN MessageReadReceipt MRR ON ST.SenderId = MRR.SenderUserId AND ST.IsChannel = ISNULL(MRR.IsChannel,0)
							 AND MRR.ReceiverUserId = @OperationsperformedBy
			WHERE MRR.Id IS NULL
			      AND ST.LatestMessage IS NOT NULL

	END
	ELSE IF(@MessagetypeEnum = 2 AND @MessageIdsString IS NOT NULL) --Channel Messages
	BEGIN
	
		INSERT INTO @SenderIdsTable(SenderId,IsChannel)
		SELECT CONVERT(UNIQUEIDENTIFIER,[value]),1
		FROM [dbo].[Ufn_StringSplit](@MessageIdsString,',')
		WHERE CONVERT(UNIQUEIDENTIFIER,[value]) NOT IN (SELECT ChannelId FROM MutedOrStarredContacts 
		                                                WHERE CreatedByUserId = @OperationsPerformedBy
														      AND ChannelId IS NOT NULL)
	
		UPDATE @SenderIdstable SET LatestMessage = Temp.MessageId
		FROM @SenderIdstable ST 
			LEFT JOIN (
			   SELECT TOP (1) M.ChannelId AS SenderUserId,M.Id AS MessageId
			   FROM (
					 SELECT ChannelId AS SenderUserId,MAX(CreatedDateTime) AS MaxCreatedDateTime
					 FROM [Message] M 
						  INNER JOIN @SenderIdsTable ST ON ST.SenderId = M.ChannelId --AND M.ReceiverUserId = @OperationsperformedBy
					 GROUP BY ChannelId
					) T
					INNER JOIN [Message] M ON M.ChannelId = T.SenderUserId AND M.CreatedDateTime = T.MaxCreatedDateTime 
							   --AND M.ReceiverUserId = @OperationsperformedBy
			 ) Temp ON Temp.SenderUserId = ST.SenderId

		UPDATE MessageReadReceipt SET MessageId = ST.LatestMessage,UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = @CurrentDate 
		FROM MessageReadReceipt MRR 
			 INNER JOIN @SenderIdstable ST ON ST.SenderId = MRR.SenderUserId AND MRR.IsChannel = 1
						AND MRR.ReceiverUserId = @OperationsperformedBy

		INSERT INTO MessageReadReceipt (Id,SenderUserId,ReceiverUserId,MessageId,UpdatedByUserId,UpdatedDateTime,IsChannel)
		SELECT NEWID(),ST.SenderId,@OperationsperformedBy,ST.LatestMessage,@OperationsperformedBy,@CurrentDate,1
		FROM @SenderIdsTable ST 
			 LEFT JOIN MessageReadReceipt MRR ON ST.SenderId = MRR.SenderUserId AND MRR.IsChannel = 1
						 AND MRR.ReceiverUserId = @OperationsperformedBy
		WHERE MRR.Id IS NULL

	END
	ELSE IF(@MessagetypeEnum = 3 AND @MessageIdsString IS NOT NULL) --Individual Messages
	BEGIN

		INSERT INTO @SenderIdsTable(SenderId,IsChannel)
		SELECT CONVERT(UNIQUEIDENTIFIER,[value]),0
		FROM [dbo].[Ufn_StringSplit](@MessageIdsString,',')
		WHERE CONVERT(UNIQUEIDENTIFIER,[value]) NOT IN (SELECT UserId FROM MutedOrStarredContacts 
		                                               WHERE CreatedByUserId = @OperationsPerformedBy
													         AND UserId IS NOT NULL)
	
		UPDATE @SenderIdstable SET LatestMessage = Temp.MessageId
		FROM @SenderIdstable ST 
			LEFT JOIN (
			   SELECT TOP (1) M.SenderUserId AS SenderUserId,M.Id AS MessageId
			   FROM (
					 SELECT SenderUserId AS SenderUserId,ReceiverUserId,MAX(CreatedDateTime) AS MaxCreatedDateTime
					 FROM [Message] M 
						  INNER JOIN @SenderIdsTable ST ON ST.SenderId = M.SenderUserId AND M.ReceiverUserId = @OperationsperformedBy
					 GROUP BY SenderUserId,ReceiverUserId
					) T
					INNER JOIN [Message] M ON M.SenderUserId = T.SenderUserId AND M.CreatedDateTime = T.MaxCreatedDateTime 
							   AND M.ReceiverUserId = @OperationsperformedBy
			 ) Temp ON Temp.SenderUserId = ST.SenderId

		UPDATE MessageReadReceipt SET MessageId = ST.LatestMessage,UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = @CurrentDate 
		FROM MessageReadReceipt MRR 
			 INNER JOIN @SenderIdstable ST ON ST.SenderId = MRR.SenderUserId AND ISNULL(MRR.IsChannel,0) = 0
						AND MRR.ReceiverUserId = @OperationsperformedBy

		INSERT INTO MessageReadReceipt (Id,SenderUserId,ReceiverUserId,MessageId,UpdatedByUserId,UpdatedDateTime,IsChannel)
		SELECT NEWID(),ST.SenderId,@OperationsperformedBy,ST.LatestMessage,@OperationsperformedBy,@CurrentDate,0
		FROM @SenderIdsTable ST 
			 LEFT JOIN MessageReadReceipt MRR ON ST.SenderId = MRR.SenderUserId AND ISNULL(MRR.IsChannel,0) = 0
						 AND MRR.ReceiverUserId = @OperationsperformedBy
		WHERE MRR.Id IS NULL

	END

  END TRY
  BEGIN CATCH
    
    THROW

  END CATCH

END
GO