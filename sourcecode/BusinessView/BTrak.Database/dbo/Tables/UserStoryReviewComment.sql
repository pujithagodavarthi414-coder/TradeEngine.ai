CREATE TABLE [dbo].[UserStoryReviewComment](
	[Id] [uniqueidentifier] NOT NULL,
	[UserStoryId] [uniqueidentifier] NOT NULL,
	[Comment] [nvarchar](1000) NOT NULL,
	[UserStoryReviewStatusId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] [timestamp] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserStoryReviewComment]  WITH CHECK ADD  CONSTRAINT [FK_UserStory_UserStoryReviewComment_UserStoryId] FOREIGN KEY([UserStoryId])
REFERENCES [dbo].[UserStory] ([Id])
GO

ALTER TABLE [dbo].[UserStoryReviewComment] CHECK CONSTRAINT [FK_UserStory_UserStoryReviewComment_UserStoryId]
GO
ALTER TABLE [dbo].[UserStoryReviewComment]  WITH CHECK ADD  CONSTRAINT [FK_UserStoryReviewStatus_UserStoryReviewComment_UserStoryReviewStatusId] FOREIGN KEY([UserStoryReviewStatusId])
REFERENCES [dbo].[UserStoryReviewStatus] ([Id])
GO

ALTER TABLE [dbo].[UserStoryReviewComment] CHECK CONSTRAINT [FK_UserStoryReviewStatus_UserStoryReviewComment_UserStoryReviewStatusId]
GO