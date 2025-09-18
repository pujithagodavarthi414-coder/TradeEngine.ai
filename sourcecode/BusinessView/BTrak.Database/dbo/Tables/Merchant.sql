CREATE TABLE [dbo].[Merchant] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [MerchantName]    NVARCHAR (200)   NOT NULL,
    [Description]     NVARCHAR (500)   NULL,
	CompanyId [uniqueidentifier]  NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP NULL, 
    CONSTRAINT [PK_Merchant] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Merchant_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [dbo].[User] ([Id]),
);
GO

ALTER TABLE [dbo].[Merchant]  WITH NOCHECK ADD CONSTRAINT [FK_Company_Merchant_CompanyId] FOREIGN KEY ([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[Merchant] CHECK CONSTRAINT [FK_Company_Merchant_CompanyId]
GO