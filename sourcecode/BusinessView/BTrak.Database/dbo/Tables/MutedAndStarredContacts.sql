CREATE TABLE [dbo].[MutedOrStarredContacts]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [ChannelId] UNIQUEIDENTIFIER NULL, 
    [UserId] UNIQUEIDENTIFIER NULL, 
    [IsMuted] BIT NOT NULL, 
    [IsStarred] BIT NOT NULL,
	[IsLeave] BIT NULL ,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime] DATETIME NOT NULL,
    CONSTRAINT [PK_MutedOrStarredContacts] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_MutedOrStarredContacts_User] FOREIGN KEY ([UserId]) REFERENCES [User]([Id]), 
    CONSTRAINT [FK_MutedOrStarredContacts_Channel] FOREIGN KEY ([ChannelId]) REFERENCES [Channel]([Id])
)
