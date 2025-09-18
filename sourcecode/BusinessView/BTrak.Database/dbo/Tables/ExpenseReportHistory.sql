CREATE TABLE [dbo].[ExpenseReportHistory] (
    [Id]   [uniqueidentifier] NOT NULL,
    [Description]     NVARCHAR (500)   NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
   	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[ExpenseReportId] UNIQUEIDENTIFIER NOT NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP NULL,
    CONSTRAINT [PK_ExpenseReportHistory] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ExpenseReportHistory_ExpenseReport] FOREIGN KEY ([ExpenseReportId]) REFERENCES [dbo].[ExpenseReport] ([Id]),
    CONSTRAINT [FK_ExpenseReportHistory_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [dbo].[User] ([Id])
);
GO