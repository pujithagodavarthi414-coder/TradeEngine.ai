CREATE TABLE [dbo].[ActivityTrackerAppUrlType]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [AppURL] NVARCHAR(50) NOT NULL, 
    [CreatedDateTime] DATETIMEOFFSET NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL
    CONSTRAINT [PK_ActivityTrackerAppUrlType] PRIMARY KEY ([Id])
)
