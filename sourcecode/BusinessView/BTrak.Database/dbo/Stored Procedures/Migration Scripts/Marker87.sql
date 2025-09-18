CREATE PROCEDURE [dbo].[Marker87]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

		MERGE INTO [dbo].[Country] AS Target
		USING ( VALUES 
				(NEWID(),@CompanyId, N'China', N'+86', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
				(NEWID(),@CompanyId, N'United States', N'+1', CAST(N'2020-08-27 11:51:44.163' AS DateTime), @UserId),
				(NEWID(),@CompanyId, N'South Korea', N'+82', CAST(N'2020-08-27 11:51:44.163' AS DateTime), @UserId),
				(NEWID(),@CompanyId, N'UAE', N'+971', CAST(N'2020-08-27 11:51:44.163' AS DateTime), @UserId),
				(NEWID(),@CompanyId, N'Doha', N'+974', CAST(N'2020-08-27 11:51:44.163' AS DateTime), @UserId)
				)
		AS Source ([Id], [CompanyId], [CountryName], [CountryCode], [CreatedDateTime], [CreatedByUserId])
		ON Target.[CompanyId] = Source.[CompanyId] AND Target.[CountryName] = Source.[CountryName]
		WHEN MATCHED THEN 
		UPDATE SET [CountryName] = Source.[CountryName],
				   [UpdatedDateTime] = Source.[CreatedDateTime],
				   [UpdatedByUserId] = Source.[CreatedByUserId],
				   [CountryCode] = Source.[CountryCode]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT([Id], [CompanyId], [CountryName], [CountryCode], [CreatedDateTime], [CreatedByUserId]) 
		VALUES ([Id], [CompanyId], [CountryName], [CountryCode], [CreatedDateTime], [CreatedByUserId]);

		INSERT INTO RoleFeature(Id,RoleId,FeatureId,CreatedByUserId,CreatedDateTime)
        SELECT NEWID(),@RoleId,N'D61A12E0-1902-44AD-9DB9-2E8CE155947A',@UserId,GETDATE()

END
GO
