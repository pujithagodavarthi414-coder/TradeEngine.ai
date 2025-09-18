CREATE TABLE [dbo].[ExpenseCategoryConfiguration]
(
	[Id]   [uniqueidentifier] NOT NULL,
	[ExpenseId] UNIQUEIDENTIFIER NOT NULL,
	[ExpenseCategoryName]		 NVARCHAR (800)   NOT NULL,
	[ExpenseCategoryId] UNIQUEIDENTIFIER NOT NULL,
	[Description]     NVARCHAR (800)   NULL,
	[Amount] FLOAT NOT NULL,
    [MerchantId]      UNIQUEIDENTIFIER NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
   	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP NULL,
	CONSTRAINT [PK_ExpenseCategoryConfiguration] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ExpenseCategoryConfiguration_Expense] FOREIGN KEY ([ExpenseId]) REFERENCES [dbo].[Expense] ([Id]),
    CONSTRAINT [FK_ExpenseCategoryConfiguration_ExpenseCategory] FOREIGN KEY ([ExpenseCategoryId]) REFERENCES [dbo].[ExpenseCategory] ([Id]),
    CONSTRAINT [FK_ExpenseCategoryConfiguration_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [dbo].[User] ([Id])
)
