CREATE TABLE [dbo].[ExpenseSplit] (
    [Id]                UNIQUEIDENTIFIER NOT NULL,
    [ExpenseId]         UNIQUEIDENTIFIER NULL,
    [ExpenseCategoryId] UNIQUEIDENTIFIER NULL,
    [Amount]            FLOAT (53)       NOT NULL,
    [Description]       NVARCHAR (500)   NOT NULL,
    [CreatedByUserId]   UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime]   DATETIME         NOT NULL,
    [UpdatedByUserId]   UNIQUEIDENTIFIER NULL,
    [UpdatedDateTime]   DATETIME         NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP NULL,
    CONSTRAINT [PK_ExpenseSplit] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ExpenseSplit_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [dbo].[User] ([Id]),
    CONSTRAINT [FK_ExpenseSplit_User1] FOREIGN KEY ([UpdatedByUserId]) REFERENCES [dbo].[User] ([Id])
)
GO