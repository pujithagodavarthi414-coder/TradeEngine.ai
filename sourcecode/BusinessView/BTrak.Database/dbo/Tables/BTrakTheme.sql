CREATE TABLE [dbo].[BTrakTheme]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
    [Name] NVARCHAR(50) NOT NULL, 
    [BaseColor] NVARCHAR(10) NOT NULL, 
    [ArchivedDateTime] DATETIME NULL, 
    [CreatedDateTime] DATETIME NOT NULL
)
