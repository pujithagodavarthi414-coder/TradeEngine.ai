CREATE TABLE [dbo].[Status]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [StatusName] NVARCHAR(50) NOT NULL, 
	[CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
	[CompanyId] UNIQUEIDENTIFIER NULL,
    [InActiveDateTime] DATETIME NULL, 
    [TimeStamp] TIMESTAMP NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [StatusColour] NVARCHAR(20) NULL, 
    CONSTRAINT [PK_Status] PRIMARY KEY ([Id]),
)
