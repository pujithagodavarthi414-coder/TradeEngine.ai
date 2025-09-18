CREATE TABLE [dbo].[InvoiceProjects](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[ProjectId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL, 
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_InvoiceProjects] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InvoiceProjects] WITH CHECK ADD CONSTRAINT [FK_Invoice_New_InvoiceProjects_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice_New] ([Id])
GO

ALTER TABLE [dbo].[InvoiceProjects] CHECK CONSTRAINT [FK_Invoice_New_InvoiceProjects_InvoiceId]
GO

ALTER TABLE [dbo].[InvoiceProjects] WITH CHECK ADD CONSTRAINT [FK_Project_InvoiceProjects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO

ALTER TABLE [dbo].[InvoiceProjects] CHECK CONSTRAINT [FK_Project_InvoiceProjects_ProjectId]
GO