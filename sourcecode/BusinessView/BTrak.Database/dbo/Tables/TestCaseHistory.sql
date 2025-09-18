CREATE TABLE [dbo].[TestCaseHistory](
    [Id] [uniqueidentifier] NOT NULL,
    [TestCaseId] [uniqueidentifier] NULL,
    [StepId]     [uniqueidentifier]  NULL,
    [TestRunId]  [uniqueidentifier]  NULL,
    [ConfigurationId]  [uniqueidentifier]  NULL,
	[UserStoryId] [uniqueidentifier]  NULL,
	[ReferenceId] [uniqueidentifier]  NULL,
    [OldValue]  [nvarchar](MAX)  NULL,
    [NewValue]  [nvarchar](MAX)  NULL,
    [FieldName]  [nvarchar](50)  NULL,
	[FilePath]  [nvarchar](1000)  NULL,
    [Description]  [nvarchar](800)  NULL,
    [CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier] NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetimeoffset] NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
  [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_TestCaseHistory] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TestCaseHistory]  WITH NOCHECK ADD CONSTRAINT [FK_TestCase_TestCaseHistory_TestCaseId] FOREIGN KEY ([TestCaseId])
REFERENCES [dbo].[TestCase] ([Id])
GO
ALTER TABLE [dbo].[TestCaseHistory]  CHECK CONSTRAINT [FK_TestCase_TestCaseHistory_TestCaseId]
GO
ALTER TABLE [dbo].[TestCaseHistory]  WITH NOCHECK ADD CONSTRAINT [FK_TestRun_TestCaseHistory_TestRunId] FOREIGN KEY ([TestRunId])
REFERENCES [dbo].[TestRun] ([Id])
GO
ALTER TABLE [dbo].[TestCaseHistory]  CHECK CONSTRAINT [FK_TestRun_TestCaseHistory_TestRunId]
GO
ALTER TABLE [dbo].[TestCaseHistory]  WITH NOCHECK ADD CONSTRAINT [FK_TestCaseStep_TestCaseHistory_StepId] FOREIGN KEY ([StepId])
REFERENCES [dbo].[TestCaseStep] ([Id])
GO
ALTER TABLE [dbo].[TestCaseHistory]  CHECK CONSTRAINT [FK_TestCaseStep_TestCaseHistory_StepId]
GO

CREATE NONCLUSTERED INDEX IDX_TestCaseHistory_TestCaseId_TestRunId 
ON [dbo].[TestCaseHistory] (  TestCaseId ASC  , TestRunId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX [IDX_TestCaseHistory_CreatedByUserId]
ON [dbo].[TestCaseHistory] ([CreatedByUserId])
INCLUDE ([TestCaseId],[StepId],[TestRunId],[ConfigurationId],[UserStoryId],[OldValue],[NewValue],[FieldName],[Description],[CreatedDateTime])
GO