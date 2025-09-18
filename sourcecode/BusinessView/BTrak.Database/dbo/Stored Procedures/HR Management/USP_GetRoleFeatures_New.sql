-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-02-23 00:00:00.000'
-- Purpose      To Get the RoleFeatures By Appliying RoleId Filter
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetRoleFeatures_New] @OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308' ,@UserId = '0b2921a9-e930-4013-9047-670b5352f308'

CREATE PROCEDURE [dbo].[USP_GetRoleFeatures_New]
(
   @RoleId UNIQUEIDENTIFIER = NULL, 
   @UserId UNIQUEIDENTIFIER = NULL, 
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
         
    IF (@HavePermission = '1')
    BEGIN

		IF(@RoleId = '00000000-0000-0000-0000-000000000000') SET @RoleId = NULL
		
		IF(@UserId = '00000000-0000-0000-0000-000000000000') SET @UserId = NULL

		--IF(@UserId IS NOT NULL) SELECT @RoleId = RoleId FROM [dbo].[User] WHERE Id = @UserId

		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	       DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)

        SELECT RF.Id AS RoleFeatureId,
               RF.RoleId,
               --R.Id AS RoledId,
               RF.FeatureId,
               RF.CreatedDateTime AS RoleFeaturesCreatedDateTime, 
               RF.CreatedByUserId  AS RoleFeaturesCreatedByUserId,
               RF.UpdatedDateTime AS RoleFeaturesUpdatedDateTime,
               RF.UpdatedByUserId AS RoleFeaturesUpdatedByUserId,
               RoleName = STUFF((SELECT ',' + RoleName 
			                     FROM [Role] R --ON R.Id = UR.RoleId 
				                 WHERE (@UserId IS NULL OR R.Id IN (SELECT RoleId FROM [UserRole] WHERE UserId = @UserId AND InActiveDateTime IS NULL))
					               	   AND @RoleId IS NULL OR @RoleId = R.Id
					               	   AND R.InactiveDateTime IS NULL
                                       AND R.CompanyId = @CompanyId
				                  ORDER BY RoleName
			               FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''),
               F.FeatureName,
               F.ParentFeatureId,
               F.IsActive AS FeatureIsAcitve,
               F.CreatedByUserId AS FeatureCreatedByUserId,
               F.CreatedDateTime AS FeatureCreatedDateTime,
               F.UpdatedByUserId AS FeatureUpdatedByUserId,
               F.UpdatedDateTime AS FeatureUpdatedDateTime,
               CM.CompanyId,
               TotalCount = Count(1) OVER()
        FROM  [dbo].[RoleFeature] RF WITH (NOLOCK)
              INNER JOIN [dbo].[Feature] F WITH (NOLOCK) ON F.Id = RF.FeatureId AND RF.InActiveDateTime IS NULL
		      INNER JOIN [dbo].[FeatureModule] FM WITH (NOLOCK) ON FM.FeatureId = F.Id AND FM.InActiveDateTime IS NULL
		      INNER JOIN CompanyModule CM WITH (NOLOCK) ON CM.ModuleId = FM.ModuleId AND CM.CompanyId = @CompanyId AND CM.InActiveDateTime IS NULL
			  INNER JOIN Module M ON M.Id = CM.ModuleId AND (( CM.IsActive = 1 OR M.IsSystemModule = 1) OR @IsSupport = 1)
        WHERE (@RoleId IS NULL OR RF.RoleId = @RoleId)
		      AND @UserId IS NULL OR RF.RoleId IN (SELECT RoleId FROM [UserRole] WHERE UserId = @UserId AND InActiveDateTime IS NULL)
        ORDER BY F.FeatureName ASC

	END
    END TRY  
    BEGIN CATCH 
                                                            
        THROW

    END CATCH

END
GO