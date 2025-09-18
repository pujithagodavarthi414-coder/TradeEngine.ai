CREATE TABLE [dbo].[ActivityTrackerScreenShotFrequency]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [RoleId] UNIQUEIDENTIFIER NOT NULL, 
    [ScreenShotFrequency] INT NULL, 
	[FrequencyIndex] INT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIMEOFFSET NOT NULL, 
    [TimeStamp] TIMESTAMP NULL, 
	[InActiveDateTime] DATETIMEOFFSET NULL,
    [ComapnyId] UNIQUEIDENTIFIER NOT NULL,
	[Multiplier] INT NULL, 
	[SelectAll] BIT NULL,
	[RandomScreenshot] BIT NULL,
    CONSTRAINT [FK_ActivityTrackerScreenShotFrequency_Role] FOREIGN KEY ([RoleId]) REFERENCES [Role]([Id]), 
    --CONSTRAINT [FK_ActTrackerScreenShotFrequency_ActTrackerScreenShotFrequency] FOREIGN KEY ([OriginalId]) REFERENCES [ActTrackerScreenShotFrequency]([Id]), 
    CONSTRAINT [PK_ActivityTrackerScreenShotFrequency] PRIMARY KEY ([Id])
)
