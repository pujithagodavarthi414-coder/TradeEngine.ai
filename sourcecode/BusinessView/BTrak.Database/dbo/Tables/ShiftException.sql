CREATE TABLE [dbo].[ShiftException]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [ShiftTimingId] [uniqueidentifier] NOT NULL,
	[ExceptionDate] DATETIME NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndTime] [time](7) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,	
	[DeadLine] TIME NULL, 
    [AllowedBreakTime] INT NULL, 
    [InActiveDateTime] DATETIME NULL, 
    CONSTRAINT [PK_ShiftException] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_ShiftException_ShitTiming] FOREIGN KEY ([ShiftTimingId]) REFERENCES [ShiftTiming]([Id]) 
)
