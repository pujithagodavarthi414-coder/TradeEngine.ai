CREATE TABLE [dbo].[ExpenseHistory](
    [Id]   [uniqueidentifier] NOT NULL,
	[OldValue] NVARCHAR (250) NULL,
	[NewValue] NVARCHAR (250) NULL,
	[FieldName] NVARCHAR (250)   NOT NULL,
    [Description]     NVARCHAR (500)   NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
   	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[ExpenseId] UNIQUEIDENTIFIER NOT NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP NULL,
    CONSTRAINT [PK_ExpenseHistory] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ExpenseHistory_Expense] FOREIGN KEY ([ExpenseId]) REFERENCES [dbo].[Expense] ([Id]),
    CONSTRAINT [FK_ExpenseHistory_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [dbo].[User] ([Id])
);
GO