--EXEC [USP_EnsureUserCanHaveStepsAccess] @UserId = 'f426c615-c0e7-4265-a28a-6ea72379aabb' ,@FeatureId = 'E4A82106-3B35-4B7E-A1D0-950CE39EAA7C'

CREATE PROCEDURE [dbo].[USP_EnsureUserCanHaveStepsAccess]
(
	@UserId UNIQUEIDENTIFIER = NULL,
	@FeatureId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

    SET NOCOUNT ON
	BEGIN TRY

		SELECT CASE WHEN EXISTS (SELECT RF.Id FROM RoleFeature RF INNER JOIN Feature F ON F.Id = RF.FeatureId 
		AND F.Id = @FeatureId AND RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@UserId)) 
                                 INNER JOIN FeatureModule FM ON FM.FeatureId = F.Id AND RF.InActiveDateTime IS NULL AND FM.InActiveDateTime IS NULL AND F.InActiveDateTime IS NULL
                                 INNER JOIN CompanyModule CM ON CM.ModuleId =  FM.ModuleId AND CM.IsActive = 1 ) THEN 1 ELSE 0 END  CanHaveAcess,
								 (SELECT TOP 1 Id FROM Client WHERE UserId = @UserId AND InactiveDateTime IS NULL) ClientId

	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH

END
GO
