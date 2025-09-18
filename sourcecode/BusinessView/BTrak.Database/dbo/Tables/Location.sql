CREATE TABLE [dbo].[Location]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [Name] NVARCHAR(50) NOT NULL, 
    [InactiveDateTime] DATETIME2 NULL, 
    [CreatedDateTime] DATETIME2 NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedDateTime] DATETIME2 NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [TimeStamp] TIMESTAMP NOT NULL, 
    CONSTRAINT [PK_Location] PRIMARY KEY ([Id])
)
