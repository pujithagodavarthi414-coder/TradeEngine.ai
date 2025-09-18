--EXEC [dbo].[USP_GetEntityRoleByEntityFeatureId] @OperationsPerformedBy = 'B97E319B-5A8D-4D23-9C2E-47C4CF715391' , @EntityFeatureId = 'd9a2588f-1efe-4525-b29d-ca82f6ee0231'
CREATE PROCEDURE [dbo].[USP_GetEntityRoleByEntityFeatureId]
(
  @OperationsPerformedBy UNIQUEIDENTIFIER,
  @EntityFeatureId UNIQUEIDENTIFIER = NULL
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

		   SELECT EntityFeatureName ,
				  F.Id AS EntityFeatureId,
				  R.EntityRoleName,
				  R.Id AS EntityRoleId
				FROM [EntityRoleFeature] RF
				INNER JOIN [EntityRole] R ON RF.EntityRoleId = R.Id AND R.InactiveDateTime IS NULL AND RF.InactiveDateTime IS  NULL 
				INNER JOIN [EntityFeature] F ON F.Id = RF.EntityFeatureId AND F.InActiveDateTime IS NULL 
				WHERE @EntityFeatureId = F.Id AND R.CompanyId = @CompanyId
			
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
