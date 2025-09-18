CREATE TABLE [dbo].[UserStoryReview] (
    [Id]  UNIQUEIDENTIFIER NOT NULL,
    [UserStoryReviewTemplateId]  UNIQUEIDENTIFIER NOT NULL,
    [AnswerJson]    NVARCHAR (MAX)  NULL,
	[SubmittedDateTime] DATETIMEOFFSET NOT NULL,
    [CreatedDateTime] DATETIMEOFFSET NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_UserStoryReview] PRIMARY KEY CLUSTERED ([Id] ASC),
)
GO

ALTER TABLE [dbo].[UserStoryReview]  WITH NOCHECK ADD CONSTRAINT [FK_UserStoryReviewTemplate_UserStoryReview_UserStoryReviewTemplateId] FOREIGN KEY ([UserStoryReviewTemplateId])
REFERENCES [dbo].[UserStoryReviewTemplate] ([Id])
GO

ALTER TABLE [dbo].[UserStoryReview] CHECK CONSTRAINT [FK_UserStoryReviewTemplate_UserStoryReview_UserStoryReviewTemplateId]
GO