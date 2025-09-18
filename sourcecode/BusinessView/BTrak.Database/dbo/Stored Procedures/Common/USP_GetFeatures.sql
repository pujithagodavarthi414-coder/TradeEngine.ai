--EXEC [dbo].[USP_GetFeatures]@OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'
CREATE PROCEDURE [dbo].[USP_GetFeatures]
(
  @FeatureId UNIQUEIDENTIFIER = NULL,
  @FeatureName NVARCHAR(250) = NULL,
  @ParentFeatureId UNIQUEIDENTIFIER = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER ,
  @IsArchived BIT = 0
)
AS
BEGIN
     SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	  DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
	    BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   DECLARE @EnableTestRepo BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')
		   DECLARE @EnableBugboard BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')
         
		   
	       IF(@FeatureId = '00000000-0000-0000-0000-000000000000') SET  @FeatureId = NULL
		   
	       IF(@FeatureName = '') SET  @FeatureName = NULL

		   IF(@IsArchived IS NULL)SET @IsArchived = 0
		   
	       IF(@ParentFeatureId = '00000000-0000-0000-0000-000000000000') SET  @ParentFeatureId = NULL

		       DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)

	       SELECT F.Id AS FeatureId,
		          F.FeatureName,
				  F.ParentFeatureId,
				  F.CreatedByUserId,
				  F.CreatedDateTime,
				  F.UpdatedByUserId,
				  F.UpdatedDateTime,
				  F.[TimeStamp],
				  MI.Name AS MenuItemName,
		          TotalCount = COUNT(1) OVER()
		   FROM  [dbo].[Feature]  F WITH (NOLOCK)
		         --INNER JOIN [FeatureModule] FM WITH (NOLOCK) ON FM.FeatureId = F.Id
				 --INNER JOIN [CompanyModule] CM WITH (NOLOCK) ON CM.ModuleId = FM.ModuleId
				 LEFT JOIN [MenuItem] MI WITH (NOLOCK) ON MI.Id = F.MenuItemId
		   WHERE F.Id IN (SELECT FeatureId 
	               FROM FeatureModule FM
                        INNER JOIN CompanyModule CM ON CM.ModuleId = FM.ModuleId AND (CM.IsActive = 1 OR @IsSupport = 1)
				                   AND CM.CompanyId = @CompanyId)  
				 AND (@FeatureId IS NULL OR F.Id = @FeatureId)
		         AND (@FeatureName IS NULL OR F.FeatureName = @FeatureName)
				 AND (@EnableTestRepo = 1 OR ((@EnableTestRepo = 0 OR @EnableTestRepo IS NULL) AND F.Id NOT IN ('37E0C505-FA24-426B-8DA6-5FD17FC5BEA2','0D8663CB-49F3-49DB-8679-030207CA3FC5','721AEE4B-BB75-4DB0-B351-2BA2B5505229','0BCB4B35-8EB5-46D2-A0CC-53D1945A87F2','3D569305-47CE-4674-AC8D-A830B9D1FD2B','36414F52-41BA-4640-B59F-CC71241DBC2D','90DB7546-442F-49EE-BA98-3D8A78383C6C')))
				 AND (@EnableBugboard = 1 OR ((@EnableBugboard = 0 OR @EnableBugboard IS NULL) AND F.Id NOT IN ('15A34738-C863-40CF-A67A-24A2C2B6B176','EA9785B3-8AD8-416C-8194-6F9A3CB9CD05')))
		         AND (@ParentFeatureId IS NULL OR F.ParentFeatureId = @ParentFeatureId)
				 AND ((@IsArchived = 1 AND F.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND F.InActiveDateTime IS NULL))
				 AND F.Id NOT IN ('2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D','5D7D8B8F-640E-4CB7-BAFC-16F3B2157BD3')
		   ORDER BY FeatureName ASC 	

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