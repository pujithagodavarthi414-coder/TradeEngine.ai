CREATE PROCEDURE [dbo].[Marker172]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

IF(EXISTS(SELECT ModuleId FROM CompanyModule WHERE ModuleId = 'A3F36A17-53E1-4CB4-BF71-668FCDBB683A' AND CompanyId = @CompanyId AND IsActive = 1 AND InActiveDateTime IS NULL))
BEGIN

   UPDATE CompanySettings SET [Value] = 1,IsVisible = 1 WHERE CompanyId = @CompanyId  AND [Key] ='EnableAuditManagement'

   MERGE INTO [dbo].[RoleFeature] AS Target 
   USING ( VALUES 
              (NEWID(), @RoleId, N'E019ECCC-E398-40DC-A95C-EC0F3771C258', CAST(N'2020-10-06T10:48:51.907' AS DateTime),@UserId)
   )
   AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
   ON Target.[RoleId] = Source.[RoleId]  AND Target.[FeatureId] = Source.[FeatureId]  
   WHEN MATCHED THEN 
   UPDATE SET [RoleId] = Source.[RoleId],
              [FeatureId] = Source.[FeatureId],
   	       [CreatedDateTime] = Source.[CreatedDateTime],
   		   [CreatedByUserId] = Source.[CreatedByUserId]
   WHEN NOT MATCHED BY TARGET THEN 
   INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
   VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);
   
	DECLARE @EntityRoleId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM EntityRole WHERE EntityRoleName = N'Project manager' AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)
	
	INSERT INTO [EntityRoleFeature] ([Id], [EntityFeatureId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]) 
	SELECT NEWID(),EF.Id,@EntityRoleId,GETDATE(),@UserId 
	FROM EntityFeature EF WHERE (ParentFeatureId ='DB1620F0-2996-4635-A56B-6D2B6C7B47D2' OR Id  ='DB1620F0-2996-4635-A56B-6D2B6C7B47D2')
	AND Id NOT IN (SELECT EntityFeatureId FROM EntityRoleFeature WHERE EntityRoleId = @EntityRoleId AND InActiveDateTime IS NULL) AND @EntityRoleId IS NOT NULL

END

END
GO

