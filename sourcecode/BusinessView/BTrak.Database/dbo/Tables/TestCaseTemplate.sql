CREATE TABLE [dbo].[TestCaseTemplate] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [TemplateType]    NVARCHAR (250)    NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    CompanyId [uniqueidentifier]  NULL,
    [IsDefault] BIT NULL, 
    [IsTestCaseSteps] BIT NULL, 
    [IsTestCaseText] BIT NULL, 
    [IsExploratorySession] BIT NULL, 
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_TestCaseTemplate] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TestCaseTemplate_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [dbo].[Company] ([Id])
);
GO