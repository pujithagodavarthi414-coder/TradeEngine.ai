CREATE PROCEDURE [dbo].[Marker88]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

DECLARE @CountryId UNIQUEIDENTIFIER = (SELECT TOP(1) Id FROM [Country] WHERE CountryName = 'India' AND CompanyId = @CompanyId)

MERGE INTO [dbo].[Bank] AS Target 
USING ( VALUES 
          (NEWID(),@CountryId, N'State Bank of India', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'Andhra', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'ICICI', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)         
		 ,(NEWID(),@CountryId, N'HDFC', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'Axis', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'Kotak Mahindra', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'Canara', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'Bank of Baroda', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'City Union Bank', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'Dhanlaxmi', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'Federal', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'Syndicate', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'Union Bank of India', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'United Bank of India', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'Vijaya Bank', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
		 ,(NEWID(),@CountryId, N'Yes Bank', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)		 
)  
AS Source ([Id], [CountryId], [BankName], [CreatedDateTime], [CreatedByUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CountryId] = Source.[CountryId],
	       [BankName] = Source.[BankName],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [CountryId], [BankName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CountryId], [BankName], [CreatedDateTime], [CreatedByUserId]);

END