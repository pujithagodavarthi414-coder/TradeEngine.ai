-------------------------------------------------------------------------------
--EXEC [USP_GetUsersForChannel] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@ChannelId = 'B86F1525-D899-434A-9274-48C52060136E'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetUsersForChannel]
(
  @ChannelId UNIQUEIDENTIFIER,
  @OperationsPerformedBy UNIQUEIDENTIFIER

)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	
	      DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		  IF (@HavePermission = '1')
          BEGIN

		      IF (@ChannelId = '00000000-0000-0000-0000-000000000000') SET @ChannelId = NULL

		      IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

              DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
              
              DECLARE @FeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                       FROM CompanyModule CM 
                                                            INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId
                                                                       AND CM.InActiveDateTime IS NULL AND FM.InActiveDateTime IS NULL
                                                            INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = 'A3B9B81A-109B-445D-9AEA-6B8A2B71C884' --Can have full access to company
                                                                       AND CM.CompanyId = @CompanyId GROUP BY FeatureId)

              DECLARE @HaveAdvancedPermission BIT = (CASE WHEN EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)) AND FeatureId = @FeatureId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)

              DECLARE @AblilityToChatFeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                                   FROM CompanyModule CM 
                                                                        INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL
                                                                        INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = '5D7D8B8F-640E-4CB7-BAFC-16F3B2157BD3' --Ability to chat
                                                                                   AND CM.CompanyId = @CompanyId
													               GROUP BY FeatureId)

              IF(@HaveAdvancedPermission = 1)
              BEGIN

                  SELECT @ChannelId AS ChannelId,
                         U.Id,
                         U.CompanyId,
                         U.SurName,
                         U.FirstName,
                         U.UserName, 
					     STUFF((SELECT ',' + RoleName 
					          FROM UserRole UR
						           INNER JOIN [Role] R ON R.Id = UR.RoleId 
							                  AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
						      WHERE UR.UserId = U.Id
					    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,
					     D.DesignationName,
                         U.MobileNo,
                         U.IsAdmin,
                         U.ProfileImage,
                         U.RegisteredDateTime,
                         U.LastConnection,
                         U.CreatedByUserId,
                         U.UpdatedDateTime,
                         U.UpdatedByUserId
                    FROM [User] U 
                    INNER JOIN (
                                 SELECT UR.UserId
                                 FROM [RoleFeature] RF
                                      INNER JOIN [Role] R ON R.Id = RF.RoleId AND R.InactiveDateTime IS NULL
                                 	 INNER JOIN UserRole UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
                                 WHERE RF.FeatureId = @AblilityToChatFeatureId AND R.CompanyId = @CompanyId
                                 GROUP BY UR.UserId
                               ) ATCU ON ATCU.UserId = U.Id
                    LEFT JOIN [Employee] E ON E.UserId = U.Id  AND E.InActiveDateTime IS NULL
				    LEFT JOIN [Job] ED ON ED.EmployeeId = E.Id  AND ED.InActiveDateTime IS NULL
				    LEFT JOIN [Designation] D ON D.Id = ED.DesignationId  AND D.InactiveDateTime IS NULL
			       WHERE U.Id NOT IN (SELECT MemberUserId FROM ChannelMember WHERE ChannelId = @ChannelId AND InActiveDateTime IS NULL) 
                         AND (U.IsActive IS NULL OR U.IsActive = 1)
                         AND U.CompanyId = @CompanyId
					     AND U.InActiveDateTime IS NULL
		      
              END
              ELSE
              BEGIN
                
                SELECT @ChannelId AS ChannelId,
                         U.Id,
                         U.CompanyId,
                         U.SurName,
                         U.FirstName,
                         U.UserName, 
					     STUFF((SELECT ',' + RoleName 
					          FROM UserRole UR
						           INNER JOIN [Role] R ON R.Id = UR.RoleId 
							                  AND R.InactiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
						      WHERE UR.UserId = U.Id
					    FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'') AS RoleName,
					     D.DesignationName,
                         U.MobileNo,
                         U.IsAdmin,
                         U.ProfileImage,
                         U.RegisteredDateTime,
                         U.LastConnection,
                         U.CreatedByUserId,
                         U.UpdatedDateTime,
                         U.UpdatedByUserId
                    FROM (SELECT CM.MemberUserId 
                          FROM ChannelMember CM
                          WHERE CM.ChannelId IN (SELECT ChannelId FROM ChannelMember WHERE MemberUserId = @OperationsPerformedBy AND CM.ChannelId <> @ChannelId)
                          GROUP BY CM.MemberUserId
                          ) CMU
                    INNER JOIN [dbo].[User] U ON U.Id = CMU.MemberUserId 
                    INNER JOIN (
                                SELECT UR.UserId
                                FROM [RoleFeature] RF
                                     INNER JOIN [Role] R ON R.Id = RF.RoleId AND R.InactiveDateTime IS NULL
                                	 INNER JOIN UserRole UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
                                WHERE RF.FeatureId = @AblilityToChatFeatureId AND R.CompanyId = @CompanyId
                                GROUP BY UR.UserId
                              ) ATCU ON ATCU.UserId = U.Id
                    LEFT JOIN [Employee] E ON E.UserId = U.Id  AND E.InActiveDateTime IS NULL
				    LEFT JOIN [Job] ED ON ED.EmployeeId = E.Id  AND ED.InActiveDateTime IS NULL
				    LEFT JOIN [Designation] D ON D.Id = ED.DesignationId  AND D.InactiveDateTime IS NULL
			       WHERE (U.IsActive IS NULL OR U.IsActive = 1)
                         AND U.CompanyId = @CompanyId
					     AND U.InActiveDateTime IS NULL
              
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
