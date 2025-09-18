CREATE TABLE [dbo].[BillReceipt] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [ReceiptImagePath] NVARCHAR (800)   NOT NULL,
    [ReceiptName]      NVARCHAR (200)   NOT NULL,
    [ExpenseId]        UNIQUEIDENTIFIER NULL,
    [ExpenseReportId]  UNIQUEIDENTIFIER NULL,
    [CreatedByUserId]  UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime]  DATETIME         NOT NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER NULL,
    [UpdatedDateTime]  DATETIME         NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP NULL,
    CONSTRAINT [FK_BillReceipt_ExpenseReport] FOREIGN KEY ([ExpenseReportId]) REFERENCES [dbo].[ExpenseReport] ([Id]),
    CONSTRAINT [FK_BillReceipt_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [dbo].[User] ([Id]),
    CONSTRAINT [FK_BillReceipt_User1] FOREIGN KEY ([UpdatedByUserId]) REFERENCES [dbo].[User] ([Id])
);
GO
