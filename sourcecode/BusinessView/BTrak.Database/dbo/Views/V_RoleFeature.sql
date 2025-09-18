CREATE VIEW [dbo].[V_RoleFeature] AS 
SELECT  R.RoleName, F.FeatureName
FROM  dbo.[Role] R 
      INNER JOIN dbo.RoleFeature AS RF ON RF.RoleId = R.Id 
      INNER JOIN dbo.Feature AS F ON F.Id = RF.FeatureId 
