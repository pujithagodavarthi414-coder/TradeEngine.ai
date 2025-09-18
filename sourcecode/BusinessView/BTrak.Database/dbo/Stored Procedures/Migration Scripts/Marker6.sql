CREATE PROCEDURE [dbo].[Marker6]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

 DECLARE @EntityRoleId UNIQUEIDENTIFIER = (SELECT Id FROM EntityRole WHERE EntityRoleName = N'Project manager' AND CompanyId = @CompanyId)
 IF(@EntityRoleId IS NOT NULL)
 BEGIN
   MERGE INTO [dbo].[EntityRoleFeature] AS Target 
        USING ( VALUES 
         (NEWID(), (SELECT Id FROM [EntityFeature] WHERE EntityFeatureName = N'View templates' ), @EntityRoleId, NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime), @UserId),
         (NEWID(), (SELECT Id FROM [EntityFeature] WHERE EntityFeatureName =  N'View project settings' ), @EntityRoleId, NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime), @UserId)
        ) 
        AS Source ([Id], [EntityFeatureId], [EntityRoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId])
        ON Target.Id = Source.Id  
        WHEN MATCHED THEN 
        UPDATE SET [EntityFeatureId] = Source.[EntityFeatureId],
                   [EntityRoleId] = Source.[EntityRoleId],
                   [InActiveDateTime] = Source.[InActiveDateTime],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id], [EntityFeatureId], [EntityRoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId])
        VALUES ([Id], [EntityFeatureId], [EntityRoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId]);
END
UPDATE [dbo].[AppSettings] SET AppSettingsValue = 'Marker6' WHERE AppSettingsName = 'Marker'
END