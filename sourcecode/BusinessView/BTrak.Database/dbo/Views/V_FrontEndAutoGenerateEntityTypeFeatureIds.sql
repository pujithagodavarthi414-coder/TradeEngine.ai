CREATE VIEW [dbo].[V_FrontEndAutoGenerateEntityTypeFeatureIds]AS
select 'public static EntityTypeFeature_' + (SELECT [dbo].[Ufn_CapitalizeEachWord](EntityFeatureName)) + ': Guid = Guid.parse(''' + CAST(Id AS NVARCHAR(100)) + ''');' AS FeatureConstSpec from [dbo].EntityFeature
GO
