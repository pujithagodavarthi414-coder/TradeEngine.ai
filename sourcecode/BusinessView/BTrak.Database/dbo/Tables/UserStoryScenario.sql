CREATE TABLE [dbo].[UserStoryScenario](
	[Id] [uniqueidentifier] NOT NULL,
	[UserStoryId] [uniqueidentifier] NOT NULL,
	[TestCaseId] [uniqueidentifier] NOT NULL,
	[StatusId]   [uniqueidentifier] NULL,
	[CreatedDateTime] [datetimeoffset] NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier] NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetimeoffset] NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_UserStoryScenario] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserStoryScenario]  WITH CHECK ADD  CONSTRAINT [FK_UserStoryScenario_TestCase] FOREIGN KEY([TestCaseId])
REFERENCES [dbo].[TestCase] ([Id])
GO

ALTER TABLE [dbo].[UserStoryScenario] CHECK CONSTRAINT [FK_UserStoryScenario_TestCase]
GO

ALTER TABLE [dbo].[UserStoryScenario]  WITH CHECK ADD  CONSTRAINT [FK_UserStoryScenario_UserStory] FOREIGN KEY([UserStoryId])
REFERENCES [dbo].[UserStory] ([Id])
GO

ALTER TABLE [dbo].[UserStoryScenario] CHECK CONSTRAINT [FK_UserStoryScenario_UserStory]
GO
