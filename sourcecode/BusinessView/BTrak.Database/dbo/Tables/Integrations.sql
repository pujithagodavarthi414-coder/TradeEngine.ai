CREATE TABLE [dbo].[Integrations]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
    [TypeName] NVARCHAR(50) NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [InactiveDateTime] DATETIME NULL
)
