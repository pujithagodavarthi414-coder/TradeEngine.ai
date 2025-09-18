CREATE PROCEDURE [dbo].[Marker241]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
  
  MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
        (NEWID(), @RoleId, N'47DA5B02-11CC-4B83-B20A-78C08DDCDE2E', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
		(NEWID(), @RoleId, N'D3C8C1AD-7DE2-42A9-A67C-54E4DAF075E2', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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
    VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

END
GO