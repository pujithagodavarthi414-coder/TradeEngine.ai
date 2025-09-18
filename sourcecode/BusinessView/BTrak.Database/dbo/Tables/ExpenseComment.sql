CREATE TABLE [dbo].[ExpenseComment] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [Comment]         NVARCHAR (500)   NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[ExpenseId]       UNIQUEIDENTIFIER NOT NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP NULL,
    CONSTRAINT [PK_ExpenseReportComment] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ExpenseComment_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [dbo].[User] ([Id])
)
GO