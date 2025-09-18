CREATE TABLE UserActivityTrackerStatus
(
	[Id] [uniqueidentifier] NOT NULL
	,UserId UNIQUEIDENTIFIER
	,CompanyId UNIQUEIDENTIFIER NULL
	,DesktopId UNIQUEIDENTIFIER NULL
	,StartDateTime DATETIME --StartTime
	,TrackedDateTime DATETIME --EndTime
	,[KeyStroke] INT
	,[MouseMovement] INT
	,IdleTimeInMin INT NULL
	,CreatedDateTime DATETIME
	,[IsLogged] BIT NULL
	,[IsIdleRecord] BIT NULL DEFAULT 0 
CONSTRAINT [PK_UserActivityTrackerStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    CONSTRAINT [FK_UserActivityTrackerStatus_ActivityTrackerDesktop] FOREIGN KEY ([DesktopId]) REFERENCES [ActivityTrackerDesktop]([Id])
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_UserActivityTrackerStatus_UserId_KeyStroke_MouseMovement
ON [dbo].[UserActivityTrackerStatus] ([TrackedDateTime])
INCLUDE ([UserId],[KeyStroke],[MouseMovement])
GO

CREATE NONCLUSTERED INDEX IX_UserActivityTrackerStatus_KeyStroke_MouseMovement
ON [dbo].[UserActivityTrackerStatus] ([UserId],[TrackedDateTime])
INCLUDE ([KeyStroke],[MouseMovement])
GO