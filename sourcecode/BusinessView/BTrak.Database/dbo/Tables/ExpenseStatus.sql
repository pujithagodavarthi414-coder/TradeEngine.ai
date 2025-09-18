CREATE TABLE [dbo].[ExpenseStatus] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [Name]            NVARCHAR (100)   NOT NULL,
    [Description]     NVARCHAR (500)   NULL,
	[IsPending]		  BIT NULL,
	[IsApproved]	  BIT NULL,
	[IsRejected]	  BIT NULL,
	[IsPaid]          BIT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP NULL,
    CONSTRAINT [PK_ExpenseStatus] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ExpenseStatus_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [dbo].[User] ([Id]),
);
GO
