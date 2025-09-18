CREATE TABLE [dbo].[LinkUserStory]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [UserStoryId] UNIQUEIDENTIFIER NOT NULL, 
    [LinkUserStoryTypeId] UNIQUEIDENTIFIER NULL, 
    [LinkUserStoryId] UNIQUEIDENTIFIER NULL, 
    [CreatedDateTime] DATETIMEOFFSET NOT NULL, 
    [CreatedDateTimeZoneId] UNIQUEIDENTIFIER NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIMEOFFSET NULL, 
    [UpdatedDateTimeZoneId] UNIQUEIDENTIFIER NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [InActiveDateTime] DATETIME NULL, 
    [InActiveDateTimeZoneId] UNIQUEIDENTIFIER NULL,  
    [TimeStamp] TIMESTAMP NOT NULL
CONSTRAINT [PK_LinkUserStory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [dbo].[LinkUserStory]  WITH CHECK ADD  CONSTRAINT [FK_LinkUserStory_LinkUserStoryTypeId] FOREIGN KEY([LinkUserStoryTypeId])
REFERENCES [dbo].[LinkUserStoryType] ([Id])
GO

ALTER TABLE [dbo].[LinkUserStory] CHECK CONSTRAINT [FK_LinkUserStory_LinkUserStoryTypeId]
GO
ALTER TABLE [dbo].[LinkUserStory]  WITH CHECK ADD  CONSTRAINT [FK_LinkUserStory_UserStoryId] FOREIGN KEY([UserStoryId])
REFERENCES [dbo].[UserStory] ([Id])
GO

ALTER TABLE [dbo].[LinkUserStory] CHECK CONSTRAINT [FK_LinkUserStory_UserStoryId]
GO