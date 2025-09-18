CREATE TABLE [dbo].[UserActivityTime](
	[Id] [uniqueidentifier] NOT NULL,
	[MACAddress] [nvarchar](20) NULL,
	[UserId] [uniqueidentifier] NULL,
	[DesktopId] [uniqueidentifier] NULL,
	[ApplicationId] [uniqueidentifier] NULL,
	[ApplicationStartTime] [datetime] NOT NULL,
	[ApplicationEndTime] [datetime] NOT NULL,
	[ApplicationTypeId] [uniqueidentifier] NULL,
	[SpentTime] [time](7) NOT NULL,
	[IdleTime] [time](7) NOT NULL,
	[OtherApplication] [nvarchar](800) NULL,
	[TrackedUrl] [nvarchar](MAX) NULL,
	[CommonUrl] [nvarchar](MAX) NULL,
	[AbsoluteAppName] [nvarchar](MAX) NULL,
	[IsApp] [bit] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL, 
    CONSTRAINT [FK_UserActivityTime_ActivityTrackerDesktop] FOREIGN KEY ([DesktopId]) REFERENCES [ActivityTrackerDesktop]([Id])
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_UserActivityTime_UserId_CreatedDateTime_InActiveDateTime]
ON [dbo].[UserActivityTime] ([UserId],[CreatedDateTime],[InActiveDateTime])
INCLUDE ([Id],[MACAddress],[ApplicationId],[ApplicationStartTime],[ApplicationEndTime],[ApplicationTypeId],[SpentTime],[IdleTime],[OtherApplication],[TrackedUrl],[IsApp],[TimeStamp])
GO