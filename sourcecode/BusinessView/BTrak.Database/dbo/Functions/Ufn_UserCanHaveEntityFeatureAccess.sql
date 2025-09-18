--SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess]('DB9458B5-D28B-4DD5-A059-69EEA129DF6E','53C96173-0651-48BD-88A9-7FC79E836CCE','USP_UpsertUserStorys')

CREATE FUNCTION [dbo].[Ufn_UserCanHaveEntityFeatureAccess]
(
   @UserId UNIQUEIDENTIFIER,
   @ProjectId UNIQUEIDENTIFIER,
   @ProcedureName NVARCHAR(500)
)
RETURNS NVARCHAR(500)
AS
BEGIN 
  RETURN 1 
    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT[dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
    RETURN CASE WHEN EXISTS(SELECT 1
    FROM  EntityFeatureProcedureMapping EFM
    INNER JOIN EntityFeature EF ON EF.Id = EFM.EntityFeatureId 
               AND EF.InActiveDateTime IS NULL AND EFM.ProcedureName = @ProcedureName
    INNER JOIN EntityRoleFeature ERF ON ERF.EntityFeatureId = EFM.EntityFeatureId 
                AND ERF.InActiveDateTime IS NULL
                AND EFM.InActiveDateTime IS NULL
                AND ERF.EntityRoleId IN (SELECT UP.EntityRoleId FROM UserProject UP
                                         WHERE UP.InActiveDateTime IS NULL AND UP.UserId = @UserId AND ProjectId = @ProjectId)  
    INNER JOIN [EntityType] ET ON ET.Id = EF.EntityTypeId
    INNER JOIN FeatureModule FM ON FM.FeatureId = ET.FeatureId
               AND FM.InActiveDateTime IS NULL
    INNER JOIN CompanyModule CM ON FM.ModuleId = CM.ModuleId
               AND CM.InActiveDateTime IS NULL
    WHERE CM.CompanyId = @CompanyId) THEN '1' ELSE 'YouDoNotHavePermissionsToThisFeature' END
END

