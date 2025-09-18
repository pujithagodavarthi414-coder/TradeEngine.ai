CREATE TABLE [dbo].[TaxCalculationType]
(	
    [Id] [uniqueidentifier]  NOT NULL PRIMARY KEY,
	[TaxCalculationTypeName] [nvarchar](150) NULL,
	[CountryId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
)
GO

ALTER TABLE [dbo].[TaxCalculationType]  WITH CHECK ADD  CONSTRAINT [FK_TaxCalculationType_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[TaxCalculationType] CHECK CONSTRAINT [FK_TaxCalculationType_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[TaxCalculationType]  WITH CHECK ADD  CONSTRAINT [FK_TaxCalculationType_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[TaxCalculationType] CHECK CONSTRAINT [FK_TaxCalculationType_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[TaxCalculationType]  WITH NOCHECK ADD CONSTRAINT [FK_TaxCalculationType_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO
ALTER TABLE [dbo].[TaxCalculationType] CHECK CONSTRAINT [FK_TaxCalculationType_Country_CountryId]
GO