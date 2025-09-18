CREATE TABLE [dbo].[ActivityTrackerApplicationUrlRole]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [ActivityTrackerApplicationUrlId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByDateTime] DATETIME NOT NULL, 
	[UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [IsArchive] BIT NULL, 
    [InActiveDateTime] DATETIME NULL, 
    [TimeStamp] TIMESTAMP NOT NULL, 
    [IsProductive] BIT NULL, 
    [RoleId] UNIQUEIDENTIFIER NOT NULL, 
    CONSTRAINT [PK_ActivityTrackerApplicationUrlRole] PRIMARY KEY ([Id]),  
    CONSTRAINT [FK_ActivityTrackerApplicationUrlRole_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [User]([Id]), 
    CONSTRAINT [FK_ActivityTrackerApplicationUrlRole_Role] FOREIGN KEY ([RoleId]) REFERENCES [Role]([Id]), 
    CONSTRAINT [FK_ActivityTrackerApplicationUrlRole_ActivityTrackerApplicationUrl] FOREIGN KEY ([ActivityTrackerApplicationUrlId]) REFERENCES [ActivityTrackerApplicationUrl]([Id])
)
