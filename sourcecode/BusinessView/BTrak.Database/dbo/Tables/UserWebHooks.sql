CREATE TABLE [dbo].[UserWebHooks]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [UserId] UNIQUEIDENTIFIER NOT NULL, 
    [WebHooksXml] XML NOT NULL, 
    [CreatedDatetime] DATETIME NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [InActiveDatetime] DATETIME NULL, 
    CONSTRAINT [PK_UserWebHooks] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_UserWebHooks_ToTable] FOREIGN KEY ([UserId]) REFERENCES [User]([Id])
)
