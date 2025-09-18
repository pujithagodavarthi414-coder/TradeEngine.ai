-------------------------------------------------------------------------------
--EXEC [USP_GetLatestPunchCardStatusOfAnUser] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetLatestPunchCardStatusOfAnUser]
(
  @OperationsPerformedBy  UNIQUEIDENTIFIER
)
AS
BEGIN

 SET NOCOUNT ON
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

 BEGIN TRY

    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
            IF (@HavePermission = '1')
            BEGIN

        IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

     DECLARE @CompanyId UNIQUEIDENTIFIER

              SELECT @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

              DECLARE @CurrentDate DATETIME = CONVERT(DATE,GETDATE())
    
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
                
                SELECT U.Id AS UserId
                       ,U.FirstName + ' ' + ISNULL(U.SurName ,'') AS UserName
                       ,U.ProfileImage
                        ,CASE WHEN LAInner.UserId IS NOT NULL THEN 'Leave'
                             WHEN TS.InTime IS NULL THEN (SELECT ShortName FROM ButtonType WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND IsFinish = 1)
                             WHEN TS.InTime IS NOT NULL AND TS.OutTime IS NOT NULL 
                                  THEN 'Finish'
                             WHEN TS.InTime IS NOT NULL AND UB.Id IS NOT NULL 
                                  THEN 'Break'
                             WHEN TS.InTime IS NOT NULL AND TS.LunchBreakStartTime IS NOT NULL AND TS.LunchBreakEndTime IS NOT NULL
                                   THEN 'Start'
                             WHEN TS.InTime IS NOT NULL AND TS.LunchBreakStartTime IS NOT NULL AND TS.LunchBreakEndTime IS NULL
                                   THEN 'Lunch'
                             WHEN TS.InTime IS NOT NULL AND UB.Id IS NULL AND TS.LunchBreakStartTime IS NULL
                                  THEN 'Start'
                             END AS UserStatus
                        ,US.StatusId
                        ,US.CreatedDateTime AS StatusTime
                FROM [dbo].[User] U
                     INNER JOIN (
                                  SELECT UR.UserId
                                  FROM [RoleFeature] RF
                                       INNER JOIN [Role] R ON R.Id = RF.RoleId AND R.InactiveDateTime IS NULL
                                    INNER JOIN UserRole UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
                                  WHERE RF.FeatureId = @AblilityToChatFeatureId AND R.CompanyId = @CompanyId
                                  GROUP BY UR.UserId
                                ) ATCU ON ATCU.UserId = U.Id
                     LEFT JOIN TimeSheet TS ON TS.[Date] = @CurrentDate AND TS.UserId = U.Id
                     LEFT JOIN UserBreak UB ON CONVERT(DATE,UB.[Date]) = @CurrentDate AND UB.UserId = U.Id 
                               AND UB.InActiveDateTime IS NULL AND UB.BreakIn IS NOT NULL AND UB.BreakOut IS NULL
                     LEFT JOIN (SELECT UserId
                                FROM LeaveApplication LA
                                     INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
                                WHERE CONVERT(DATE,GETDATE()) BETWEEN LeaveDateFrom AND LeaveDateTo
                                      AND LS.IsApproved = 1 AND LS.IsApproved IS NOT NULL
                                      AND LS.CompanyId = @CompanyId) LAInner ON LAInner.UserId = U.Id
                    LEFT JOIN [UserActiveStatus] US ON US.UserId = U.Id
                WHERE (U.CompanyId = @CompanyId) 
                AND U.InActiveDateTime IS NULL 
          AND U.IsActive = 1

              END
              ELSE
              BEGIN
                
                SELECT U.Id AS UserId
                       ,U.FirstName + ' ' + ISNULL(U.SurName ,'') AS UserName
                       ,U.ProfileImage
                        ,CASE WHEN LAInner.UserId IS NOT NULL THEN 'Leave'
                             WHEN TS.InTime IS NULL THEN (SELECT ShortName FROM ButtonType WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND IsFinish = 1)
                             WHEN TS.InTime IS NOT NULL AND TS.OutTime IS NOT NULL 
                                  THEN 'Finish'
                             WHEN TS.InTime IS NOT NULL AND UB.Id IS NOT NULL 
                                  THEN 'Break'
                             WHEN TS.InTime IS NOT NULL AND TS.LunchBreakStartTime IS NOT NULL AND TS.LunchBreakEndTime IS NOT NULL
                                   THEN 'Start'
                             WHEN TS.InTime IS NOT NULL AND TS.LunchBreakStartTime IS NOT NULL AND TS.LunchBreakEndTime IS NULL
                                   THEN 'Lunch'
                             WHEN TS.InTime IS NOT NULL AND UB.Id IS NULL AND TS.LunchBreakStartTime IS NULL
                                  THEN 'Start'
                             END AS UserStatus
                        ,US.StatusId
                        ,US.CreatedDateTime AS StatusTime
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
                         LEFT JOIN TimeSheet TS ON TS.[Date] = @CurrentDate AND TS.UserId = U.Id
                         LEFT JOIN UserBreak UB ON CONVERT(DATE,UB.[Date]) = @CurrentDate AND UB.UserId = U.Id 
                                   AND UB.InActiveDateTime IS NULL AND UB.BreakIn IS NOT NULL AND UB.BreakOut IS NULL
                         LEFT JOIN (SELECT UserId
                                    FROM LeaveApplication LA
                                         INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId
                                    WHERE CONVERT(DATE,GETDATE()) BETWEEN LeaveDateFrom AND LeaveDateTo
                                          AND LS.IsApproved = 1 AND LS.IsApproved IS NOT NULL
                                          AND LS.CompanyId = @CompanyId) LAInner ON LAInner.UserId = U.Id
                         LEFT JOIN [UserActiveStatus] US ON US.UserId = U.Id
                WHERE (U.CompanyId = @CompanyId) 
                AND U.InActiveDateTime IS NULL 
          AND U.IsActive = 1

              END

      END
      ELSE
      BEGIN
        
        RAISERROR(@HavePermission,11,1);

      END

 END TRY
 BEGIN CATCH
  
  THROW

 END CATCH
END
GO
