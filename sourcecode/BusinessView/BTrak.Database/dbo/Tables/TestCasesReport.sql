CREATE TABLE [dbo].[TestCasesReport](
	[Id] [uniqueidentifier] NOT NULL,	
	[ReportId] [uniqueidentifier] NOT NULL,
	[TestRunId] [uniqueidentifier] NOT NULL,
	[TestCaseId] [uniqueidentifier] NOT NULL,
	[TestCaseTitle]  [varchar](500) NOT NULL,
	[AssignToId] [uniqueidentifier] NULL,
	[TestedByUserId] [uniqueidentifier] NULL,
	[StatusId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_TestCasesReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TestCasesReport]  WITH CHECK ADD  CONSTRAINT [FK_TestCasesReport_TestRailReport] FOREIGN KEY([ReportId])
REFERENCES [dbo].[TestRailReport] ([Id])
GO

ALTER TABLE [dbo].[TestCasesReport] CHECK CONSTRAINT [FK_TestCasesReport_TestRailReport]
GO

ALTER TABLE [dbo].[TestCasesReport]  WITH CHECK ADD  CONSTRAINT [FK_TestCasesReport_TestCase] FOREIGN KEY([TestCaseId])
REFERENCES [dbo].[TestCase] ([Id])
GO

ALTER TABLE [dbo].[TestCasesReport] CHECK CONSTRAINT [FK_TestCasesReport_TestCase]
GO
ALTER TABLE [dbo].[TestCasesReport]  WITH CHECK ADD  CONSTRAINT [FK_TestCasesReport_TestCaseStatus] FOREIGN KEY([StatusId])
REFERENCES [dbo].[TestCaseStatus] ([Id])
GO

ALTER TABLE [dbo].[TestCasesReport] CHECK CONSTRAINT [FK_TestCasesReport_TestCaseStatus]
GO

CREATE NONCLUSTERED INDEX IDX_TestCasesReport_ReportId_InActiveDateTime 
ON [dbo].[TestCasesReport] (  ReportId ASC  , InActiveDateTime ASC  )   
INCLUDE ( AssignToId , StatusId , TestCaseId , TestCaseTitle , TestedByUserId , TestRunId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO