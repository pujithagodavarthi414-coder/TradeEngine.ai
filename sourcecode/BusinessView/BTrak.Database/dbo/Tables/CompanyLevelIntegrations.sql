CREATE TABLE [dbo].[CompanyLevelIntegrations]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
    [IntegrationTypeId] UNIQUEIDENTIFIER NOT NULL, 
    [IntegrationUrl] NVARCHAR(150) NOT NULL, 
    [UserName] NVARCHAR(100) NOT NULL, 
    [ApiToken] NVARCHAR(1500) NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [InactiveDateTime] DATETIME NULL
)
