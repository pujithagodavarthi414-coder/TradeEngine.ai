CREATE TABLE [dbo].[InvoiceItem_New](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[ItemName] [nvarchar](150) NULL,
	[ItemDescription] [nvarchar](800) NULL,
	[Price] float NULL,
	[Quantity] float NULL,
	[Order] int NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_InvoiceItem_New] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[InvoiceItem_New] WITH CHECK ADD CONSTRAINT [FK_Invoice_New_InvoiceItem_New_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice_New] ([Id])
GO
​
ALTER TABLE [dbo].[InvoiceItem_New] CHECK CONSTRAINT [FK_Invoice_New_InvoiceItem_New_InvoiceId]
GO