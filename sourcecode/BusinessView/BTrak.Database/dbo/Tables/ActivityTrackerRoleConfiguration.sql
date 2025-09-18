CREATE TABLE [dbo].[ActivityTrackerRoleConfiguration]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [RoleId] UNIQUEIDENTIFIER NOT NULL, 
    [ActivityTrackerAppUrlTypeId] UNIQUEIDENTIFIER NOT NULL, 
	[FrequencyIndex] INT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIMEOFFSET NOT NULL, 
	[InActiveDateTime] DATETIME NULL, 
	[SelectAll] BIT NULL,
    [TimeStamp] TIMESTAMP NULL, 
    [ComapnyId] UNIQUEIDENTIFIER NOT NULL, 
    [ConsiderPunchCard] BIT NOT NULL DEFAULT 1, 
    CONSTRAINT [FK_ActivityTrackerRoleConfiguration_ActivityTrackerAppUrlType] FOREIGN KEY ([ActivityTrackerAppUrlTypeId]) REFERENCES [ActivityTrackerAppUrlType]([Id]), 
    CONSTRAINT [FK_ActivityTrackerRoleConfiguration_Role] FOREIGN KEY ([RoleId]) REFERENCES [Role]([Id]), 
    --CONSTRAINT [FK_ActTrackerRoleConfiguration_ActTrackerRoleConfiguration] FOREIGN KEY ([OriginalId]) REFERENCES [ActTrackerRoleConfiguration]([Id]), 
    CONSTRAINT [PK_ActivityTrackerRoleConfiguration] PRIMARY KEY ([Id]) 
)
GO

CREATE NONCLUSTERED INDEX [IX_ActivityTrackerRoleConfiguration_ComapnyId]
ON [dbo].[ActivityTrackerRoleConfiguration] ([ComapnyId])
GO
