CREATE PROCEDURE [dbo].[Marker369]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
	DECLARE @Currentdate DATETIME = GETDATE()
    
    MERGE INTO [dbo].[RoleFeature] AS Target 
        USING ( VALUES
            (NEWID(), @RoleId, N'6D92E5D6-EC20-4DFE-81DC-FA0CE8065127', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
            ,(NEWID(), @RoleId, N'3E0071E1-6E5D-4596-8436-161A28B45BE2', CAST(N'2022-02-19T10:48:51.907' AS DateTime),@UserId)
        )
        AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
        ON Target.[RoleId] = Source.[RoleId] AND Target.[FeatureId] = Source.[FeatureId]
        WHEN MATCHED THEN 
        UPDATE SET [RoleId] = Source.[RoleId],
                   [FeatureId] = Source.[FeatureId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
        VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

    INSERT INTO CompanyModule([Id],[CompanyId],[ModuleId],[IsActive],[IsEnabled],[CreatedDateTime],[CreatedByUserId])
    SELECT NEWID(),@CompanyId,(SELECT ID FROM Module WHERE ModuleName='Trading'),1,1,GETDATE(),@UserId 
END
GO