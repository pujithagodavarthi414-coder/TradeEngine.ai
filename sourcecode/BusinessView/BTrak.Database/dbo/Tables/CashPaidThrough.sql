CREATE TABLE [dbo].[CashPaidThrough] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [Description]     NVARCHAR (500)   NOT NULL,
    [CreatedDateTime] DATETIME         NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NULL,
    [UpdatedDateTime] DATETIME         NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_CashPaidThrough] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_CashPaidThrough_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [dbo].[User] ([Id]),
    CONSTRAINT [FK_CashPaidThrough_User1] FOREIGN KEY ([UpdatedByUserId]) REFERENCES [dbo].[User] ([Id])
);

