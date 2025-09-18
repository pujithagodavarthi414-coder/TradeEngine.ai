CREATE PROCEDURE [dbo].[Marker240]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

  IF(EXISTS(SELECT * FROM Company WHERE Id = @CompanyId))
  BEGIN

		MERGE INTO [dbo].[RoleFeature] AS Target 
		USING ( VALUES 
				    (NEWID(), @RoleId, N'8B154265-6F3D-4222-BF8F-89A6BBB3AD29', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				   ,(NEWID(), @RoleId, N'6098A309-B0CB-4A22-A586-7B1D743DFCB1', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				   ,(NEWID(), @RoleId, N'7E498DC2-F0A4-4DA4-A457-6741EADE5A33', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				   ,(NEWID(), @RoleId, N'25FC903D-3D8B-4DE3-8514-E5BED581F866', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				   ,(NEWID(), @RoleId, N'48BD5E94-1E22-423D-98E4-BDA63427D0E5', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
				   ,(NEWID(), @RoleId, N'AB8838C6-14A1-499E-BA0C-79B39904D2B4', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
		)
		AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [RoleId] = Source.[RoleId],
				   [FeatureId] = Source.[FeatureId],
				   [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET AND Source.[RoleId] IS NOT NULL THEN 
		INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
		VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);
	
 END
	
END
GO