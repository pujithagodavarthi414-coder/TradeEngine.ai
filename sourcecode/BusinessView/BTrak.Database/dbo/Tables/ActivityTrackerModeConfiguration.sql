CREATE TABLE [dbo].[ActivityTrackerModeConfiguration]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [ModeId] UNIQUEIDENTIFIER NULL, 
    [Roles] NVARCHAR(MAX) NULL, 
    [ShiftBased] BIT NULL,
    [PunchCardBased] BIT NULL,
    [CreatedDateTime] DATETIMEOFFSET NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedDateTime] DATETIMEOFFSET NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    CONSTRAINT [FK_ActivityTrackerModeConfiguration_Company] FOREIGN KEY ([CompanyId]) REFERENCES [Company]([Id]), 
    CONSTRAINT [FK_ActivityTrackerModeConfiguration_ActivityTrackerMode] FOREIGN KEY ([ModeId]) REFERENCES [ActivityTrackerMode]([Id]), 
    CONSTRAINT [FK_ActivityTrackerModeConfiguration_CreatedUser_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [User]([Id]), 
    CONSTRAINT [FK_ActivityTrackerModeConfiguration_UpdatedUser_User] FOREIGN KEY ([UpdatedByUserId]) REFERENCES [User]([Id])
)
