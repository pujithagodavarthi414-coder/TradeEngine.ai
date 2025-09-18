CREATE TABLE [dbo].[Bank]
(
	[Id] [uniqueidentifier] NOT NULL,
    [CountryId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier] NULL,
    [BankName] [nvarchar](500) NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP
CONSTRAINT [PK_Bank] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[Bank]  WITH CHECK ADD  CONSTRAINT [FK_Bank_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Bank] CHECK CONSTRAINT [FK_Bank_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[Bank]  WITH CHECK ADD  CONSTRAINT [FK_Bank_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Bank] CHECK CONSTRAINT [FK_Bank_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[Bank]  WITH CHECK ADD  CONSTRAINT [FK_Country_Bank_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO

ALTER TABLE [dbo].[Bank] CHECK CONSTRAINT [FK_Country_Bank_CountryId]
GO