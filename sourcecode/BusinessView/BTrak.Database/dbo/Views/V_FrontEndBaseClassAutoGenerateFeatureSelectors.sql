CREATE VIEW [dbo].V_FrontEndBaseClassAutoGenerateFeatureSelectors AS 
SELECT 'this.canAccess_feature_' + (SELECT [dbo].[Ufn_CapitalizeEachWord](FeatureName)) + '$ = this.baseStore.pipe(select(sharedModuleReducers.doesUserHavePermission, {featureId: FeatureIds.Feature_' + (SELECT [dbo].[Ufn_CapitalizeEachWord](FeatureName)) + '}));' AS FeatureConstSpec 
FROM [dbo].Feature
