-------------------------------------------------------------------------------
--EXEC [USP_GetUsersForSlackApp] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUsersForSlackApp]
(
  @OperationsPerformedBy  UNIQUEIDENTIFIER
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

			  DECLARE @CompanyId UNIQUEIDENTIFIER

              SELECT @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
    
              DECLARE @FeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                     FROM CompanyModule CM 
                                                          INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
                                                          INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = 'A3B9B81A-109B-445D-9AEA-6B8A2B71C884' --Can have full access to company
                                                                     AND CM.CompanyId = @CompanyId
													 GROUP BY FeatureId)

              DECLARE @AblilityToChatFeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                                   FROM CompanyModule CM 
                                                                        INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
                                                                        INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = '5D7D8B8F-640E-4CB7-BAFC-16F3B2157BD3' --Ability to chat
                                                                                   AND CM.CompanyId = @CompanyId
													               GROUP BY FeatureId)

              DECLARE @HaveAdvancedPermission BIT = (CASE WHEN  EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)
              
              IF(@HaveAdvancedPermission = 1)
              BEGIN

                SELECT U.Id as Id,
                     U.FirstName,
                     U.SurName,
                     U.UserName AS Email,
                     U.[Password],
                     --U.RoleId,
                     U.IsPasswordForceReset,
                     U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
                     U.IsActive,
                     U.TimeZoneId,
                     U.MobileNo,
                     U.IsAdmin,
                     U.IsExternal,
                     U.IsActiveOnMobile,
                     U.ProfileImage,
                     U.RegisteredDateTime,
                     U.LastConnection,
                     U.CreatedDateTime,
                     U.CreatedByUserId,
                     U.UpdatedDateTime,
                     U.UpdatedByUserId,
					 D.DesignationName,
                     ED.DepartmentName,
					 IIF(MSE.IsMuted IS NULL,0,MSE.IsMuted) AS IsMuted,
					 IIF(MSE.IsStarred IS NULL,0,MSE.IsStarred) AS IsStarred,
					 IIF(MSE.IsLeave IS NULL,0,MSE.IsLeave) AS IsLeave,
                     CASE WHEN LAInner.UserId IS NOT NULL THEN 1 ELSE 0 END AS IsOnLeave, --TODO
                     UAS.StatusId AS StatusId,
                     CASE WHEN C.Id IS NOT NULL THEN 1 ELSE 0 END AS IsClient,
                     C.CompanyName AS ClientCompanyName,
                     TotalCount = COUNT(1) OVER()
               FROM  [dbo].[User] U
                     INNER JOIN (
                                  SELECT UR.UserId
                                  FROM [RoleFeature] RF
                                       INNER JOIN [Role] R ON R.Id = RF.RoleId AND R.InactiveDateTime IS NULL
                                  	 INNER JOIN UserRole UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
                                  WHERE RF.FeatureId = @AblilityToChatFeatureId AND R.CompanyId = @CompanyId
                                  GROUP BY UR.UserId
                                ) ATCU ON ATCU.UserId = U.Id
					 LEFT JOIN [Employee] E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
                     LEFT JOIN [Client] C ON C.UserId = U.Id AND C.InactiveDateTime IS NULL
                     LEFT JOIN [UserActiveStatus] UAS ON UAS.UserId = U.Id
				     LEFT JOIN [Job] EJ ON EJ.EmployeeId = E.Id  AND EJ.InActiveDateTime IS NULL
					 LEFT JOIN [Designation] D ON D.Id = EJ.DesignationId AND D.InactiveDateTime IS NULL
                     LEFT JOIN [Department] ED ON ED.Id = EJ.DepartmentId AND ED.InActiveDateTime IS NULL
                     LEFT JOIN (SELECT COUNT(1) AS MessagesUnReadCount,M1.SenderUserId AS ChannelId
										FROM MessageReadReceipt MRR
											 JOIN [Message] M1 ON M1.SenderUserId = MRR.SenderUserId AND MRR.ReceiverUserId = @OperationsPerformedBy
											 AND M1.OriginalCreatedDateTime > (SELECT OriginalCreatedDateTime FROM [Message] WHERE Id = MRR.MessageId)
											 AND M1.SenderUserId <> @OperationsPerformedBy 
											 AND M1.ReceiverUserId = @OperationsPerformedBy
					  						 AND M1.ChannelId IS NULL
                                             AND M1.ParentMessageId IS NULL
											 AND MRR.InActiveDateTime IS NULL
											 AND MRR.IsChannel = 0
										GROUP BY M1.SenderUserId) MRRInner ON MRRInner.ChannelId = U.Id
					LEFT JOIN MutedOrStarredContacts MSE ON (MSE.UserId=U.Id) and MSE.CreatedByUserId = @OperationsPerformedBy
					LEFT JOIN MessageReadReceipt MRR ON MRR.ReceiverUserId = @OperationsPerformedBy AND MRR.SenderUserId = U.Id AND MRR.IsChannel = 0
                    LEFT JOIN (SELECT UserId
                               FROM LeaveApplication LA
                                    INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
                               WHERE CONVERT(DATE,GETDATE()) BETWEEN LeaveDateFrom AND LeaveDateTo
                                     AND LS.IsApproved = 1 AND LS.IsApproved IS NOT NULL
                                     AND LS.CompanyId = @CompanyId) LAInner ON LAInner.UserId = U.Id
          WHERE (U.CompanyId = @CompanyId) 
		        AND U.InActiveDateTime IS NULL 
				AND U.IsActive = 1
          ORDER BY U.Id 
              
              END
              ELSE
              BEGIN
                
                    SELECT U.Id as Id,
                         U.FirstName,
                         U.SurName,
                         U.UserName AS Email,
                         U.[Password],
                         --U.RoleId,
                         U.IsPasswordForceReset,
                         U.FirstName +' '+ISNULL(U.SurName,'') as FullName,
                         U.IsActive,
                         U.TimeZoneId,
                         U.MobileNo,
                         U.IsAdmin,
                         U.IsExternal,
                         U.IsActiveOnMobile,
                         U.ProfileImage,
                         U.RegisteredDateTime,
                         U.LastConnection,
                         U.CreatedDateTime,
                         U.CreatedByUserId,
                         U.UpdatedDateTime,
                         U.UpdatedByUserId,
					     D.DesignationName,
                         ED.DepartmentName,
					     IIF(MSE.IsMuted IS NULL,0,MSE.IsMuted) AS IsMuted,
					     IIF(MSE.IsStarred IS NULL,0,MSE.IsStarred) AS IsStarred,
					     IIF(MSE.IsLeave IS NULL,0,MSE.IsLeave) AS IsLeave,
                         CASE WHEN LAInner.UserId IS NOT NULL THEN 1 ELSE 0 END AS IsOnLeave, --TODO
                         UAS.StatusId AS StatusId,
                         CASE WHEN C.Id IS NOT NULL THEN 1 ELSE 0 END AS IsClient,
                         C.CompanyName AS ClientCompanyName,
                         TotalCount = Count(1) OVER()
                   FROM  (SELECT UserId AS MemberUserId 
                          FROM [dbo].[Ufn_GetAccessibleMembersForSlack](@CompanyId,@OperationsPerformedBy,@FeatureId)) CMU
                          INNER JOIN (
                                        SELECT UR.UserId
                                        FROM [RoleFeature] RF
                                             INNER JOIN [Role] R ON R.Id = RF.RoleId AND R.InactiveDateTime IS NULL
                                        	 INNER JOIN UserRole UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
                                        WHERE RF.FeatureId = @AblilityToChatFeatureId AND R.CompanyId = @CompanyId
                                        GROUP BY UR.UserId
                                      ) ATCU ON ATCU.UserId = CMU.MemberUserId
                         INNER JOIN [dbo].[User] U ON U.Id = CMU.MemberUserId
					     LEFT JOIN [Employee] E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
                         LEFT JOIN [Client] C ON C.UserId = U.Id AND C.InactiveDateTime IS NULL
                         LEFT JOIN [UserActiveStatus] UAS ON UAS.UserId = U.Id
				         LEFT JOIN [Job] EJ ON EJ.EmployeeId = E.Id  AND EJ.InActiveDateTime IS NULL
					     LEFT JOIN [Designation] D ON D.Id = EJ.DesignationId AND D.InactiveDateTime IS NULL
                         LEFT JOIN [Department] ED ON ED.Id = EJ.DepartmentId AND ED.InActiveDateTime IS NULL
                         LEFT JOIN (SELECT COUNT(1) AS MessagesUnReadCount,M1.SenderUserId AS ChannelId
										    FROM MessageReadReceipt MRR
											     JOIN [Message] M1 ON M1.SenderUserId = MRR.SenderUserId AND MRR.ReceiverUserId = @OperationsPerformedBy
											     AND M1.OriginalCreatedDateTime > (SELECT OriginalCreatedDateTime FROM [Message] WHERE Id = MRR.MessageId)
											     AND M1.SenderUserId <> @OperationsPerformedBy 
											     AND M1.ReceiverUserId = @OperationsPerformedBy
					  						     AND M1.ChannelId IS NULL
                                                 AND M1.ParentMessageId IS NULL
											     AND MRR.InActiveDateTime IS NULL
											     AND MRR.IsChannel = 0
										    GROUP BY M1.SenderUserId) MRRInner ON MRRInner.ChannelId = U.Id
					    LEFT JOIN MutedOrStarredContacts MSE ON (MSE.UserId=U.Id) and MSE.CreatedByUserId=@OperationsPerformedBy
					    LEFT JOIN MessageReadReceipt MRR ON MRR.ReceiverUserId = @OperationsPerformedBy AND MRR.SenderUserId = U.Id AND MRR.IsChannel = 0
                        LEFT JOIN (SELECT UserId
                               FROM LeaveApplication LA
                                    INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
                               WHERE CONVERT(DATE,GETDATE()) BETWEEN LeaveDateFrom AND LeaveDateTo
                                     AND LS.IsApproved = 1 AND LS.IsApproved IS NOT NULL
                                     AND LS.CompanyId = @CompanyId) LAInner ON LAInner.UserId = U.Id
              WHERE (U.CompanyId = @CompanyId) 
		            AND U.InActiveDateTime IS NULL 
				    AND U.IsActive = 1
              ORDER BY U.Id 

              END

      END
     END TRY
     BEGIN CATCH
        
           THROW

    END CATCH
END
GO