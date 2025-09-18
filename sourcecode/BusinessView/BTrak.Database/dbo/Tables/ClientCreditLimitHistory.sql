CREATE TABLE [dbo].[ClientCreditLimitHistory]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [ClientId] UNIQUEIDENTIFIER NOT NULL, 
    [Description] NVARCHAR(200) NOT NULL,
    [OldCreditLimit] INT NOT NULL, 
    [NewCreditLimit] INT NOT NULL, 
    [OldAvailableCreditLimit] INT NOT NULL,
    [NewAvailableCreditLimit] INT NOT NULL, 
    [Amount] INT NOT NULL, 
    [ScoId] UNIQUEIDENTIFIER NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL
)
