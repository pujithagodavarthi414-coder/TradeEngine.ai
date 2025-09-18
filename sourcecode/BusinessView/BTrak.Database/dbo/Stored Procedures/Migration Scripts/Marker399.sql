CREATE PROCEDURE [dbo].[Marker399]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
    DECLARE @Currentdate DATETIME = GETDATE()

	MERGE INTO [dbo].[ClientType] AS Target 
	USING ( VALUES
	       (NEWID(), N'SG Trader Side', @CompanyId, GETDATE(), @UserId, NULL,11)
	       ) 
	AS Source ([Id], [ClientTypeName], [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime],[Order]) 
	ON Target.[ClientTypeName] = Source.[ClientTypeName] AND Target.[CompanyId] = Source.[CompanyId]
	WHEN MATCHED THEN 
	UPDATE SET [ClientTypeName] = Source.[ClientTypeName],
	           [Order] = Source.[Order],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [InActiveDateTime] = Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [ClientTypeName], [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime],[Order]) VALUES ([Id], [ClientTypeName], [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime],[Order]);


	MERGE INTO [dbo].[ClientTypeRoles] AS Target 
	USING ( VALUES
	       (NEWID(), @RoleId, (SELECT TOP 1 Id FROM ClientType WHERE ClientTypeName='Discharge Port Agent' AND CompanyId=@CompanyId), @CompanyId, GETDATE(), @UserId, NULL),
		   (NEWID(), @RoleId, (SELECT TOP 1 Id FROM ClientType WHERE ClientTypeName='SG Trader Side' AND CompanyId=@CompanyId), @CompanyId, GETDATE(), @UserId, NULL)
	        ) 
	AS Source ([Id], [RoleId],ClientTypeId, [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]) 
	ON Target.ClientTypeId = Source.ClientTypeId AND Target.[RoleId] = Source.[RoleId]
	WHEN MATCHED THEN 
	UPDATE SET [RoleId] = Source.[RoleId],
	           ClientTypeId = Source.ClientTypeId,
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [InActiveDateTime] = Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [RoleId], ClientTypeId, [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]) VALUES ([Id], [RoleId], ClientTypeId, [CompanyId], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]);


END