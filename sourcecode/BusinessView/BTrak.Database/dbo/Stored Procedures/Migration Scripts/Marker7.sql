CREATE PROCEDURE [dbo].[Marker7]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	MERGE INTO [dbo].[EntityRoleFeature] AS Target 
	USING ( VALUES 
	 (NEWID(), N'B2375297-CB8F-4A06-B364-F732A5037A77', (SELECT Id FROM EntityRole WHERE EntityRoleName = N'Project manager' AND CompanyId = @CompanyId), NULL, GETDATE(), @UserId),
	 (NEWID(), N'B40DF5A4-3BF9-4206-8757-6371C6F72F0D', (SELECT Id FROM EntityRole WHERE EntityRoleName = N'Project manager' AND CompanyId = @CompanyId), NULL, GETDATE(), @UserId)
	
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
	
	DELETE FROM ControllerApiFeature WHERE FeatureId in('794B029D-4835-48CE-8AD1-E4BA17C4203F','CDFEEAB0-9924-41A5-8DAD-CAF8520BBB6C')
	DELETE FROM featuremodule WHERE featureid in('794B029D-4835-48CE-8AD1-E4BA17C4203F','CDFEEAB0-9924-41A5-8DAD-CAF8520BBB6C')
	DELETE FROM rolefeature WHERE featureid in('794B029D-4835-48CE-8AD1-E4BA17C4203F','CDFEEAB0-9924-41A5-8DAD-CAF8520BBB6C')
	DELETE FROM FeatureProcedureMapping WHERE FeatureId IN ('794B029D-4835-48CE-8AD1-E4BA17C4203F','CDFEEAB0-9924-41A5-8DAD-CAF8520BBB6C')
	DELETE FROM Feature WHERE Id in('794B029D-4835-48CE-8AD1-E4BA17C4203F','CDFEEAB0-9924-41A5-8DAD-CAF8520BBB6C')
	
END
GO