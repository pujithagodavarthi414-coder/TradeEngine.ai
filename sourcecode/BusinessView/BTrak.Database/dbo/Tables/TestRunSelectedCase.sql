CREATE TABLE [dbo].[TestRunSelectedCase](
	[Id] [uniqueidentifier] NOT NULL,
	[TestRunId] [uniqueidentifier] NOT NULL,
	[TestCaseId] [uniqueidentifier] NOT NULL,
	[StatusId]         UNIQUEIDENTIFIER NULL,
    [StatusComment]    NVARCHAR (Max)   NULL,
	[AssignToComment]  NVARCHAR (MAX)   NULL,
    [AssignToId]       UNIQUEIDENTIFIER NULL,
    [Version]          NVARCHAR (100)    NULL,
    [Elapsed]          DATETIME      NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_TestRunSelectedCase] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TestRunSelectedCase]  WITH CHECK ADD  CONSTRAINT [FK_TestRunSelectedCase_TestCase] FOREIGN KEY([TestCaseId])
REFERENCES [dbo].[TestCase] ([Id])
GO

ALTER TABLE [dbo].[TestRunSelectedCase] CHECK CONSTRAINT [FK_TestRunSelectedCase_TestCase]
GO

ALTER TABLE [dbo].[TestRunSelectedCase]  WITH CHECK ADD  CONSTRAINT [FK_TestRunSelectedCase_TestRun] FOREIGN KEY([TestRunId])
REFERENCES [dbo].[TestRun] ([Id])
GO

ALTER TABLE [dbo].[TestRunSelectedCase] CHECK CONSTRAINT [FK_TestRunSelectedCase_TestRun]
GO

CREATE NONCLUSTERED INDEX IDX_TestRunSelectedCase_TestRunId_InactiveDateTime 
ON [dbo].[TestRunSelectedCase] (  TestRunId ASC  , InActiveDateTime ASC  )   
INCLUDE ( TestCaseId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IDX_TestRunSelectedCase_TestRunId_TestCaseId_InActiveDateTime 
ON [dbo].[TestRunSelectedCase] (  TestRunId ASC  , TestCaseId ASC  , InActiveDateTime ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IDX_TestRunSelectedCase_InActiveDateTime 
ON [dbo].[TestRunSelectedCase] (  InActiveDateTime ASC  )   
INCLUDE ( AssignToId , StatusComment , StatusId , TestCaseId , TestRunId , TimeStamp )  
WHERE  ([InActiveDateTime] IS NULL ) 
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE INDEX [IX_TestRunSelectedCase_TestCaseId_InActiveDateTime] 
ON [dbo].[TestRunSelectedCase] ([TestCaseId], [InActiveDateTime])
GO

CREATE INDEX [IX_TestRunSelectedCase_TestRunId_InActiveDateTime] 
ON [dbo].[TestRunSelectedCase] ([TestRunId], [InActiveDateTime]) 
INCLUDE ([TestCaseId], [StatusId])
GO

CREATE INDEX [IX_TestRunSelectedCase_TestCaseId_InActiveDateTime_TestRunId_StatusId] 
ON [dbo].[TestRunSelectedCase] ([TestCaseId], [InActiveDateTime]) 
INCLUDE ([TestRunId], [StatusId])
GO
CREATE NONCLUSTERED INDEX [IDX_TestRunSelectedCase_TestRunId]
ON [dbo].[TestRunSelectedCase] ([TestRunId])
INCLUDE ([TestCaseId],[StatusId])
GO

CREATE NONCLUSTERED INDEX [IX_TestRunSelectedCase_StatusId_InActiveDateTime]
ON [dbo].[TestRunSelectedCase] ([StatusId],[InActiveDateTime])
INCLUDE ([Id],[TestRunId],[TestCaseId],[StatusComment],[AssignToId],[TimeStamp])