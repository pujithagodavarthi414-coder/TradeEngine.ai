CREATE TABLE [dbo].[TestSuite] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [ProjectId]       UNIQUEIDENTIFIER NOT NULL,
    [TestSuiteName]   NVARCHAR (250)   NOT NULL,
    [Description]     NVARCHAR (3000)  NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
	[UpdatedDateTime] DATETIME          NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_TestSuite] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TestSuite_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([Id]), 
);
GO

