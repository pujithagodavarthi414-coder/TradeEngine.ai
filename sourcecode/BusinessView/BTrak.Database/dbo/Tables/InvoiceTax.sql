CREATE TABLE [dbo].[InvoiceTax](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[Tax] [numeric](10,5) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_InvoiceTax] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[InvoiceTax] WITH CHECK ADD CONSTRAINT [FK_Invoice_New_InvoiceTax_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice_New] ([Id])
GO

ALTER TABLE [dbo].[InvoiceTax] CHECK CONSTRAINT [FK_Invoice_New_InvoiceTax_InvoiceId]
GO