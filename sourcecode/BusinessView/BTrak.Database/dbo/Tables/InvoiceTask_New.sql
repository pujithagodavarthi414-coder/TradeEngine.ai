CREATE TABLE [dbo].[InvoiceTask_New](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[TaskName] [nvarchar](150) NULL,
	[TaskDescription] [nvarchar](800) NULL,
	[Rate] float NULL,
	[Hours] float NULL,
	[Order] int NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_InvoiceTask_New] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[InvoiceTask_New] WITH CHECK ADD CONSTRAINT [FK_Invoice_New_InvoiceTask_New_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice_New] ([Id])
GO

ALTER TABLE [dbo].[InvoiceTask_New] CHECK CONSTRAINT [FK_Invoice_New_InvoiceTask_New_InvoiceId]
GO