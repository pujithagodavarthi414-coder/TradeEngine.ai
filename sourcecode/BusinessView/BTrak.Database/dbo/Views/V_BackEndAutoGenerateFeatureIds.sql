CREATE VIEW [dbo].V_BackEndAutoGenerateFeatureIds AS 
SELECT 'public static Guid ' + (SELECT [dbo].[Ufn_CapitalizeEachWord](FeatureName)) + ' = new Guid(' + '"' + CAST(Id AS NVARCHAR(100)) + '");'  AS FeatureConstSpec FROM [dbo].Feature
