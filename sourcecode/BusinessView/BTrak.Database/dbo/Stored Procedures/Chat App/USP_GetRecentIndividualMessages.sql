-------------------------------------------------------------------------------
-- Author       Madhuri Gummalla
-- Created      '2019-07-30 00:00:00.000'
-- Purpose      To Get Recent Individual Messages By Appliying Logged in User Id
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetRecentIndividualMessages] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetRecentIndividualMessages]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
			
           DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
           
           IF(@HavePermission = '1')
           BEGIN
			
			 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

             DECLARE @AblilityToChatFeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                                   FROM CompanyModule CM 
                                                                        INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
                                                                        INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = '5D7D8B8F-640E-4CB7-BAFC-16F3B2157BD3' --Ability to chat
                                                                                   AND CM.CompanyId = @CompanyId
                                                                   GROUP BY FeatureId)

             DECLARE @FeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                     FROM CompanyModule CM 
                                                          INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
                                                          INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = 'A3B9B81A-109B-445D-9AEA-6B8A2B71C884' --Can have full access to company
                                                                     AND CM.CompanyId = @CompanyId
                                                     GROUP BY FeatureId)

             DECLARE @HaveAdvancedPermission BIT = (CASE WHEN  EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)
             
             DECLARE @RecentConv TABLE
			 (
                Recivers UNIQUEIDENTIFIER
		     )

              IF(@HaveAdvancedPermission = '1')
              BEGIN
                INSERT INTO @RecentConv
				SELECT Top(10) ReceiverId FROM RecentConversations WHERE SenderId = @OperationsPerformedBy ORDER BY RecentMessageDateTime DESC
				INSERT INTO @RecentConv
				SELECT Top(10) SenderId FROM RecentConversations WHERE ReceiverId = @OperationsPerformedBy 
				                                                       AND SenderId NOT IN (Select Recivers from @RecentConv) ORDER BY RecentMessageDateTime DESC
              END
              ELSE
              BEGIN
                DECLARE @AccessibleUsers TABLE
			    (
					UserId UNIQUEIDENTIFIER
				)

                INSERT INTO @AccessibleUsers Select UserId FROM [dbo].[Ufn_GetAccessibleMembersForSlack](@CompanyId,@OperationsPerformedBy,@FeatureId)

                INSERT INTO @RecentConv
				SELECT Top(10) ReceiverId from RecentConversations WHERE SenderId = @OperationsPerformedBy AND ReceiverId 
                IN (SELECT UserId FROM @AccessibleUsers)
				INSERT INTO @RecentConv
				SELECT Top(10) SenderId from RecentConversations WHERE ReceiverId = @OperationsPerformedBy AND SenderId 
                IN (SELECT UserId FROM @AccessibleUsers) AND SenderId NOT IN (Select Recivers from @RecentConv)
              END

              SELECT * 
			  FROM 
			  (
               SELECT RU.Id AS Id,
                      RU.FirstName + ' ' + ISNULL(RU.SurName,'') AS [Name],
                      RU.ProfileImage AS ProfileImage,
                      RU.IsExternal,
					  CASE WHEN MRR.Id IS NULL THEN (SELECT COUNT(1) FROM [Message] M1 WHERE M1.SenderUserId = RU.Id AND M1.ChannelId IS NULL AND M1.ParentMessageId IS NULL AND M1.ReceiverUserId = @OperationsPerformedBy) ELSE ISNULL(MUR.UnreadMessageCount,0) END AS UnreadMessageCount,
					  IIF(MSE.IsMuted IS NULL,0,MSE.IsMuted) AS IsMuted,
					  IIF(MSE.IsStarred IS NULL,0,MSE.IsStarred) AS IsStarred,
					  IIF(MSE.IsLeave IS NULL,0,MSE.IsLeave) AS IsLeave,
                      CASE WHEN LAInner.UserId IS NOT NULL THEN 1 ELSE 0 END AS IsOnLeave,
                      CASE WHEN C.Id IS NOT NULL THEN 1 ELSE 0 END AS IsClient,
                      C.CompanyName AS ClientCompanyName,
                      D.DesignationName,
                      ED.DepartmentName,
                      UAS.StatusId AS StatusId
                FROM [User] RU 
                     INNER JOIN @RecentConv RC ON RU.Id = RC.Recivers AND RU.IsActive = 1 AND RU.InActiveDateTime IS NULL
                     INNER JOIN (SELECT UR.UserId
                                 FROM [RoleFeature] RF
                                      INNER JOIN [Role] R ON R.Id = RF.RoleId AND R.InactiveDateTime IS NULL
                                  	  INNER JOIN UserRole UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
                                 WHERE RF.FeatureId = @AblilityToChatFeatureId AND R.CompanyId = @CompanyId
                                 GROUP BY UR.UserId) ATCU ON ATCU.UserId = RU.Id
                     LEFT JOIN [UserActiveStatus] UAS ON UAS.UserId = RU.Id
                     LEFT JOIN [Client] C ON C.UserId = RU.Id AND C.InactiveDateTime IS NULL
                     LEFT JOIN [Employee] E ON E.UserId = RU.Id AND E.InActiveDateTime IS NULL
                     LEFT JOIN [Job] EJ ON EJ.EmployeeId = E.Id  AND EJ.InActiveDateTime IS NULL
					 LEFT JOIN [Designation] D ON D.Id = EJ.DesignationId AND D.InactiveDateTime IS NULL
                     LEFT JOIN [Department] ED ON ED.Id = EJ.DepartmentId AND ED.InActiveDateTime IS NULL
                     LEFT JOIN MessageReadReceipt MRR ON MRR.ReceiverUserId = @OperationsPerformedBy AND MRR.SenderUserId = RU.Id AND MRR.IsChannel = 0
					 LEFT JOIN (SELECT M.SenderUserId,COUNT(1) AS UnreadMessageCount FROM MessageReadReceipt MR
                                                     JOIN [Message] M ON MR.SenderUserId = M.SenderUserId AND MR.ReceiverUserId = M.ReceiverUserId
                                                     AND MR.IsChannel = 0
                                                     AND MR.ReceiverUserId = @OperationsPerformedBy
													 AND M.OriginalCreatedDateTime > (SELECT OriginalCreatedDateTime FROM [Message] WHERE Id = MR.MessageId)
													 AND M.ChannelId IS NULL
													 AND M.ParentMessageId IS NULL
													 AND M.InactiveDateTime IS NULL 
													 GROUP BY M.SenderUserId) MUR ON MUR.SenderUserId = RU.Id
					 LEFT JOIN MutedOrStarredContacts MSE ON RU.Id = MSE.UserId AND MSE.CreatedByUserId = @OperationsPerformedBy
                     LEFT JOIN (SELECT UserId FROM LeaveApplication LA
                                     INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
                                     WHERE CONVERT(DATE,GETDATE()) BETWEEN LeaveDateFrom AND LeaveDateTo
                                     AND LS.IsApproved = 1 AND LS.IsApproved IS NOT NULL AND LS.CompanyId = @CompanyId) LAInner ON LAInner.UserId = RU.Id
                WHERE (MSE.IsLeave IS NULL OR MSE.IsLeave = 0) 
                GROUP BY RU.FirstName,RU.SurName,RU.ProfileImage,MUR.UnreadMessageCount,
                MSE.IsMuted,MSE.IsStarred,MSE.IsLeave,MRR.Id,LAInner.UserId,UAS.StatusId,RU.Id,C.Id,
                C.CompanyName,D.DesignationName,ED.DepartmentName,RU.IsExternal
			) MQuery
			WHERE UnreadMessageCount > 0
              
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