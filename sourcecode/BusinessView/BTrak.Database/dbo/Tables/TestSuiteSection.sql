CREATE TABLE [dbo].[TestSuiteSection] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [TestSuiteId]     UNIQUEIDENTIFIER NOT NULL,
    [SectionName]     NVARCHAR (250)   NOT NULL,
    [Description]     NVARCHAR (3000)  NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
	[UpdatedDateTime] DATETIME          NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER  NULL,
    [ParentSectionId] UNIQUEIDENTIFIER NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_TestSuiteSection] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TestSuiteSection_TestSuiteId] FOREIGN KEY ([TestSuiteId]) REFERENCES [dbo].[TestSuite] ([Id]), 
);
GO

CREATE NONCLUSTERED INDEX [IX_TestSuiteSection_InActiveDateTime]
ON [dbo].[TestSuiteSection] ([InActiveDateTime])
INCLUDE ([Id])
GO