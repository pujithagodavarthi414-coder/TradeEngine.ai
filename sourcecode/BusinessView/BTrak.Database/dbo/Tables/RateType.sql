CREATE TABLE [dbo].[RateType]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [Type] [nvarchar](800) NOT NULL,
    [Rate] [numeric](10,2) NOT NULL,
    [CompanyId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP
)
GO

ALTER TABLE [dbo].[RateType]  WITH NOCHECK ADD CONSTRAINT [FK_Company_RateType_CompanyId] FOREIGN KEY ([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[RateType] CHECK CONSTRAINT [FK_Company_RateType_CompanyId]
GO