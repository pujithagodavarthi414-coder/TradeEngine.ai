
CREATE TABLE [dbo].[ActivityScreenShot](
	[Id] [uniqueidentifier] NOT NULL,
	[MACAddress] [nvarchar](12) NOT NULL,
	[DesktopId] [uniqueidentifier] NULL,
	[UserId] [uniqueidentifier] NULL,
	[ScreenShotName] [nvarchar](max) NOT NULL,
	[ScreenShotUrl] [nvarchar](max) NOT NULL,
	[ScreenShotDateTime] DATETIMEOFFSET NOT NULL,
	[Reason] [nvarchar](800) NULL,
	[KeyStroke] [decimal] NULL,
	[MouseMovement] [decimal] NULL,
	[ApplicationName] [nvarchar](800) NULL,
	[ApplicationTypeId] [uniqueidentifier] NOT NULL,
	[ApplicationId] [uniqueidentifier] NULL,
	[IsArchived] [bit] NULL,
	[CreatedDateTime] [date] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [date] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL, 
    [ScreenShotTimeZoneId] UNIQUEIDENTIFIER NULL, 
    CONSTRAINT [FK_ActivityScreenShot_TmeZone] FOREIGN KEY ([ScreenShotTimeZoneId]) REFERENCES [TimeZone]([Id]), 
    CONSTRAINT [FK_ActivityScreenShot_ActivityTrackerDesktop] FOREIGN KEY ([DesktopId]) REFERENCES [ActivityTrackerDesktop]([Id])
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_ActivityScreenShot_CreatedDateTime]
ON [dbo].[ActivityScreenShot] ([CreatedDateTime])
GO

CREATE NONCLUSTERED INDEX [IX_ActivityScreenShot_CreatedDateTime_Id]
ON [dbo].[ActivityScreenShot] ([CreatedDateTime])
INCLUDE ([Id],[UserId],[ScreenShotName],[ScreenShotUrl],[ScreenShotDateTime],[Reason],[KeyStroke],[MouseMovement],[ApplicationName],[ApplicationTypeId],[IsArchived],[UpdatedByUserId])
GO

CREATE NONCLUSTERED INDEX [IX_ActivityScreenShot_UserId_CreatedDateTime]
ON [dbo].[ActivityScreenShot] ([UserId],[CreatedDateTime])
INCLUDE ([ScreenShotDateTime])
GO