CREATE TABLE [dbo].[InvoiceEmail](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[SendTo] [nvarchar](800) NOT NULL,
	[Subject] [nvarchar](800) NULL,
	[Message] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_InvoiceEmail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InvoiceEmail] WITH CHECK ADD CONSTRAINT [FK_Invoice_New_InvoiceEmail_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice_New] ([Id])
GO

ALTER TABLE [dbo].[InvoiceEmail] CHECK CONSTRAINT [FK_Invoice_New_InvoiceEmail_InvoiceId]
GO