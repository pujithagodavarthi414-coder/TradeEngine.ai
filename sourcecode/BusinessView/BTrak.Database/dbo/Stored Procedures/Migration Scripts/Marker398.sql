CREATE PROCEDURE [dbo].[Marker398]
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
	       (NEWID(), N'Discharge Port Agent', @CompanyId, GETDATE(), @UserId, NULL,10)
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


END