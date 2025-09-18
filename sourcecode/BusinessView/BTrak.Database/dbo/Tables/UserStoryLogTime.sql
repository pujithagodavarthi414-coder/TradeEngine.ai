CREATE TABLE [dbo].[UserStoryLogTime](
	[Id] [uniqueidentifier] NOT NULL,
	[UserStoryId] [uniqueidentifier] NULL,
	[StartDateTime] DATETIMEOFFSET NOT NULL,
	[EndDateTime] DATETIMEOFFSET NULL,
	[UserId] [uniqueidentifier] NULL,
	[IsStarted] [bit] NOT NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_UserStoryLogTime] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[UserStoryLogTime]  WITH CHECK ADD  CONSTRAINT [FK_UserStory_UserStoryLogTime_UserStoryId] FOREIGN KEY([UserStoryId])
REFERENCES [dbo].[UserStory] ([Id])
GO

ALTER TABLE [dbo].[UserStoryLogTime] CHECK CONSTRAINT [FK_UserStory_UserStoryLogTime_UserStoryId]
GO