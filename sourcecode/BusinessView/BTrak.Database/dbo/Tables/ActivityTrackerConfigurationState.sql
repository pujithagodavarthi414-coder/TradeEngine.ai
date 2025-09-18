CREATE TABLE [dbo].[ActivityTrackerConfigurationState]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
	[IsBasicTracking] BIT NULL,
    [IsTracking] BIT NULL, 
    [IsScreenshot] BIT NULL, 
    [IsDelete] BIT NULL, 
    [DeleteRoles] BIT NULL, 
    [IsRecord] BIT NULL, 
    [RecordRoles] BIT NULL, 
	[IsMouse] BIT NULL,
	[MouseRoles] BIT NULL,
    [IsIdealTime] BIT NULL, 
    [IdealTimeRoles] BIT NULL, 
    [IsManualTime] BIT NULL, 
    [ManualTimeRole] BIT NULL, 
	[IsOfflineTracking] BIT NULL,
	[offlineOpen] BIT NULL,
    [CompanyId] UNIQUEIDENTIFIER NULL,
	[TimeStamp] TIMESTAMP NULL,     
    [DisableUrls] BIT NULL DEFAULT 0
)
