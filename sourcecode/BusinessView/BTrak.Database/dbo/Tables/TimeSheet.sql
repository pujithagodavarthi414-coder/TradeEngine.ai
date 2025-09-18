CREATE TABLE [dbo].[TimeSheet](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Date] [date] NOT NULL,
	[InTime] DATETIMEOFFSET NULL,
	[InTimeTimeZone] UNIQUEIDENTIFIER NULL,
	[LunchBreakStartTime] DATETIMEOFFSET NULL,
	[LunchBreakStartTimeZone] UNIQUEIDENTIFIER NULL,
	[LunchBreakEndTime] DATETIMEOFFSET NULL,
	[LunchBreakEndTimeZone] UNIQUEIDENTIFIER NULL,
	[OutTime] DATETIMEOFFSET NULL,
	[OutTimeTimeZone] UNIQUEIDENTIFIER NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[IsFeed] [bit] NULL,
	[ButtonTypeId] [uniqueidentifier] NULL,
	[Time] [datetime] NULL,
	[UserReason] NVARCHAR(MAX) NULL,
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    [StatusId] UNIQUEIDENTIFIER NULL, 
    CONSTRAINT [PK_TimeSheet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    --CONSTRAINT [AK_TimeSheet_UserId_Date] UNIQUE ([UserId],[Date])
)
GO

CREATE NONCLUSTERED INDEX IX_TimeSheet_UserId_Date 
ON [dbo].[TimeSheet] (  UserId ASC  , [Date] ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_TimeSheet_Date 
ON [dbo].[TimeSheet] (  [Date] ASC  )   
INCLUDE ( InTime , LunchBreakEndTime , LunchBreakStartTime , OutTime , UserId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

ALTER TABLE [TimeSheet] ADD CONSTRAINT UK_TimeSheet_UserId_Date UNIQUE ([UserId],[Date]) 
GO
