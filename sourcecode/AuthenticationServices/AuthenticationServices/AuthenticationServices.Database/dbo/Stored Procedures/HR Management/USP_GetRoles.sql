CREATE PROCEDURE [dbo].[USP_GetRoles]
(
   @RoleId UNIQUEIDENTIFIER = NULL, 
   @RoleName NVARCHAR(250) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @CompanyId UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250) = NULL,
   @PageNo INT = 1,
   @PageSize INT = 50,
   @IsArchived BIT = NULL	
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	 DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
	 IF (@HavePermission = '1')
     BEGIN

	 IF(@RoleId = '00000000-0000-0000-0000-000000000000') SET @RoleId = NULL

	 IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	 IF(@RoleName = '') SET @RoleName = NULL

	 IF(@IsArchived IS NULL)SET @IsArchived = 0

	    DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)

	      SELECT R.Id RoleId,
				 R.CompanyId,
				 R.RoleName,
				 R.CreatedDateTime, 
				 R.CreatedByUserId,
				 R.IsDeveloper,
				 CASE WHEN R.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				 R.[TimeStamp],
				 (SELECT (SELECT F.Id,F.FeatureName,F.IsActive 
					  FROM Feature AS F	WITH (NOLOCK)	
	  	  			       JOIN [RoleFeature] RF ON RF.FeatureId = F.Id 
                           JOIN [FeatureModule] FM ON FM.FeatureId = RF.FeatureId AND FM.InactiveDateTime IS NULL
						   JOIN [CompanyModule] CM ON CM.ModuleId = FM.ModuleId AND CM.CompanyId = @CompanyId AND CM.InActiveDateTime IS NULL
						   WHERE RF.RoleId = @RoleId AND RF.InActiveDateTime IS NULL
					  FOR XML PATH('FeatureModel'), TYPE)FOR XML PATH('Features'), TYPE) AS Features,
		   	     TotalCount = COUNT(1) OVER()
		  FROM  [dbo].[Role] AS R WITH (NOLOCK)
		  WHERE (@RoleId IS NULL OR R.Id = @RoleId)
		        AND (R.CompanyId = @CompanyId)
		        AND (@RoleName IS NULL OR R.RoleName = @RoleName)
				AND (@SearchText IS NULL OR R.RoleName LIKE '%'+ @SearchText+'%')
				AND (@IsArchived IS NULL OR (@IsArchived = 1 AND R.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND R.InActiveDateTime IS NULL))
				AND ((R.IsHidden IS NULL OR R.IsHidden = 0) OR @IsSupport = 1)

		  ORDER BY RoleName ASC 
		  OFFSET ((@PageNo - 1) * @PageSize) ROWS

         FETCH NEXT @PageSize ROWS ONLY

	END
	 ELSE
	 RAISERROR(@HavePermission,11,1)
	 END TRY  
	 BEGIN CATCH 
		
		   THROW

	END CATCH
END