CREATE TABLE [dbo].[CurrencyConversion]
(
    [Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
	[CompanyId] [uniqueidentifier] NOT NULL,
    [CurrencyFromId] [uniqueidentifier] NOT NULL,
	[CurrencyToId] [uniqueidentifier] NOT NULL,
	[EffectiveDateTime] [datetime] NOT NULL,
	[CurrencyRate] [Float] NULL,
    [Archive] [bit] NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP,
)
GO

ALTER TABLE [dbo].[CurrencyConversion]  WITH CHECK ADD  CONSTRAINT [FK_Currency_CurrencyConversion_CurrencyFromId] FOREIGN KEY([CurrencyFromId])
REFERENCES [dbo].[Currency] ([Id])
GO

ALTER TABLE [dbo].[CurrencyConversion] CHECK CONSTRAINT [FK_Currency_CurrencyConversion_CurrencyFromId]
GO
ALTER TABLE [dbo].[CurrencyConversion]  WITH CHECK ADD  CONSTRAINT [FK_Currency_CurrencyConversion_CurrencyToId] FOREIGN KEY([CurrencyToId])
REFERENCES [dbo].[Currency] ([Id])
GO

ALTER TABLE [dbo].[CurrencyConversion] CHECK CONSTRAINT [FK_Currency_CurrencyConversion_CurrencyToId]
GO

