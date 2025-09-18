CREATE TABLE [dbo].[TestRun](
	[Id] [uniqueidentifier] NOT NULL,
	[ProjectId] [uniqueidentifier] NULL,
	[Name] [nvarchar](250) NOT NULL,
	[MilestoneId] [uniqueidentifier] NULL,
	[AssignToId] [uniqueidentifier] NULL,
	[Description] [nvarchar](500) NULL,
	[IsIncludeAllCases] [bit] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TestPlanId] [uniqueidentifier] NULL,
	[IsOpen] [bit] NULL,
	[IsCompleted] [bit] NULL,
	[TestSuiteId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_TestRun] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TestRun]  WITH NOCHECK ADD  CONSTRAINT [FK_TestRun_AssignTo] FOREIGN KEY([AssignToId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[TestRun] CHECK CONSTRAINT [FK_TestRun_AssignTo]
GO

ALTER TABLE [dbo].[TestRun]  WITH NOCHECK ADD  CONSTRAINT [FK_TestRun_Milestone] FOREIGN KEY([MilestoneId])
REFERENCES [dbo].[Milestone] ([Id])
GO

ALTER TABLE [dbo].[TestRun] CHECK CONSTRAINT [FK_TestRun_Milestone]
GO