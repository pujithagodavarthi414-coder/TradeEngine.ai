CREATE TABLE [dbo].[WeekDays]
(
    [Id] [uniqueidentifier] NOT NULL,
	[WeekDay] INT NOT NULL, 
	[WeekDayName] VARCHAR(20) NOT NULL, 
    [IsWeekend] BIT NULL, 
    [IsHalfDay] BIT NULL,
	[SortOrder] int NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime]  DATETIME          NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_WeekDays] PRIMARY KEY ([Id])
)
GO