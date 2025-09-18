CREATE TABLE [dbo].[RoleNotificationType](
	[Id] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[NotificationTypeId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	IsDefaultEnable BIT NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_RoleNotificationType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_RoleNotificationType_RoleId_NotificationTypeId] UNIQUE ([RoleId],[NotificationTypeId])
)
GO

ALTER TABLE [dbo].[RoleNotificationType]  WITH NOCHECK ADD CONSTRAINT [FK_Role_RoleNotificationType_RoleId] FOREIGN KEY ([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

ALTER TABLE [dbo].[RoleNotificationType] CHECK CONSTRAINT [FK_Role_RoleNotificationType_RoleId]
GO