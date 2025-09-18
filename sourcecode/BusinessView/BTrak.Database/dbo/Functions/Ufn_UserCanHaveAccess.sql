--SELECT [dbo].[Ufn_UserCanHaveAccess]('DB9458B5-D28B-4DD5-A059-69EEA129DF6E','USP_SearchAssets_New')
CREATE FUNCTION [dbo].[Ufn_UserCanHaveAccess]
(
   @UserId UNIQUEIDENTIFIER = NULL,
   @ProcedureName NVARCHAR(150) = NULL
)
RETURNS NVARCHAR(500)
AS
BEGIN 
 
  DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT[dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))

   DECLARE @IsAccessToAll BIT = 1--(SELECT CASE WHEN EXISTS(SELECT ActionPath FROM ProcedureName WHERE ActionPath = @ProcedureName AND AccessAll = 1) THEN 1 END)

    DECLARE @IsSupport BIT = (CASE WHEN (SELECT UserName FROM [User] WHERE Id = @UserId) = 'Support@snovasys.com' THEN 1 ELSE 0 END)
       	   

	RETURN CASE WHEN @IsAccessToAll = '1'  THEN '1'
	WHEN EXISTS(SELECT 1
	FROM  FeatureProcedureMapping FPM
	INNER JOIN Feature F ON F.Id = FPM.FeatureId 
	           AND F.InActiveDateTime IS NULL AND FPM.ProcedureName = @ProcedureName
	INNER JOIN RoleFeature RF ON RF.FeatureId = FPM.FeatureId 
	           AND RF.InActiveDateTime IS NULL
			   AND FPM.InActiveDateTime IS NULL
	INNER JOIN FeatureModule FM ON FM.FeatureId = RF.FeatureId
	           AND FM.InActiveDateTime IS NULL
	INNER JOIN CompanyModule CM ON FM.ModuleId = CM.ModuleId
	            AND CM.InActiveDateTime IS NULL
	INNER JOIN Module M ON M.Id = CM.ModuleId AND ((CM.IsActive =1 OR M.IsSystemModule = 1) OR @IsSupport = 1)
   INNER JOIN UserRole UR ON UR.RoleId = RF.RoleId AND UR.UserId = @UserId
	WHERE CM.CompanyId = @CompanyId) THEN '1' ELSE 'YouDoNotHavePermissionsToThisFeature' END

END
GO