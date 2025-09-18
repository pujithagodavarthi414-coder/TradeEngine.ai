CREATE TABLE [dbo].[ActivityTrackerStatus]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [MACAddress] NCHAR(12) NULL, 
    [UserId] UNIQUEIDENTIFIER NULL, 
    [LastActiveDateTime] DATETIME NULL ,
	[Date] DATE NULL,
	[ActivityTrackerStartTime] DATETIME NULL, 
    [IpAddress] NVARCHAR(200) NULL, 
    [OffSet] INT NOT NULL DEFAULT 0, 
    [TimeZoneId] UNIQUEIDENTIFIER NULL, 
    [DesktopId] UNIQUEIDENTIFIER NULL
    CONSTRAINT [PK_ActivityTrackerStatus] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_ActivityTrackerStatus_TimeZone] FOREIGN KEY ([TimeZoneId]) REFERENCES [TimeZone]([Id]), 
    CONSTRAINT [FK_ActivityTrackerStatus_ActivityTrackerDesktop] FOREIGN KEY ([DesktopId]) REFERENCES [ActivityTrackerDesktop]([Id])
)
