CREATE TABLE [dbo].[TestRailReport](
	[Id] [uniqueidentifier] NOT NULL,	
	[Name] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](500) NULL,			
	[MilestoneId] [uniqueidentifier] NULL,
	[ProjectId] [uniqueidentifier] NULL,
	[TestRunId] [uniqueidentifier] NULL,
	[TestPlanId] [uniqueidentifier] NULL,
	[TestRailReportOptionId]  [varchar](max) NULL,
	[IsOpen] [bit] NULL,
	[IsCompleted] [bit] NULL,
	[CreatedDateTime] [datetimeoffset] NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier]  NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,	
    [PdfUrl] NVARCHAR(250) NULL, 
    CONSTRAINT [PK_TestRailReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[TestRailReport]  WITH CHECK ADD  CONSTRAINT [FK_TestRailReport_Milestone] FOREIGN KEY([MilestoneId])
REFERENCES [dbo].[Milestone] ([Id])
GO

ALTER TABLE [dbo].[TestRailReport] CHECK CONSTRAINT [FK_TestRailReport_Milestone]
GO

ALTER TABLE [dbo].[TestRailReport]  WITH CHECK ADD  CONSTRAINT [FK_TestRailReport_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO

ALTER TABLE [dbo].[TestRailReport] CHECK CONSTRAINT [FK_TestRailReport_Project]
GO
ALTER TABLE [dbo].[TestRailReport]  WITH CHECK ADD  CONSTRAINT [FK_TestRailReport_TestRun] FOREIGN KEY([TestRunId])
REFERENCES [dbo].[TestRun] ([Id])
GO

ALTER TABLE [dbo].[TestRailReport] CHECK CONSTRAINT [FK_TestRailReport_TestRun]
GO

CREATE NONCLUSTERED INDEX [IX_TestRun_[CreatedDateTime]
ON [dbo].[TestRun] ([CreatedDateTime])
INCLUDE ([Id],[MilestoneId],[TestSuiteId])