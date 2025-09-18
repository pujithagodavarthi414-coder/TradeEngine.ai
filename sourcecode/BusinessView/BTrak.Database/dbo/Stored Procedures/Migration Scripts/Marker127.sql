CREATE PROCEDURE [dbo].[Marker127]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[Bank] AS Target 
USING ( VALUES 
      (NEWID(),@CompanyId, N'Other', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
)  
AS Source ([Id], [CompanyId], [BankName], [CreatedDateTime], [CreatedByUserId]) 
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [CompanyId] = Source.[CompanyId],
	       [BankName] = Source.[BankName],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [CompanyId], [BankName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [BankName], [CreatedDateTime], [CreatedByUserId]);

END
GO
