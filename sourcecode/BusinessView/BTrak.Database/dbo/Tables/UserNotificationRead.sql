CREATE TABLE [dbo].[UserNotificationRead]
(
	[Id] [uniqueidentifier] NOT NULL,
	[NotificationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ReadDateTime] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	CONSTRAINT [PK_UserNotificationRead] PRIMARY KEY CLUSTERED (
		[Id] ASC
    )
)
GO

ALTER TABLE [dbo].[UserNotificationRead]  WITH NOCHECK ADD CONSTRAINT [FK_User_UserNotificationRead_UserId] FOREIGN KEY ([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserNotificationRead] CHECK CONSTRAINT [FK_User_UserNotificationRead_UserId]
GO
