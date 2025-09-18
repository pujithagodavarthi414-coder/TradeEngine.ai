---EXEC [dbo].[USP_GetAllFeaturesOfAnUser] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetAllFeaturesOfAnUser]
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

     IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

     DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

     IF(@OperationsPerformedBy IS NOT NULL)
     BEGIN
         
		 SELECT F.[Id] FeatureId,
                F.[FeatureName],
                F.ParentFeatureId,
                F1.[FeatureName] AS ParentFeatureName,
                NULL AS ProjectId,
                NULL AS ProjectName,
                RF.RoleId,
                R.RoleName
          FROM [RoleFeature] AS RF WITH (NOLOCK)
                JOIN Feature F WITH (NOLOCK) ON RF.FeatureId = F.Id AND F.InActiveDateTime IS NULL
                LEFT JOIN Feature F1 WITH (NOLOCK) ON F1.Id = F.ParentFeatureId AND F1.IsActive = 1
                LEFT JOIN [Role] R ON R.Id = RF.RoleId
          WHERE RF.RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId] (@OperationsPerformedBy)) AND R.CompanyId = @CompanyId
          GROUP BY F.[Id],F.[FeatureName],F.ParentFeatureId,F1.[FeatureName],RF.RoleId,R.RoleName
          UNION ALL
          SELECT F.[Id] FeatureId,
                 F.[FeatureName],
                 F.ParentFeatureId,
                 F1.[FeatureName] AS ParentFeatureName,
                 P.Id AS ProjectId,
                 P.ProjectName AS ProjectName,
                 RF.RoleId,
                 R.EntityRoleName
            FROM [RoleFeature] AS RF WITH (NOLOCK)
                 INNER JOIN Feature F WITH (NOLOCK) ON RF.FeatureId = F.Id AND F.IsActive = 1
                 LEFT JOIN Feature F1 WITH (NOLOCK) ON F1.Id = F.ParentFeatureId AND F1.IsActive = 1 
                 LEFT JOIN UserProject UP ON UP.EntityRoleId = RF.RoleId
                 INNER JOIN Project P ON P.Id = UP.ProjectId AND P.CompanyId = @CompanyId
                 INNER JOIN [EntityRole] R ON R.Id = UP.EntityRoleId AND R.InActiveDateTime IS NULL AND R.CompanyId = @CompanyID
          WHERE UP.UserId = @OperationsPerformedBy 
          GROUP BY F.[Id],F.[FeatureName],F.ParentFeatureId,F1.[FeatureName],P.Id,P.ProjectName,RF.RoleId,R.EntityRoleName
  END
  END
  END TRY
     BEGIN CATCH
        
           EXEC [dbo].[USP_GetErrorInformation]
    END CATCH
END