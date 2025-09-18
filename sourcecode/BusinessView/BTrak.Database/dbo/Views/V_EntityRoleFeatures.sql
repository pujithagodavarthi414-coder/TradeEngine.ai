CREATE VIEW [V_EntityRoleFeatures] 
AS
SELECT ERF.EntityFeatureId,
	  EF.EntityFeatureName,
	  ERF.EntityRoleId 
FROM EntityRoleFeature ERF
INNER JOIN EntityFeature EF ON EF.Id = ERF.EntityFeatureId AND ERF.InActiveDateTime IS NULL AND  EF.InActiveDateTime IS NULL
GROUP BY  ERF.EntityFeatureId,EF.EntityFeatureName,ERF.EntityRoleId 
GO

