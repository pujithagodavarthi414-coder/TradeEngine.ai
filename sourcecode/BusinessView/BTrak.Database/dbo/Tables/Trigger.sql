CREATE TABLE [dbo].[Trigger]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
    [TriggerName] NVARCHAR(50) NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [InactiveDateTime] DATETIME NULL, 
)
