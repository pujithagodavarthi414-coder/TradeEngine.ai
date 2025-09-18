CREATE TABLE [dbo].[StarredMessages]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [MessageId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [InActiveDateTime] DATETIME NULL, 
    CONSTRAINT [PK_StarredMessages] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_StarredMessages_Message] FOREIGN KEY ([MessageId]) REFERENCES [Message]([Id]), 
    CONSTRAINT [FK_StarredMessages_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [User]([Id])
)
