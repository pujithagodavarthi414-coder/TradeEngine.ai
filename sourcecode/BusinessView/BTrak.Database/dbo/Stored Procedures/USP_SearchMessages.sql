--WITHOUT CHANNEL Id
--EXEC [dbo].[USP_SearchMessages] 
--@SenderId = '127133F1-4427-4149-9DD6-B02E0E036971', @ReceiverId = '127133F1-4427-4149-9DD6-B02E0E036972',
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

--WITH CHANNEL Id
--EXEC [dbo].[USP_SearchMessages] @ChannelId = 'B86F1525-D899-434A-9274-48C52060136E',
--@SenderId = '127133F1-4427-4149-9DD6-B02E0E036972',
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
--WITHOUT CHANNEL Id
--EXEC [dbo].[USP_SearchMessages] 
--@SenderId = '127133F1-4427-4149-9DD6-B02E0E036971', @ReceiverId = '127133F1-4427-4149-9DD6-B02E0E036972',
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
--WITH CHANNEL Id
--EXEC [dbo].[USP_SearchMessages] @ChannelId = 'B86F1525-D899-434A-9274-48C52060136E',
--@SenderId = '127133F1-4427-4149-9DD6-B02E0E036972',
--@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SearchMessages]
(
    @MsgCount INT = NULL,
    @LastMsgId UNIQUEIDENTIFIER = NULL,
    @SenderId UNIQUEIDENTIFIER,  -- Logged In UserId
    @ReceiverId UNIQUEIDENTIFIER = NULL, -- Selected UserId 
    @ChannelId UNIQUEIDENTIFIER = NULL, -- Selected ChannelId
    @IsArchived BIT = NULL,
    @DateFrom DateTime = NULL,
    @DateTo DateTime = NULL,
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
                
               DECLARE @CurrentDate DATETIME = GETDATE()

               IF(@LastMsgId = '00000000-0000-0000-0000-000000000000') SET @LastMsgId = NULL
               
               IF(@ChannelId = '00000000-0000-0000-0000-000000000000') SET @ChannelId = NULL
               
               IF(@ReceiverId = '00000000-0000-0000-0000-000000000000') SET @ReceiverId = NULL

               IF(@MsgCount IS NULL OR @MsgCount = 0)​
			   SET @MsgCount = 15

               IF(@ChannelId IS NOT NULL)
               BEGIN
                
                   SELECT M.OriginalId Id,
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
                          (CASE WHEN MRR.ReadDateTime IS NOT NULL THEN 1 ELSE 0 END) AS IsRead
                     FROM [Message] M 
                          INNER JOIN [User] U ON U.OriginalId = M.SenderUserId AND U.AsAtInactiveDateTime IS NULL
                          LEFT JOIN Channel C ON C.OriginalId = M.ChannelId  AND C.AsAtInactiveDateTime IS NULL
                          LEFT JOIN MessageReadReceipt MRR ON MRR.MessageId = M.OriginalId 
                          AND MRR.AsAtInactiveDateTime IS NULL AND MRR.ReceiverUserId = @SenderId 
                    WHERE U.CompanyId = @CompanyId 
                          AND M.AsAtInactiveDateTime IS NULL
                          AND M.InactiveDateTime IS NULL
                          AND (@ChannelId IS NULL OR M.ChannelId = @ChannelId)
                          AND (@LastMsgId IS NULL OR (M.OriginalCreatedDateTime < 
                          (SELECT OriginalCreatedDateTime FROM [dbo].[Message] WHERE OriginalId = @LastMsgId AND AsAtInActiveDateTime IS NULL)))
                          AND (@IsArchived IS NULL OR (@IsArchived = 1 AND M.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND M.InActiveDateTime IS NULL)) 
                    ORDER BY M.OriginalCreatedDateTime DESC OFFSET 0 ROWS
                    FETCH NEXT @MsgCount ROWS ONLY
		
 				    UPDATE MessageReadReceipt SET ReadDateTime = GETDATE()
                    FROM  [Message] M 
                    INNER JOIN [MessageReadReceipt] MRR ON MRR.MessageId = M.OriginalId AND M.AsAtInactiveDateTime IS NULL 
				    AND M.InActiveDateTime IS NULL 
                     WHERE MRR.ReceiverUserId = @SenderId 
                          AND M.ChannelId = @ChannelId 
                          AND MRR.ReadDateTime IS NULL

               END
               ELSE
               BEGIN
                 
                   SELECT M.OriginalId Id,
                          M.ChannelId,
                          M.SenderUserId,
                          M.TextMessage,
                          M.FilePath,
                          (CASE WHEN M.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsDeleted,
                          M.[TimeStamp],
                          M.OriginalCreatedDateTime AS MessageDateTime,
                          M.CreatedByUserId,
                          SU.FirstName + ' ' + ISNULL(SU.SurName,'') AS SenderName,
                          SU.ProfileImage AS SenderProfileImage,
                          RU.ProfileImage AS ReceiverProfileImage,
                          RU.FirstName + ' ' + ISNULL(RU.SurName,'') AS ReceiverName,
                          M.IsEdited,
                          (CASE WHEN MRR.ReadDateTime IS NULL THEN 0 ELSE 1 END) AS IsRead
                    FROM [Message] M 
                         INNER JOIN [User] SU ON SU.OriginalId = M.SenderUserId AND SU.AsAtInactiveDateTime IS NULL
                         LEFT JOIN [User] RU ON RU.OriginalId = M.ReceiverUserId AND RU.AsAtInactiveDateTime IS NULL
                         LEFT JOIN MessageReadReceipt MRR ON MRR.MessageId = M.OriginalId AND MRR.AsAtInactiveDateTime IS NULL --AND MRR.ReadDateTime IS NOT NULL
                  WHERE ((M.SenderUserId = @SenderId AND M.ReceiverUserId = @ReceiverId) OR (M.SenderUserId = @ReceiverId AND M.ReceiverUserId = @SenderId))
                         AND M.ChannelId IS NULL 
                         AND M.AsAtInactiveDateTime IS NULL
                         AND M.InactiveDateTime IS NULL
                         AND SU.CompanyId = @CompanyId
                         AND (@LastMsgId IS NULL OR (M.OriginalCreatedDateTime < (SELECT OriginalCreatedDateTime FROM [Message] WHERE OriginalId = @LastMsgId AND AsAtInActiveDateTime IS NULL)))
                  ORDER BY M.OriginalCreatedDateTime DESC OFFSET 0 ROWS
                  FETCH NEXT @MsgCount ROWS ONLY

 				  UPDATE MessageReadReceipt SET ReadDateTime = GETDATE()
                  FROM  [Message] M 
                  INNER JOIN [MessageReadReceipt] MRR ON MRR.MessageId = M.OriginalId AND M.AsAtInactiveDateTime IS NULL 
				  AND M.InActiveDateTime IS NULL 
                  WHERE MRR.ReceiverUserId = @ReceiverId
                      AND M.SenderUserId = @SenderId
                      AND MRR.Id IS NOT NULL
                      AND M.ChannelId IS NULL 
                      AND MRR.ReadDateTime IS NULL
                   
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