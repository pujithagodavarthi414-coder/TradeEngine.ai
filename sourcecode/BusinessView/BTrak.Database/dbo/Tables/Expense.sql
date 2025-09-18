CREATE TABLE [dbo].[Expense] (
    [Id]                 UNIQUEIDENTIFIER NOT NULL,
	[ExpenseName]		 NVARCHAR (800)   NOT NULL,
    [PaymentStatusId]    UNIQUEIDENTIFIER NOT NULL,
    [ClaimedByUserId]    UNIQUEIDENTIFIER NULL,
	[CurrencyId]         UNIQUEIDENTIFIER NOT NULL,
    [CashPaidThroughId]  UNIQUEIDENTIFIER NULL,
    [ExpenseReportId]    UNIQUEIDENTIFIER NULL,
    [ExpenseStatusId]    UNIQUEIDENTIFIER NULL,
    [BillReceiptId]      UNIQUEIDENTIFIER NULL,
    [ClaimReimbursement] BIT              NOT NULL,
    [ReceiptDate]        DATETIME         NULL,
    [ExpenseDate]        DATETIME         NULL,
    [PaidStatusSetByUserId]    UNIQUEIDENTIFIER NULL,
    [RepliedDateTime]    DATETIME         NULL,
    [Reason]             NVARCHAR (800)   NULL,
    [IsApproved]         BIT              NULL,
    [ActualBudget]       NUMERIC (10, 2)  NULL,
	[BranchId]         UNIQUEIDENTIFIER NULL,
    [CreatedDateTime]    DATETIME         NOT NULL,
    [CreatedByUserId]    UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[ReferenceNumber]    NVARCHAR(1000)   NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP NULL,
	[CompanyId] UNIQUEIDENTIFIER NOT NULL,
    [ExpenseNumber] INT NOT NULL, 
    [IdentificationNumber] AS 'E-' + CAST([ExpenseNumber] as varchar(255)),
    CONSTRAINT [PK_Expense] PRIMARY KEY CLUSTERED ([Id] ASC), 
    --CONSTRAINT [FK_Expense_MasterTableCurrencyId] FOREIGN KEY ([CurrencyId]) REFERENCES [MasterTable]([Id]),
)
GO

ALTER TABLE [dbo].[Expense]  WITH NOCHECK ADD CONSTRAINT [FK_Currency_Expense_CurrencyId] FOREIGN KEY ([CurrencyId])
REFERENCES [dbo].[Currency] ([Id])
GO

ALTER TABLE [dbo].[Expense] CHECK CONSTRAINT [FK_Currency_Expense_CurrencyId]
GO

ALTER TABLE [dbo].[Expense]  WITH NOCHECK ADD CONSTRAINT [FK_Branch_Expense_BranchId] FOREIGN KEY ([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[Expense] CHECK CONSTRAINT [FK_Branch_Expense_BranchId]
GO