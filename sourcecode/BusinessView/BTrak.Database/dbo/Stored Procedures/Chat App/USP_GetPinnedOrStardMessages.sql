--WITHOUT CHANNEL Id
--EXEC [dbo].[USP_GetPinnedOrStardMessages] 
--@SenderId = '127133F1-4427-4149-9DD6-B02E0E036971', @ReceiverId = '127133F1-4427-4149-9DD6-B02E0E036972',
--@ChannelId=NULL,@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--WITH CHANNEL Id
--EXEC [dbo].[USP_GetPinnedOrStardMessages] @ChannelId = 'B86F1525-D899-434A-9274-48C52060136E',
--@ReceiverId=NULL, @SenderId = '127133F1-4427-4149-9DD6-B02E0E036972',
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetPinnedOrStardMessages]
(
    @SenderId UNIQUEIDENTIFIER,  -- Logged In UserId
    @ReceiverId UNIQUEIDENTIFIER = NULL, -- Selected UserId 
    @ChannelId UNIQUEIDENTIFIER = NULL, -- Selected ChannelId
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
     
          DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
          
		  IF(@HavePermission = '1')
           BEGIN
            
               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                
               
               IF(@ChannelId = '00000000-0000-0000-0000-000000000000') SET @ChannelId = NULL
               
               IF(@ReceiverId = '00000000-0000-0000-0000-000000000000') SET @ReceiverId = NULL

               IF(@SenderId = '00000000-0000-0000-0000-000000000000') SET @SenderId = NULL

               IF(@ChannelId IS NOT NULL)
               BEGIN
                
                SELECT M.Id Id,
                          M.ChannelId,
                          M.SenderUserId,
                          M.TextMessage,
                          M.FilePath,
                          (CASE WHEN M.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsDeleted,
                          M.[TimeStamp],
                          M.OriginalCreatedDateTime AS MessageDateTime,
                          M.CreatedByUserId,
                          U.FirstName + ' ' + ISNULL(U.SurName,'') AS SenderName,
                          U.ProfileImage AS SenderProfileImage,
                          M.IsEdited,
                          M.IsActivityMessage,
						  M.ParentMessageId,
						  M.IsPinned,
						  M.LastReplyDateTime,
						  M.TaggedMembersIdsXml,
						  IIF(SM.Id IS NULL,0,1) AS IsStarred,
						  DATEDIFF(MINUTE,M.OriginalCreatedDateTime,CONVERT(DATETIME,SYSDATETIMEOFFSET())) AS MessageTimeSpan,
						   M.PinnedByUserId
                     FROM [Message] M  
					 INNER JOIN [User] U ON U.Id = M.SenderUserId
					 LEFT JOIN StarredMessages SM ON SM.MessageId=M.Id AND SM.CreatedByUserId=@OperationsPerformedBy AND SM.InActiveDateTime IS NULL
				 WHERE (ChannelId= @ChannelId ) AND IsPinned = 1 
				  AND M.InActiveDateTime IS NULL
		
               END
               ELSE
               BEGIN
                 
                SELECT M.Id Id,
                          M.ChannelId,
                          M.SenderUserId,
                          M.TextMessage,
                          M.FilePath,
                          (CASE WHEN M.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsDeleted,
                          M.[TimeStamp],
                          M.OriginalCreatedDateTime AS MessageDateTime,
                          M.CreatedByUserId,
                          U.FirstName + ' ' + ISNULL(U.SurName,'') AS SenderName,
                          U.ProfileImage AS SenderProfileImage,
                          M.IsEdited,
                          M.IsActivityMessage,
						  M.ParentMessageId,
						  M.IsPinned,
						  M.LastReplyDateTime,
						  M.TaggedMembersIdsXml,
						  IIF(SM.Id IS NULL,0,1) AS IsStarred,
						  DATEDIFF(MINUTE,M.OriginalCreatedDateTime,CONVERT(DATETIME,SYSDATETIMEOFFSET())) AS MessageTimeSpan,
						   M.PinnedByUserId
                     FROM [Message] M  
					 INNER JOIN [User] U ON U.Id = M.SenderUserId 
					 LEFT JOIN StarredMessages SM ON SM.MessageId=M.Id AND SM.CreatedByUserId=@OperationsPerformedBy AND SM.InActiveDateTime IS NULL
				 WHERE IsPinned = 1
				 AND ((SenderUserId = @SenderId AND ReceiverUserId = @ReceiverId) OR (SenderUserId = @ReceiverId AND ReceiverUserId = @SenderId))
				  AND M.InActiveDateTime IS NULL

              END
           END
           ELSE
           BEGIN
           
                RAISERROR (@HavePermission,10, 1)
           
           END
    END TRY
    BEGIN CATCH
    
            THROW
    END CATCH
END