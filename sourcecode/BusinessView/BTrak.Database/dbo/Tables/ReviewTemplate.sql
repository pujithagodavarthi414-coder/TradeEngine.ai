CREATE TABLE [dbo].[ReviewTemplate] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [TemplateJson]    NVARCHAR (MAX)  NOT NULL,
    [UserStorySubTypeId] UNIQUEIDENTIFIER     NOT NULL,
    [CompanyId] [uniqueidentifier]  NOT NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime] DATETIME         NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_ReviewTemplate] PRIMARY KEY CLUSTERED ([Id] ASC),
)
GO

ALTER TABLE [dbo].[ReviewTemplate]  WITH NOCHECK ADD CONSTRAINT [FK_UserStorySubType_ReviewTemplate_UserStorySubTypeId] FOREIGN KEY ([UserStorySubTypeId])
REFERENCES [dbo].[UserStorySubType] ([Id])
GO

ALTER TABLE [dbo].[ReviewTemplate] CHECK CONSTRAINT [FK_UserStorySubType_ReviewTemplate_UserStorySubTypeId]
GO