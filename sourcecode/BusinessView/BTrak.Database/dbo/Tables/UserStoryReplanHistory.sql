CREATE TABLE [dbo].[UserStoryReplanHistory]
(
   [Id] UNIQUEIDENTIFIER NOT NULL,
   [UserStoryId] UNIQUEIDENTIFIER NOT NULL,
   [GoalId] UNIQUEIDENTIFIER NULL,
   [UserStoryReplanTypeId] UNIQUEIDENTIFIER NULL,
   [FieldName] NVARCHAR(500) NULL,
   [OldValue] NVARCHAR(500) NULL,
   [NewValue] NVARCHAR(500) NULL,
   [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
   [CreatedDateTime] DATETIME NOT NULL,
   [UpdatedDateTime] DATETIMEOFFSET NULL,
   [UpdatedByUserId] [uniqueidentifier] NULL,
   [GoalReplanTypeId] UNIQUEIDENTIFIER NULL, 
   [GoalReplanId] UNIQUEIDENTIFIER NOT NULL, 
    CONSTRAINT [PK_UserStoryReplanHistory] PRIMARY KEY ([Id]),
   CONSTRAINT [FK_UserStoryReplanHistory_UserStory] FOREIGN KEY ([UserStoryId]) REFERENCES [UserStory]([Id]),
   CONSTRAINT [FK_UserStoryReplanHistory_Goal] FOREIGN KEY ([GoalId]) REFERENCES [Goal]([Id]),
   CONSTRAINT [FK_UserStoryReplanHistory_UserStoryReplan] FOREIGN KEY ([UserStoryReplanTypeId]) REFERENCES [UserStoryReplanType]([Id]),
   CONSTRAINT [FK_UserStoryReplanHistory_UserStoryReplanHistory] FOREIGN KEY ([Id]) REFERENCES [UserStoryReplanHistory]([Id]),
   CONSTRAINT [FK_UserStoryReplanHistory_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [User]([Id]), 
   CONSTRAINT [FK_UserStoryReplanHistory_GoalReplan] FOREIGN KEY ([GoalReplanId]) REFERENCES [GoalReplan]([Id]), 
   CONSTRAINT [FK_UserStoryReplanHistory_GoalReplanType] FOREIGN KEY ([GoalReplanTypeId]) REFERENCES [GoalReplanType]([Id])
)
GO

CREATE NONCLUSTERED INDEX IX_UserStoryReplanHistory_GoalId 
ON [dbo].[UserStoryReplanHistory] (  GoalId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO