CREATE TABLE [dbo].[UserNotificationType](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[NotificationTypeId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	IsActive BIT NOT NULL,
	IsDefaultEnable BIT NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_UserNotificationType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_UserNotificationType_UserId_NotificationTypeId] UNIQUE ([UserId],[NotificationTypeId])
)
GO

ALTER TABLE [dbo].[UserNotificationType]  WITH NOCHECK ADD CONSTRAINT [FK_User_RoleNotification_UserId] FOREIGN KEY ([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserNotificationType] CHECK CONSTRAINT [FK_User_RoleNotification_UserId]
GO

