CREATE TABLE [dbo].[UserStoryReviewTemplate] (
    [Id]  UNIQUEIDENTIFIER NOT NULL,
    [ReviewTemplateId]  UNIQUEIDENTIFIER NOT NULL,
    [UserStoryId] UNIQUEIDENTIFIER  NOT NULL,
    [ReviewerId] UNIQUEIDENTIFIER NULL,
    [ReviewComments] NVARCHAR(500)  NULL,
    [IsAccepted] BIT NULL,
    [CreatedDateTime] DATETIMEOFFSET NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime] DATETIMEOFFSET NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_UserStoryReviewTemplate] PRIMARY KEY CLUSTERED ([Id] ASC),
)
GO

ALTER TABLE [dbo].[UserStoryReviewTemplate]  WITH NOCHECK ADD CONSTRAINT [FK_UserStory_UserStoryReviewTemplate_UserStoryId] FOREIGN KEY ([UserStoryId])
REFERENCES [dbo].[UserStory] ([Id])
GO

ALTER TABLE [dbo].[UserStoryReviewTemplate] CHECK CONSTRAINT [FK_UserStory_UserStoryReviewTemplate_UserStoryId]
GO

ALTER TABLE [dbo].[UserStoryReviewTemplate]  WITH NOCHECK ADD CONSTRAINT [FK_User_UserStoryReviewTemplate_ReviewerId] FOREIGN KEY ([ReviewerId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserStoryReviewTemplate] CHECK CONSTRAINT [FK_User_UserStoryReviewTemplate_ReviewerId]
GO