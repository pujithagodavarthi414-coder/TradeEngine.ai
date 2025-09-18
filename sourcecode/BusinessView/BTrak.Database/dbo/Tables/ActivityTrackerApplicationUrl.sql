CREATE TABLE [dbo].[ActivityTrackerApplicationUrl]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [AppUrlName] NVARCHAR(MAX) NOT NULL, 
    [ActivityTrackerAppUrlTypeId] UNIQUEIDENTIFIER NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
	[CompanyId] UNIQUEIDENTIFIER NULL,
    [InActiveDateTime] DATETIME NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [TimeStamp] TIMESTAMP NULL, 
    [AppUrlImage] NVARCHAR(MAX) NULL, 
    ApplicationCategoryId UNIQUEIDENTIFIER,
    [IsProductive] BIT NULL, --TODO
    CONSTRAINT [PK_ActivityTrackerApplicationUrl] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_ActivityTrackerApplicationUrl_ActTrackerAppUrlType] FOREIGN KEY ([ActivityTrackerAppUrlTypeId]) REFERENCES [ActivityTrackerAppUrlType]([Id]),
    CONSTRAINT [FK_ApplicationCategory_ActivityTrackerApplicationUrl] FOREIGN KEY (ApplicationCategoryId) REFERENCES [ApplicationCategory]([Id])
)
GO

CREATE NONCLUSTERED INDEX [IX_ActivityTrackerApplicationUrl_InActiveDateTime]
ON [dbo].[ActivityTrackerApplicationUrl] ([InActiveDateTime])
INCLUDE ([AppUrlImage],[AppUrlName])
GO