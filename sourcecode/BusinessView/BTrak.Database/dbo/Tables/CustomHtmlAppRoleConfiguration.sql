CREATE TABLE [dbo].[CustomHtmlAppRoleConfiguration]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [CustomHtmlAppId] UNIQUEIDENTIFIER NOT NULL, 
    [RoleId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [InActiveDateTime] DATETIME NULL, 
    CONSTRAINT [PK_CustomHtmlAppRoleConfiguration] PRIMARY KEY ([Id])
)
