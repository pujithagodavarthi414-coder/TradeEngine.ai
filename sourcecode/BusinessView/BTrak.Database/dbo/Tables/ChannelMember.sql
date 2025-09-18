CREATE TABLE [dbo].[ChannelMember](
	[Id] [uniqueidentifier] NOT NULL,
	[ChannelId] [uniqueidentifier] NOT NULL,
	[MemberUserId] [uniqueidentifier] NOT NULL,
	[ActiveFrom] [datetime] NOT NULL,
	[ActiveTo] [datetime] NULL,
	[IsActiveMember] [BIT] NULL,
	[IsReadOnly] [BIT] NOT NULL DEFAULT 0,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_ChannelMember] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[ChannelMember]  WITH CHECK ADD  CONSTRAINT [FK_Channel_ChannelMember_ChannelId] FOREIGN KEY([ChannelId])
REFERENCES [dbo].[Channel] ([Id])
GO

ALTER TABLE [dbo].[ChannelMember] CHECK CONSTRAINT [FK_Channel_ChannelMember_ChannelId]
GO

--CREATE NONCLUSTERED INDEX [IX_ChannelMember_MemberUserId]
--ON [dbo].[ChannelMember] ([MemberUserId])
--GO

CREATE NONCLUSTERED INDEX [IX_ChannelMember_MemberUserId]
ON [dbo].[ChannelMember] ([MemberUserId])
INCLUDE ([ChannelId])
GO

CREATE NONCLUSTERED INDEX [IX_ChannelMember_MemberUserId_InActiveDateTime]
ON [dbo].[ChannelMember] ([MemberUserId],[InActiveDateTime])
INCLUDE ([ChannelId])
GO