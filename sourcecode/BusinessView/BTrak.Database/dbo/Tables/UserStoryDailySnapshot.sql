CREATE TABLE [dbo].[UserStoryDailySnapshot](
	[Id] [uniqueidentifier] NOT NULL,
	[UserStoryId] [uniqueidentifier] NOT NULL,
	[UserStoryStatusId] [uniqueidentifier] NOT NULL,
	[SnapshotDateTime] [datetime] NOT NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_UserStoryDailySnapshot] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[UserStoryDailySnapshot]  WITH CHECK ADD  CONSTRAINT [FK_UserStory_UserStoryDailySnapshot_UserStoryId] FOREIGN KEY([UserStoryId])
REFERENCES [dbo].[UserStory] ([Id])
GO

ALTER TABLE [dbo].[UserStoryDailySnapshot] CHECK CONSTRAINT [FK_UserStory_UserStoryDailySnapshot_UserStoryId]
GO