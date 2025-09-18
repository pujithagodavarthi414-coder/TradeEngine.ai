CREATE TABLE [dbo].[Invoice](
	[Id] [uniqueidentifier] NOT NULL,
	CompanyId [uniqueidentifier]  NULL,
	[CompnayLogo] [nvarchar](800) NULL,
	[BillToCustomerId] [uniqueidentifier] NOT NULL,
	[ProjectId] [uniqueidentifier] NOT NULL,
	[InvoiceTypeId] [uniqueidentifier] NOT NULL,
	[InvoiceNumber] [nvarchar](250) NOT NULL,
	[Date] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[Discount] [numeric](10, 5) NOT NULL,
	[Notes] [nvarchar](800) NULL,
	[Terms] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP NULL,
 CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Invoice_BillToCustomerId] FOREIGN KEY([BillToCustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO

ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [FK_Customer_Invoice_BillToCustomerId]
GO