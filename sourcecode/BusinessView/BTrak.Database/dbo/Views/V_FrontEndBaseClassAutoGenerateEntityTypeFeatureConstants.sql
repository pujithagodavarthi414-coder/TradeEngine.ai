CREATE VIEW [dbo].[V_FrontEndBaseClassAutoGenerateEntityTypeFeatureConstants]
	AS SELECT 'canAccess_entityType_feature_' + (SELECT [dbo].[Ufn_CapitalizeEachWord](EntityFeatureName)) + '$: Observable<Boolean>;' AS EntityTypeFeatureConstSpec 
FROM [dbo].EntityFeature
