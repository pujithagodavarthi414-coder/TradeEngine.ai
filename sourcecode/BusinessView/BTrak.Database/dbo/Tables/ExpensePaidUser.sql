CREATE TABLE [dbo].[ExpensePaidUser](
	[Id] [uniqueidentifier] NOT NULL,
	[ExpenseId] [uniqueidentifier] NOT NULL,
	[PaidByUserId] [uniqueidentifier] NULL,
	[PaidAmount] [numeric](10, 2) NULL,
	[AccountNumber] [nvarchar](100) NOT NULL,
	[PaymentReference] [nvarchar](800) NULL,
	[PaymentDate] [datetime] NOT NULL,
	[AccountHolderName] [nvarchar](800) NOT NULL,
	[Branch] [nvarchar](100) NOT NULL,
	[IFSC] [nvarchar](100) NOT NULL,
	[SOSCode] [nvarchar](100) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP NULL,
 CONSTRAINT [PK_ExpensePaidUser] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[ExpensePaidUser]  WITH CHECK ADD  CONSTRAINT [FK_Expense_ExpensePaidUser_ExpenseId] FOREIGN KEY([ExpenseId])
REFERENCES [dbo].[Expense] ([Id])
GO

ALTER TABLE [dbo].[ExpensePaidUser] CHECK CONSTRAINT [FK_Expense_ExpensePaidUser_ExpenseId]
GO

CREATE NONCLUSTERED INDEX IX_ExpensePaidUser_PaidByUserId 
ON [dbo].[ExpensePaidUser] (  PaidByUserId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO