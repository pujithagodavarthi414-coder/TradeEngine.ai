CREATE TABLE [dbo].[ActivityTrackerRolePermission]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIMEOFFSET NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [IsDeleteScreenShots] BIT NULL, 
    [IsRecordActivity] BIT NULL, 
    [IsIdleTime] BIT NULL, 
	[MinimumIdelTime] INT NULL,
    [IdleScreenShotCaptureTime] INT NULL, 
    [IdleAlertTime] INT NULL, 
    [IsManualEntryTime] BIT NULL, 
	[IsOfflineTracking] BIT NULL,
	[IsMouseTracking] BIT NULL,
	[InActiveDateTime] DATETIME NULL,
    [RoleId] UNIQUEIDENTIFIER NOT NULL, 
    CONSTRAINT [PK_ActivityTrackerRolePermission] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_ActivityTrackerRolePermission_Role] FOREIGN KEY ([RoleId]) REFERENCES [Role]([Id])
)
GO

CREATE NONCLUSTERED INDEX IX_ActivityTrackerRolePermission_CompanyId_InActiveDateTime
ON [dbo].[ActivityTrackerRolePermission] ([CompanyId],[InActiveDateTime])
GO
