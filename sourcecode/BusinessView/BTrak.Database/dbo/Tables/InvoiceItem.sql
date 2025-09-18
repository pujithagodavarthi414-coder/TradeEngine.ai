CREATE TABLE [dbo].[InvoiceItem](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[DisplayName] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](800) NULL,
	[Price] [numeric](10, 5) NOT NULL,
	[SKU] [nvarchar](250) NULL,
	[Group] [nvarchar](250) NULL,
	[ModeId] [uniqueidentifier] NOT NULL,
	[InvoiceCategoryId] [uniqueidentifier] NOT NULL,
	[Notes] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP NULL,
 CONSTRAINT [PK_InvoiceItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[InvoiceItem]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceCategory_InvoiceItem_InvoiceCategoryId] FOREIGN KEY([InvoiceCategoryId])
REFERENCES [dbo].[InvoiceCategory] ([Id])
GO

ALTER TABLE [dbo].[InvoiceItem] CHECK CONSTRAINT [FK_InvoiceCategory_InvoiceItem_InvoiceCategoryId]
GO
ALTER TABLE [dbo].[InvoiceItem]  WITH CHECK ADD  CONSTRAINT [FK_Mode_InvoiceItem_ModeId] FOREIGN KEY([ModeId])
REFERENCES [dbo].[Mode] ([Id])
GO

ALTER TABLE [dbo].[InvoiceItem] CHECK CONSTRAINT [FK_Mode_InvoiceItem_ModeId]
GO