CREATE PROCEDURE [dbo].[Marker451]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	DECLARE @ModuleId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Module WHERE Id = 'BF5043A9-4333-41F7-B4A3-746A065B5350')

	MERGE INTO [dbo].[CompanyModule] AS Target 
	USING ( VALUES 
	 (NEWID(), @CompanyId, @ModuleId, GETDATE(), @UserId, 1, 1)
	)
	AS Source ([Id], [CompanyId], [ModuleId], [CreatedDateTime], [CreatedByUserId], [IsActive], [IsEnabled])
	ON Target.ModuleId = Source.ModuleId 
	    AND Target.CompanyId = Source.CompanyId
	WHEN MATCHED THEN
	UPDATE SET [Id] = Source.[Id],
			   [CompanyId] = Source.[CompanyId],	
			   [ModuleId] = Source.[ModuleId],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsActive] = Source.[IsActive],
               [IsEnabled] = Source.[IsEnabled]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [ModuleId], [CreatedDateTime], [CreatedByUserId],[IsActive], [IsEnabled]) VALUES ([Id], [CompanyId], [ModuleId], [CreatedDateTime], [CreatedByUserId],[IsActive], [IsEnabled]);

	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
	 (NEWID(), @RoleId, (SELECT TOP 1 Id FROM Feature (NOLOCK) WHERE Id = '4FE715F7-BB21-483C-9E2C-BC705B5F9133'), GETDATE(), @UserId)
	)
	AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
	ON Target.[RoleId] = Source.[RoleId] 
	    AND Target.[FeatureId] = Source.[FeatureId]
	WHEN MATCHED THEN
	UPDATE SET [Id] = Source.[Id],
			   [RoleId] = Source.[RoleId],
			   [FeatureId] = Source.[FeatureId],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
	VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

END
GO