CREATE TABLE [dbo].[UserStoryReplan](
	[Id] [uniqueidentifier] NOT NULL,
	[GoalId] [uniqueidentifier] NULL,
	[GoalReplanId] [uniqueidentifier] NOT NULL,
	[GoalReplanCount] [int],
	[UserStoryId] [uniqueidentifier] NOT NULL,
	[UserStoryReplanTypeId] [uniqueidentifier] NULL,
	[UserStoryReplanJson] [nvarchar](800) NOT NULL,
	[OldValue] [nvarchar](500) NULL,
	[NewValue] [nvarchar](500) NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier] NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_UserStoryReplan] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[UserStoryReplan]  WITH NOCHECK ADD CONSTRAINT [FK_UserStoryReplan_UserStoryReplanType_UserStoryReplanTypeId] FOREIGN KEY ([UserStoryReplanTypeId])
REFERENCES [dbo].[UserStoryReplanType] ([Id])
GO

ALTER TABLE [dbo].[UserStoryReplan] CHECK CONSTRAINT [FK_UserStoryReplan_UserStoryReplanType_UserStoryReplanTypeId]
GO

CREATE NONCLUSTERED INDEX IX_UserStoryReplan_GoalReplanId_UserStoryId 
ON [dbo].[UserStoryReplan] (  GoalReplanId ASC  , UserStoryId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_UserStoryReplan_UserStoryId 
ON [dbo].[UserStoryReplan] (  UserStoryId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO