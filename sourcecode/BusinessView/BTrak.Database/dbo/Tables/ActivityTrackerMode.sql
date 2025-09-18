CREATE TABLE [dbo].[ActivityTrackerMode]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
    [ModeName] NVARCHAR(250) NULL, 
    [ModeTypeEnum] INT NULL , 
    [ModeDescription] NVARCHAR(1000) NULL,
    [CreatedDateTime] DATETIMEOFFSET NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL
)
