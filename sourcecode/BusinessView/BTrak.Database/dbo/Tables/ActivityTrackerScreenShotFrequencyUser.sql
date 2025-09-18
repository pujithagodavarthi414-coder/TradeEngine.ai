CREATE TABLE [dbo].[ActivityTrackerScreenShotFrequencyUser]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[UserId] UNIQUEIDENTIFIER NOT NULL,
	[ScreenShotFrequency] INT NULL, 
	[FrequencyIndex] INT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIMEOFFSET NOT NULL, 
    [TimeStamp] TIMESTAMP NULL, 
	[InActiveDateTime] DATETIMEOFFSET NULL,
    [ComapnyId] UNIQUEIDENTIFIER NOT NULL,
	[Multiplier] INT NULL,
	[SelectAll] BIT NULL
	CONSTRAINT [FK_ActivityTrackerScreenShotFrequencyUser_User] FOREIGN KEY ([UserId]) REFERENCES [User]([Id]), 
    --CONSTRAINT [FK_ActTrackerScreenShotFrequency_ActTrackerScreenShotFrequency] FOREIGN KEY ([OriginalId]) REFERENCES [ActTrackerScreenShotFrequency]([Id]), 
    CONSTRAINT [PK_ActivityTrackerScreenShotFrequencyUser] PRIMARY KEY ([Id])
)
