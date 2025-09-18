CREATE TABLE [dbo].[InvoiceGoals](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[GoalId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_InvoiceGoals] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InvoiceGoals] WITH CHECK ADD CONSTRAINT [FK_Invoice_New_InvoiceGoals_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [dbo].[Invoice_New] ([Id])
GO

ALTER TABLE [dbo].[InvoiceGoals] CHECK CONSTRAINT [FK_Invoice_New_InvoiceGoals_InvoiceId]
GO

ALTER TABLE [dbo].[InvoiceGoals] WITH CHECK ADD CONSTRAINT [FK_Goal_InvoiceGoals_GoalId] FOREIGN KEY([GoalId])
REFERENCES [dbo].[Goal] ([Id])
GO

ALTER TABLE [dbo].[InvoiceGoals] CHECK CONSTRAINT [FK_Goal_InvoiceGoals_GoalId]
GO
