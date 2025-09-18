CREATE PROCEDURE [dbo].[Marker137]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
	           (NEWID(), @RoleId, N'5C7980DA-71DB-45BA-988E-BB0E5528AF58', GETDATE(),@UserId),
	           (NEWID(), @RoleId, N'49C8F995-EE29-4E55-B136-B2A6D7219D6A', GETDATE(),@UserId),
	           (NEWID(), @RoleId, N'117299CA-8FC4-4EE0-83DD-EAAA0B10505F', GETDATE(),@UserId),
	           (NEWID(), @RoleId, N'BD446D02-EFE4-4E63-B83B-C5463B395640', GETDATE(),@UserId)
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
