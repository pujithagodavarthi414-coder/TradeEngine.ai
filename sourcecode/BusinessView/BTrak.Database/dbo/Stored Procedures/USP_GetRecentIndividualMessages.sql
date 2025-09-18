-------------------------------------------------------------------------------
-- Author       Madhuri Gummalla
-- Created      '2019-07-30 00:00:00.000'
-- Purpose      To Get Recent Individual Messages By Appliying Logged in User Id
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetRecentIndividualMessages] @OperationsPerformedBy='0B2921A9-E930-4013-9047-670B5352F308'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetRecentIndividualMessages]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@PageSize INT = 15,
	@PageNumber INT = 1
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
           DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
           IF(@HavePermission = '1')
           BEGIN
               SELECT S.UserId,
                      RU.FirstName + ' ' + ISNULL(RU.SurName,'') AS UserName,
                      RU.ProfileImage AS UserProfileImage,
                      (SELECT (SELECT TOP 1 M1.OriginalId LastMessageId, M1.TextMessage LastMessageText, M1.FilePath LastMessageFilePath, M1.OriginalCreatedDateTime LastMessageDateTime, M1.[TimeStamp] LastMessageTimeStamp
                      FROM [Message] M1 WITH (NOLOCK)
                           WHERE (M1.ReceiverUserId = @OperationsPerformedBy OR M1.SenderUserId = @OperationsPerformedBy)
                           AND M1.AsAtInactiveDateTime IS NULL 
                           AND M1.InActiveDateTime IS NULL
						   AND ((M1.ReceiverUserId = S.UserId AND M1.SenderUserId = @OperationsPerformedBy) OR (M1.SenderUserId = S.UserId AND M1.ReceiverUserId = @OperationsPerformedBy))
						   ORDER BY M1.OriginalCreatedDateTime DESC
                      FOR XML PATH('LastMessageApiReturnModel'), TYPE)FOR XML PATH('LastMessageDetail'), TYPE) AS LastMessageXml,
					  ISNULL(MUR.UnreadMessageCount,0) AS UnreadMessageCount,
					  S.OriginalCreateddateTime
                FROM [Message] M 
                     JOIN (SELECT L.UserId,MAX(L.CreatedDateTime) AS OriginalCreateddateTime FROM (SELECT M2.CreatedDateTime,T.UserId FROM Message M2 
				     JOIN (SELECT (CASE WHEN M.ReceiverUserId = @OperationsPerformedBy THEN M.SenderUserId ELSE M.ReceiverUserId END) AS UserId 
					           FROM [Message] M WHERE (@OperationsPerformedBy = M.SenderUserId OR @OperationsPerformedBy = M.ReceiverUserId) AND M.AsAtInactiveDateTime IS NULL AND M.InActiveDateTime IS NULL
							   GROUP BY  (CASE WHEN M.ReceiverUserId = @OperationsPerformedBy THEN M.SenderUserId ELSE M.ReceiverUserId END)) T 
							                                                                                            ON ((M2.SenderUserId = T.UserId AND M2.ReceiverUserId = @OperationsPerformedBy) 
							                                                                                             OR (M2.ReceiverUserId = T.UserId AND M2.SenderUserId = @OperationsPerformedBy))) L
																														 GROUP BY (L.UserId)) S ON M.CreatedDateTime = S.OriginalCreateddateTime
                     LEFT JOIN (select M.SenderUserId,COUNT(1) AS UnreadMessageCount FROM MessageReadReceipt MR
                                                     JOIN Message M ON MR.MessageId = M.OriginalId 
													  AND M.AsAtInactiveDateTime IS NULL
													  AND MR.ReadDateTime IS NULL
													  AND M.ChannelId IS NULL
													  AND MR.AsAtInactiveDateTime IS NULL
													  AND M.InactiveDateTime IS NULL  WHERE MR.ReceiverUserId = @OperationsPerformedBy GROUP BY M.SenderUserId) MUR ON MUR.SenderUserId = S.UserId
					 LEFT JOIN [User] RU ON RU.OriginalId = S.UserId AND RU.AsAtInactiveDateTime IS NULL
                WHERE M.ChannelId IS NULL
                      AND M.AsAtInactiveDateTime IS NULL
                GROUP BY S.UserId,RU.FirstName + ' ' + ISNULL(RU.SurName,''),RU.ProfileImage,MUR.UnreadMessageCount,S.OriginalCreateddateTime
				Order By S.OriginalCreateddateTime DESC

				OFFSET ((@PageNumber - 1) * @PageSize) ROWS
			    FETCH NEXT @PageSize Rows ONLY

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