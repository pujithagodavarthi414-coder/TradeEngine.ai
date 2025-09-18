CREATE PROCEDURE [dbo].[USP_GetRoleByFeatureId]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @CompanyId UNIQUEIDENTIFIER,
  @FeatureId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN

		   SELECT FeatureName ,
				  F.Id AS FeatureId,
				  R.RoleName,
				  R.Id AS RoleId
				FROM [RoleFeature] RF
				INNER JOIN [Role] R ON RF.RoleId = R.Id AND R.InactiveDateTime IS NULL AND RF.InactiveDateTime IS  NULL 
				INNER JOIN [Feature] F ON F.Id = RF.FeatureId AND F.InActiveDateTime IS NULL 
				WHERE @FeatureId = F.Id AND R.CompanyId = @CompanyId
				   AND ISNULL(IsHidden,0) = 0
			
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
