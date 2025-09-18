CREATE TABLE [dbo].[TestRailFile](
	[Id] [uniqueidentifier] NOT NULL,
	[FileName] [nvarchar](500) NULL,
	[FilePath] [nvarchar](800) NULL,
	[TestRailId] [uniqueidentifier] NULL,
	[TestRunId] [uniqueidentifier] NULL,
	[IsTestCasePreCondition] [bit] NULL,
	[IsTestCaseStatus] [bit] NULL,
	[IsTestCaseStep] [bit] NULL,
	[IsTestRun] [bit] NULL,
	[IsTestPlan] [bit] NULL,
	[IsMilestone] [bit] NULL,
	[IsTestCase] [bit] NULL,
	[IsExpectedResult] [bit] NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_TestRailFile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TestRailFile]  WITH CHECK ADD  CONSTRAINT [FK_TestRailFile_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[TestRailFile] CHECK CONSTRAINT [FK_TestRailFile_Company]
GO

CREATE NONCLUSTERED INDEX IDX_TestRailFile_TestRailId_InActiveDateTime 
ON [dbo].[TestRailFile] (  TestRailId ASC  , InActiveDateTime ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY]
Go