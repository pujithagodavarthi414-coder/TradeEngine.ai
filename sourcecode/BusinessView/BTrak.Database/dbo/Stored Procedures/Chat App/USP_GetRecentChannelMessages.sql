-------------------------------------------------------------------------------
-- Author       Madhuri Gummalla
-- Created      '2019-07-30 00:00:00.000'
-- Purpose      To Get Recent Channel Messages By Appliying Logged in User Id
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetRecentChannelMessages] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetRecentChannelMessages]
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
            
               DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
               
               DECLARE @CurrentDate DATETIME = GETDATE()
               
               SELECT C.Id AS ChannelId,
                      C.ChannelName,
                      ISNULL(OU.ProfileImage,CU.ProfileImage) AS ChannelProfileImage,
                      C.[TimeStamp],
                      C.[LastMessageDateTime],
					  C.CreatedDateTime,
                      CASE WHEN  MRR.Id IS NULL
                          THEN (SELECT COUNT(1) FROM [Message] M1 
                                WHERE M1.ChannelId = C.Id AND M1.SenderUserId <> @OperationsPerformedBy AND M1.ParentMessageId IS NULL) 
					      ELSE ISNULL(MUR.UnreadMessageCount,0) END AS UnreadMessageCount,
                      IIF(MSE.IsMuted IS NULL,0,MSE.IsMuted) AS IsMuted,
                      IIF(MSE.IsStarred IS NULL,0,MSE.IsStarred) AS IsStarred,
                      ISNULL(CM.IsReadOnly,0) AS IsReadOnly,
					  CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS CreatedByUserName,
					  C.CurrentOwnerShipId,
					  OU.FirstName + ' ' + ISNULL(OU.SurName,'') AS CurrentOwnerName,
					  C.CreatedByUserId
                      FROM  Channel C
                           INNER JOIN ChannelMember CM ON CM.ChannelId = C.Id 
                                      AND CM.InactiveDateTime IS NULL
                                      AND C.InactiveDateTime IS NULL
                           LEFT JOIN (SELECT M.ChannelId,COUNT(1) AS UnreadMessageCount 
                                      FROM MessageReadReceipt MR
                                           INNER JOIN [Message] M ON MR.SenderUserId = M.ChannelId AND M.SenderUserId <> MR.ReceiverUserId
                                                       AND M.OriginalCreatedDateTime > (SELECT OriginalCreatedDateTime FROM [Message] WHERE Id = MR.MessageId)
                                                       AND M.ChannelId IS NOT NULL
                                                       AND M.InactiveDateTime IS NULL 
                                                       AND M.ParentMessageId IS NULL
                                                       AND MR.ReceiverUserId = @OperationsPerformedBy
                                                       AND MR.IsChannel = 1
                                      GROUP BY M.ChannelId) MUR ON MUR.ChannelId = C.Id
                          LEFT JOIN MessageReadReceipt MRR ON MRR.ReceiverUserId = @OperationsPerformedBy AND MRR.SenderUserId = C.Id AND MRR.IsChannel=1
                          LEFT JOIN MutedOrStarredContacts MSE ON MSE.ChannelId = C.Id AND MSE.CreatedByUserId = @OperationsPerformedBy
                          LEFT JOIN UserStory US ON US.Id = C.Id
						  LEFT JOIN [User] CU ON C.CreatedByUserId = CU.Id
						  LEFT JOIN [User] OU ON C.CurrentOwnerShipId = OU.Id
                    WHERE C.CompanyId = @CompanyId 
                          AND CM.MemberUserId = @OperationsPerformedBy
                          AND US.Id IS NULL
                    GROUP BY C.Id,C.ChannelName, ISNULL(OU.ProfileImage,CU.ProfileImage), C.[TimeStamp],C.LastMessageDateTime,MUR.ChannelId
					        ,ISNULL(MUR.UnreadMessageCount,0),MSE.IsMuted,MSE.IsStarred,CM.IsReadOnly,MRR.Id,C.CreatedDateTime,CU.FirstName + ' ' + ISNULL(CU.SurName,''),C.CurrentOwnerShipId,OU.FirstName + ' ' + ISNULL(OU.SurName,''),C.CreatedByUserId
           
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
GO