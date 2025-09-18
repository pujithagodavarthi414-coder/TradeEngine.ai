CREATE VIEW [dbo].V_FrontEndBaseClassAutoGenerateFeatureConstants AS 
SELECT 'canAccess_feature_' + (SELECT [dbo].[Ufn_CapitalizeEachWord](FeatureName)) + '$: Observable<Boolean>;' AS FeatureConstSpec 
FROM [dbo].Feature
