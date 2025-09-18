CREATE TABLE [dbo].[AppUrlNames]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [AppUrlName] NVARCHAR(MAX) NOT NULL, 
    [AppUrlTypeId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [InActiveDateTime] DATETIME NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [OriginalId] UNIQUEIDENTIFIER NULL, 
    [AsAtInActiveDateTime] DATETIME NULL, 
    [VersionNumber] INT NULL, 
    [TimeStamp] TIMESTAMP NULL, 
    [IsProductive] BIT NULL, 
    [AppUrlImage] NVARCHAR(MAX) NULL, 
    CONSTRAINT [PK_AppUrlNames] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_AppUrlNames_ActTrackerAppUrlType] FOREIGN KEY ([AppUrlTypeId]) REFERENCES [ActTrackerAppUrlType]([Id])
)
