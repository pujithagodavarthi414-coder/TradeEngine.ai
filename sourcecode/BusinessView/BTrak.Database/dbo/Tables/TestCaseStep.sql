CREATE TABLE [dbo].[TestCaseStep](
	[Id] [uniqueidentifier] NOT NULL,
	[TestCaseId] [uniqueidentifier] NULL,
	[Step] [nvarchar](MAX) NULL,
	[StepOrder] [INT] NULL,
	[ExpectedResult] [nvarchar](max) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime]  NULL,
	[UpdatedByUserId] [uniqueidentifier]  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_TestCaseStep] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TestCaseStep]  WITH NOCHECK ADD  CONSTRAINT [FK_TestCaseStep_TestCaseId] FOREIGN KEY([TestCaseId])
REFERENCES [dbo].[TestCase] ([Id])
GO

ALTER TABLE [dbo].[TestCaseStep] CHECK CONSTRAINT [FK_TestCaseStep_TestCaseId]
GO

CREATE NONCLUSTERED INDEX IX_TestCaseStep_TestCaseId_InActiveDateTime 
ON [dbo].[TestCaseStep] (  TestCaseId ASC  , InActiveDateTime ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO