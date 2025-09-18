CREATE TABLE [dbo].[ShiftWeek](
	[Id] [uniqueidentifier] NOT NULL,
	[ShiftTimingId] [uniqueidentifier] NOT NULL,
	[DayOfWeek] [nvarchar](100) NOT NULL, --TODO: Please change to foreign key
	[StartTime] [time](7) NULL,
	[EndTime] [time](7) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
	[DeadLine] TIME NULL, 
    [AllowedBreakTime] INT NULL, 
	IsPaidBreak BIT NULL,
    [InActiveDateTime] DATETIME NULL, 
    CONSTRAINT [PK_ShiftWeek] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [FK_ShiftWeek_ShitTiming] FOREIGN KEY ([ShiftTimingId]) REFERENCES [ShiftTiming]([Id]) 
)
GO

CREATE NONCLUSTERED INDEX [IX_ShiftWeek_ShiftTimingId_DayOfWeek_InActiveDateTime_Id]
ON [dbo].[ShiftWeek] ([ShiftTimingId],[DayOfWeek],[InActiveDateTime])
INCLUDE ([Id])
GO

CREATE NONCLUSTERED INDEX IX_ShiftWeek_ShiftTimingId_DayOfWeek
ON [dbo].[ShiftWeek] ([ShiftTimingId],[DayOfWeek])
INCLUDE ([DeadLine])
GO

CREATE NONCLUSTERED INDEX IX_ShiftWeek_ShiftTimingId_DayOfWeek_InActiveDateTime
ON [dbo].[ShiftWeek] ([ShiftTimingId],[DayOfWeek],[InActiveDateTime])
GO