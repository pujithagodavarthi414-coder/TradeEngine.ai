CREATE TABLE [dbo].[InvoiceHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[InvoiceTaskId] [uniqueidentifier] NULL,
	[InvoiceItemId] [uniqueidentifier] NULL,
	[OldValue] [nvarchar](max) NULL,
	[NewValue] [nvarchar](max) NULL,
	[Description] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_InvoiceHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[InvoiceHistory]  WITH CHECK ADD CONSTRAINT [FK_InvoiceHistory_Invoice_New_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice_New] ([Id])
GO

ALTER TABLE [dbo].[InvoiceHistory] CHECK CONSTRAINT [FK_InvoiceHistory_Invoice_New_InvoiceId]
GO

ALTER TABLE [dbo].[InvoiceHistory]  WITH CHECK ADD CONSTRAINT [FK_InvoiceHistory_InvoiceTask_New_InvoiceTaskId] FOREIGN KEY([InvoiceTaskId])
REFERENCES [dbo].[InvoiceTask_New] ([Id])
GO

ALTER TABLE [dbo].[InvoiceHistory] CHECK CONSTRAINT [FK_InvoiceHistory_InvoiceTask_New_InvoiceTaskId]
GO

ALTER TABLE [dbo].[InvoiceHistory]  WITH CHECK ADD CONSTRAINT [FK_InvoiceHistory_InvoiceItem_New_InvoiceItemId] FOREIGN KEY([InvoiceItemId])
REFERENCES [dbo].[InvoiceItem_New] ([Id])
GO

ALTER TABLE [dbo].[InvoiceHistory] CHECK CONSTRAINT [FK_InvoiceHistory_InvoiceItem_New_InvoiceItemId]
GO