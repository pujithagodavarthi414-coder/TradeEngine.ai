CREATE TABLE [dbo].[UserStorySpentTime](
	[Id] [uniqueidentifier] NOT NULL,
	[UserStoryId] [uniqueidentifier] NOT NULL,
	[SpentTimeInMin] FLOAT NULL,
	[RemainingTimeInMin] FLOAT NULL,
	[Comment] [nvarchar](MAX) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[DateFrom] [datetimeoffset] NULL,
	[DateFromTimeZoneId] [uniqueidentifier] NULL,
	[DateTo] [datetimeoffset] NULL,
	[DateToTimeZoneId] [uniqueidentifier] NULL,
	[LogTimeOptionId] [uniqueidentifier] NULL,
	[UserInput] [int] NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [SpentTime] DECIMAL(18, 2) NULL, 
	[StartTime] DATETIMEOFFSET NULL,
	[StartTimeTimeZoneId]  [uniqueidentifier] NULL,
	[EndTime] DATETIMEOFFSET NULL,
	[EndTimeTimeZoneId]  [uniqueidentifier] NULL,
  [BreakType] BIT NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
    [CreatedDateTimeZoneId] UNIQUEIDENTIFIER NULL, 
    CONSTRAINT [PK_UserStorySpentTime] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE NONCLUSTERED INDEX IX_UserStorySpentTime_CreatedByUserId 
ON [dbo].[UserStorySpentTime] (  CreatedByUserId ASC  )   
INCLUDE ( CreatedDateTime , SpentTimeInMin , UserStoryId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_UserStorySpentTime_UserStoryId_UserId 
ON [dbo].[UserStorySpentTime] (  UserStoryId ASC  , UserId ASC  )   
INCLUDE ( SpentTimeInMin )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_UserStorySpentTime_StartTime
ON [dbo].[UserStorySpentTime] ([StartTime])
GO

CREATE NONCLUSTERED INDEX IX_UserStorySpentTime_UserId_CreatedDateTime
ON [dbo].[UserStorySpentTime] ([InActiveDateTime],[StartTime],[EndTime])
INCLUDE ([UserId],[CreatedDateTime])
GO