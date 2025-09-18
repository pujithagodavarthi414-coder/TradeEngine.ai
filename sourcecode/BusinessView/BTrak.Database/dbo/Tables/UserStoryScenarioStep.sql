CREATE  TABLE   [dbo].[UserStoryScenarioStep](
    [Id] [uniqueidentifier] NOT NULL,
    [UserStoryId] [uniqueidentifier] NOT NULL,
	[StepId] [uniqueidentifier] NOT NULL,
	[StatusId] [uniqueidentifier] NULL,
    [CreatedDateTime] [datetimeoffset] NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier] NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetimeoffset] NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP,
CONSTRAINT [PK_UserStoryScenarioStep] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserStoryScenarioStep]  WITH CHECK ADD  CONSTRAINT [FK_UserStoryScenarioStep_UserStory] FOREIGN KEY([UserStoryId])
REFERENCES [dbo].[UserStory] ([Id])
GO

ALTER TABLE [dbo].[UserStoryScenarioStep] CHECK CONSTRAINT [FK_UserStoryScenarioStep_UserStory]
GO
ALTER TABLE [dbo].[UserStoryScenarioStep]  WITH CHECK ADD  CONSTRAINT [FK_UserStoryScenarioStep_TestCaseStep] FOREIGN KEY([StepId])
REFERENCES [dbo].[TestCaseStep] ([Id])
GO

ALTER TABLE [dbo].[UserStoryScenarioStep] CHECK CONSTRAINT [FK_UserStoryScenarioStep_TestCaseStep]
GO
ALTER TABLE [dbo].[UserStoryScenarioStep]  WITH CHECK ADD  CONSTRAINT [FK_UserStoryScenarioStep_TestCaseStatus] FOREIGN KEY([StatusId])
REFERENCES [dbo].[TestCaseStatus] ([Id])
GO

ALTER TABLE [dbo].[UserStoryScenarioStep] CHECK CONSTRAINT [FK_UserStoryScenarioStep_TestCaseStatus]
GO