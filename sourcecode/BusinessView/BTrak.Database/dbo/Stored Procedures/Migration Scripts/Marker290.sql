CREATE PROCEDURE [dbo].[Marker290]
	@CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
AS
BEGIN
MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
           (NEWID(), @RoleId, N'7EEE0735-9D75-49D9-88FE-710B2B466107', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
)
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);RETURN 0
END
GO