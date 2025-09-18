CREATE TABLE [dbo].[Message](
	[Id] [uniqueidentifier] NOT NULL,
	[ChannelId] [uniqueidentifier] NULL,
	[SenderUserId] [uniqueidentifier] NOT NULL,
	[ReceiverUserId] [uniqueidentifier] NULL,
	[MessageTypeId] [uniqueidentifier] NOT NULL,
	[TextMessage] [nvarchar](800) NULL,
	[FilePath] [nvarchar](MAX) NULL,
	[IsDeleted] [bit] NULL,
	[IsEdited] [bit] NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[OriginalCreatedDateTime] [datetime] NOT NULL,
	[LastReplyDateTime] [datetime] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[IsActivityMessage] BIT NULL,
	[IsPinned] [bit] NULL,
	[PinnedByUserId] [uniqueidentifier] NULL,
	[ReactedByUserId] [uniqueidentifier] NULL,
	[ReactedDateTime] [datetime] NULL,
    [ParentMessageId] UNIQUEIDENTIFIER NULL, 
    [TaggedMembersIdsXml] XML NULL, 
    [ReportMessage] NVARCHAR(MAX) NULL,
	 CONSTRAINT [PK_ChannelMessage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [FK_Message_Message] FOREIGN KEY ([ParentMessageId]) REFERENCES [Message]([Id])
)
GO
ALTER TABLE [dbo].[Message]  WITH CHECK ADD  CONSTRAINT [FK_Channel_Message_ChannelId] FOREIGN KEY([ChannelId])
REFERENCES [dbo].[Channel] ([Id])
GO

ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Channel_Message_ChannelId]
GO

ALTER TABLE [dbo].[Message]  WITH NOCHECK ADD CONSTRAINT [FK_Message_Message_OriginalId] FOREIGN KEY ([Id])
REFERENCES [dbo].[Message] ([Id])
GO

ALTER TABLE [dbo].[Message] CHECK CONSTRAINT [FK_Message_Message_OriginalId]
GO

CREATE NONCLUSTERED INDEX [IX_Message_InActiveDateTime_ParentMessageId_SenderUserId]
ON [dbo].[Message] ([InActiveDateTime],[ParentMessageId],[SenderUserId])
INCLUDE ([ChannelId],[OriginalCreatedDateTime])
GO

CREATE NONCLUSTERED INDEX [IX_Message_ChannelId_InActiveDateTime_ParentMessageId]
ON [dbo].[Message] ([ChannelId],[InActiveDateTime],[ParentMessageId])
INCLUDE ([SenderUserId],[OriginalCreatedDateTime])
GO

CREATE NONCLUSTERED INDEX [IX_Message_ChannelId_SenderUserId_CreatedDateTime_InActiveDateTime_ParentMessageId]
ON [dbo].[Message] ([ChannelId],[SenderUserId],[CreatedDateTime],[InActiveDateTime],[ParentMessageId])
GO

CREATE NONCLUSTERED INDEX [IX_Message_InActiveDateTime_ParentMessageId]
ON [dbo].[Message] ([InActiveDateTime],[ParentMessageId])
INCLUDE ([SenderUserId],[ReceiverUserId])
GO

CREATE NONCLUSTERED INDEX [IX_Message_ChannelId_InActiveDateTime_ParentMessageId_SenderUserId_ReceiverUserId_CreatedDateTime]
ON [dbo].[Message] ([ChannelId],[InActiveDateTime],[ParentMessageId])
INCLUDE ([SenderUserId],[ReceiverUserId],[CreatedDateTime])
GO

CREATE NONCLUSTERED INDEX [IX_Message_InActiveDateTime_ReactedByUserId_ParentMessageId]
ON [dbo].[Message] ([InActiveDateTime],[ReactedByUserId])
INCLUDE ([ParentMessageId])
GO