CREATE TABLE [dbo].[TestRunSelectedStep](
    [Id] [uniqueidentifier] NOT NULL,
	[StepId] [uniqueidentifier] NOT NULL,
	[StatusId] [uniqueidentifier] NULL,
	[ActualResult] [nvarchar](MAX) NULL,
    [TestRunId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP,
CONSTRAINT [PK_TestRunSelectedStep] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TestRunSelectedStep]  WITH CHECK ADD  CONSTRAINT [FK_TestRunSelectedStep_TestRun] FOREIGN KEY([TestRunId])
REFERENCES [dbo].[TestRun] ([Id])
GO

ALTER TABLE [dbo].[TestRunSelectedStep] CHECK CONSTRAINT [FK_TestRunSelectedStep_TestRun]
GO

ALTER TABLE [dbo].[TestRunSelectedStep]  WITH CHECK ADD  CONSTRAINT [FK_TestRunSelectedStep_TestCaseStep] FOREIGN KEY([StepId])
REFERENCES [dbo].[TestCaseStep] ([Id])
GO

ALTER TABLE [dbo].[TestRunSelectedStep] CHECK CONSTRAINT [FK_TestRunSelectedStep_TestCaseStep]
GO

CREATE NONCLUSTERED INDEX IDX_TestRunSelectedStep_StepId_InActiveDateTime 
ON [dbo].[TestRunSelectedStep] (  StepId ASC  , InActiveDateTime ASC  )   
INCLUDE ( ActualResult , StatusId , TestRunId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO