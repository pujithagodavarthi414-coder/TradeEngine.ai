CREATE TABLE [dbo].[InvoicePaymentLog](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[PaidToAccountId] [uniqueidentifier] NOT NULL,
	[AmountPaid] [float] NULL,
	[PaidDate] [datetime] NOT NULL,
	[PaymentMethodId] [uniqueidentifier] NOT NULL,
	[ReferenceNumber] [nvarchar](50) NULL,
	[Notes] [nvarchar](800) NULL,
	[SendReceiptTo] [bit] NULL DEFAULT 0,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_InvoicePaymentLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InvoicePaymentLog] WITH CHECK ADD CONSTRAINT [FK_Invoice_New_InvoicePaymentLog_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice_New] ([Id])
GO

ALTER TABLE [dbo].[InvoicePaymentLog] CHECK CONSTRAINT [FK_Invoice_New_InvoicePaymentLog_InvoiceId]
GO

ALTER TABLE [dbo].[InvoicePaymentLog] WITH CHECK ADD CONSTRAINT [FK_PaymentMethod_InvoicePaymentLog_PaymentMethodId] FOREIGN KEY([PaymentMethodId])
REFERENCES [dbo].[PaymentMethod] ([Id])
GO

ALTER TABLE [dbo].[InvoicePaymentLog] CHECK CONSTRAINT [FK_PaymentMethod_InvoicePaymentLog_PaymentMethodId]
GO
