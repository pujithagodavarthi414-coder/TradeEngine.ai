-------------------------------------------------------------------------------
--EXEC[dbo].[USP_GetChannels] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetChannels]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @IsArchived BIT = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @UserId UNIQUEIDENTIFIER = NULL,
  @MemberUserId UNIQUEIDENTIFIER = NULL,
  @ChannelId UNIQUEIDENTIFIER = NULL
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
              IF (@ProjectId = '00000000-0000-0000-0000-000000000000') SET @ProjectId = NULL
              IF (@UserId='00000000-0000-0000-0000-000000000000') SET @UserId = NULL
              IF (@ChannelId='00000000-0000-0000-0000-000000000000') SET @ChannelId = NULL
              IF (@MemberUserId = '00000000-0000-0000-0000-000000000000') SET @MemberUserId = NULL

              DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
              
              IF(@MemberUserId IS NULL) SET @MemberUserId = @OperationsPerformedBy

			  --SET @OperationsPerformedBy = ISNULL(@MemberUserId,@OperationsPerformedBy)

              IF(@ChannelId IS NULL)
              BEGIN
                 SELECT C.CompanyId,
                     C.ChannelName,
                     (CASE WHEN C.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsDeleted,
                     C.[TimeStamp],
                     ISNULL(OU.ProfileImage,CU.ProfileImage) As ChannelImage,
                     C.Id,
                     IIF(MSE.IsMuted IS NULL,0,MSE.IsMuted) AS IsMuted,
                     IIF(MSE.IsStarred IS NULL,0,MSE.IsStarred) AS IsStarred,
                     CASE WHEN MRR.Id IS NULL THEN (SELECT COUNT(1) FROM [Message] M1 WHERE M1.ChannelId = C.Id AND M1.ParentMessageId IS NULL AND M1.SenderUserId <> @OperationsPerformedBy) ELSE ISNULL(MRRInner.MessagesUnReadCount,0) END AS MessagesUnReadCount
                     ,ISNULL(CM.IsReadOnly,0) AS IsReadOnly
                     ,CMC.PinnedMessageCount
                     ,SMC.StarredMessageCount
                     ,(SELECT COUNT(1) FROM Channel C1 INNER JOIN ChannelMember CM1 ON C1.Id = CM1.ChannelId
                       WHERE C1.InActiveDateTime IS NULL AND CM1.InActiveDateTime IS NULL
                             AND C1.Id = C.Id) AS ChannelMemberCount
					,c.CreatedByUserId
					,c.CreatedDateTime
					,CU.FirstName + ' ' + ISNULL(CU.SurName,'') AS CreatedByUserName
					, OU.FirstName + ' ' + ISNULL(OU.SurName,'') AS CurrentOwnerName
					,c.CurrentOwnerShipId
                     FROM  [Channel] C
                             INNER JOIN [ChannelMember] CM ON CM.ChannelId = C.Id AND CM.MemberUserId = @OperationsPerformedBy AND CM.InActiveDateTime IS NULL AND CM.ActiveTo IS NULL
                             INNER JOIN [ChannelMember] CMM ON CMM.ChannelId = C.Id AND CMM.MemberUserId = @MemberUserId AND CM.InActiveDateTime IS NULL
                             LEFT JOIN (SELECT COUNT(1) AS MessagesUnReadCount,M1.ChannelId AS ChannelId
                                        FROM MessageReadReceipt MRR
                                             JOIN [Message] M1 ON M1.ChannelId = MRR.SenderUserId AND MRR.ReceiverUserId = @OperationsPerformedBy
                                             AND M1.OriginalCreatedDateTime > (SELECT OriginalCreatedDateTime FROM [Message] WHERE Id = MRR.MessageId)
                                             AND M1.SenderUserId <> @OperationsPerformedBy 
                                             AND MRR.ReceiverUserId = @OperationsPerformedBy
                                             AND M1.ChannelId IS NOT NULL
                                             AND M1.ParentMessageId IS NULL
                                             AND MRR.IsChannel = 1
                                             AND MRR.InActiveDateTime IS NULL
                                        GROUP BY M1.ChannelId) MRRInner ON MRRInner.ChannelId  = C.Id
                       LEFT JOIN MessageReadReceipt MRR ON MRR.ReceiverUserId = @OperationsPerformedBy AND MRR.SenderUserId = C.Id AND MRR.IsChannel=1
                       LEFT JOIN MutedOrStarredContacts MSE ON MSE.ChannelId=c.Id and MSE.CreatedByUserId=@OperationsPerformedBy
                       LEFT JOIN (SELECT COUNT(1) PinnedMessageCount,ChannelId
                                   FROM [Message]
                                   WHERE IsPinned = 1
                                         AND InActiveDateTime IS NULL
                                   GROUP BY ChannelId) CMC ON CMC.ChannelId = C.Id
                       LEFT JOIN (SELECT COUNT(1) AS StarredMessageCount,ChannelId
                                  FROM StarredMessages SM
                                       INNER JOIN [Message] M ON M.Id = SM.MessageId
                                                   AND SM.InActiveDateTime IS NULL
                                                   AND M.InActiveDateTime IS NULL
                                                   AND SM.CreatedByUserId = @OperationsPerformedBy
                                  GROUP BY ChannelId) SMC ON SMC.ChannelId = C.Id
					  LEFT JOIN [User] CU ON C.CreatedByUserId = CU.Id
					  LEFT JOIN [User] OU ON C.CurrentOwnerShipId = OU.Id
                    WHERE  (C.CompanyId = @CompanyId)
                          AND (@IsArchived IS NULL 
                               OR (@IsArchived = 1 AND C.InActiveDateTime IS NOT NULL) 
                               OR (@IsArchived = 0 AND C.InActiveDateTime IS NULL))     
                          AND (@UserId IS NULL OR C.Id IN (select UserId from [Ufn_GetEmployeeReportToMembers](@UserId)))
                          AND (@ChannelId IS NULL OR c.Id = @ChannelId)
                          --AND CM.MemberUserId IN (ISNULL(@MemberUserId,@OperationsPerformedBy))
                          AND (@ProjectId IS NULL OR C.ProjectId=@ProjectId)
              
             END
              ELSE
              BEGIN
                SELECT C.CompanyId,
                     C.ChannelName,
                     (CASE WHEN C.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsDeleted,
                     C.[TimeStamp],
                     ISNULL(OU.ProfileImage,CU.ProfileImage) As ChannelImage,
                     C.Id
                FROM [Channel] C
				LEFT JOIN [User] CU ON C.CreatedByUserId = CU.Id
				LEFT JOIN [User] OU ON C.CurrentOwnerShipId = OU.Id
                WHERE C.Id = @ChannelId

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