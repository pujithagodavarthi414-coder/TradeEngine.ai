CREATE TABLE [dbo].[ActivityTrackerUserConfiguration]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [UserId] UNIQUEIDENTIFIER NOT NULL, 
	[ActivityTrackerAppUrlTypeId] UNIQUEIDENTIFIER NOT NULL, 
	[ScreenShotFrequency] INT NULL,
	[Multiplier] INT NULL,
	[IsTrack] BIT NULL,
	[IsScreenshot] BIT NULL,
	[IsKeyboardTracking] BIT NULL,
	[IsMouseTracking] BIT NULL,
	[ComapnyId] UNIQUEIDENTIFIER NOT NULL,
	[CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIMEOFFSET NOT NULL, 
	[UpdatedByUserId] UNIQUEIDENTIFIER NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL, 
	[InActiveDateTime] DATETIME NULL, 
    [TimeStamp] TIMESTAMP NULL
	CONSTRAINT [FK_ActivityTrackerUserConfiguration_User] FOREIGN KEY ([UserId]) REFERENCES [User]([Id]), 
    CONSTRAINT [PK_ActivityTrackerUserConfiguration] PRIMARY KEY ([Id])
)
