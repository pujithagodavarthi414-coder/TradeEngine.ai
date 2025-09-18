CREATE TABLE [dbo].[UserStoryHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[UserStoryId] [uniqueidentifier] NOT NULL,
	[OldValue]  [nvarchar](MAX)  NULL,
	[NewValue]  [nvarchar](MAX)  NULL,
	[FieldName]  [nvarchar](50)  NULL,
	[Description]  [nvarchar](max)  NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZoneId]  [uniqueidentifier]  NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_UserStoryHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserStoryHistory]  WITH NOCHECK ADD CONSTRAINT [FK_UserStory_UserStoryHistory_UserStoryId] FOREIGN KEY ([UserStoryId])
REFERENCES [dbo].[UserStory] ([Id])
GO

ALTER TABLE [dbo].[UserStoryHistory]  CHECK CONSTRAINT [FK_UserStory_UserStoryHistory_UserStoryId]
GO

CREATE NONCLUSTERED INDEX IX_UserStoryHistory_UserStoryId 
ON [dbo].[UserStoryHistory] (  UserStoryId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO