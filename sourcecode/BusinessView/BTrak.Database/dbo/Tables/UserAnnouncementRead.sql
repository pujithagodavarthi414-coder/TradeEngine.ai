CREATE TABLE [dbo].[UserAnnouncementRead](
	[Id] [uniqueidentifier] NOT NULL,
	[AnnouncementId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ReadDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InActiveDateTime] [datetime] NULL,
CONSTRAINT [PK_UserAnnouncementRead] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserAnnouncementRead]  WITH CHECK ADD CONSTRAINT [FK_UserAnnouncementRead_User_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserAnnouncementRead] CHECK CONSTRAINT [FK_UserAnnouncementRead_User_UserId]
GO

ALTER TABLE [dbo].[UserAnnouncementRead]  WITH CHECK ADD CONSTRAINT [FK_UserAnnouncementRead_Announcement_AnnouncementId] FOREIGN KEY([AnnouncementId])
REFERENCES [dbo].[Announcement] ([Id])
GO

ALTER TABLE [dbo].[UserAnnouncementRead] CHECK CONSTRAINT [FK_UserAnnouncementRead_Announcement_AnnouncementId]
GO