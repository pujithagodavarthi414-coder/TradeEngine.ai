CREATE TABLE [dbo].[TestCasePriority] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [PriorityType]    NVARCHAR (250)    NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    CompanyId [uniqueidentifier]  NULL,
    [IsDefault] BIT NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_TestCasePriority] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TestCasePriority_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([Id]), 
);
GO
