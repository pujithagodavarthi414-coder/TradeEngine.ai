CREATE VIEW [dbo].V_FrontEndAutoGenerateFeatureIds AS 
select 'public static Feature_' + (SELECT [dbo].[Ufn_CapitalizeEachWord](FeatureName)) + ': Guid = Guid.parse(''' + CAST(Id AS NVARCHAR(100)) + ''');' AS FeatureConstSpec from [dbo].Feature
