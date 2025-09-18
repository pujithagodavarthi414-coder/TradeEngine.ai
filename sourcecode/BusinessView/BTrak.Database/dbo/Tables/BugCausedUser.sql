CREATE TABLE BugCausedUser(
Id UNIQUEIDENTIFIER NOT NULL,
UserStoryId UNIQUEIDENTIFIER NOT NULL,
UserId UNIQUEIDENTIFIER NOT NULL,
[CreatedDateTime] [datetime] NOT NULL,
[CreatedDateTimeZoneId] [uniqueidentifier]  NULL,
[CreatedByUserId] [uniqueidentifier] NOT NULL,
[UpdatedDateTime] [datetime] NULL,
[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
[UpdatedByUserId] [uniqueidentifier] NULL,
[InActiveDateTime] [datetime] NULL,
[InActiveDateTimeZoneId] [uniqueidentifier] NULL,
[TimeStamp] TIMESTAMP,
CONSTRAINT [PK_BugCausedUser] PRIMARY KEY ([Id]),
CONSTRAINT [Fk_UserStory_BugCausedUser_UserStoryId] FOREIGN KEY (UserStoryId) REFERENCES [UserStory](Id),
CONSTRAINT [Fk_User_BugCausedUser_UserId] FOREIGN KEY (UserId) REFERENCES [User](Id)
)
GO

CREATE NONCLUSTERED INDEX IX_BugCausedUser_UserStoryId 
ON [dbo].[BugCausedUser] (  UserStoryId ASC  )   
INCLUDE ( UserId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO