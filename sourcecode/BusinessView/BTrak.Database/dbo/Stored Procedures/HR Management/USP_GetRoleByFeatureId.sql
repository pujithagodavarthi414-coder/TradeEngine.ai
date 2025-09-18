--EXEC [dbo].[USP_GetRoleByFeatureId] @OperationsPerformedBy = 'B97E319B-5A8D-4D23-9C2E-47C4CF715391' , @FeatureId = '14de641a-b105-4fa6-a655-e16b265a2bea'
CREATE PROCEDURE [dbo].[USP_GetRoleByFeatureId]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @FeatureId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT (OBJECT_NAME(@@PROCID)))))

		IF (@HavePermission = '1')
		BEGIN

		   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

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
