CREATE TABLE [dbo].[NotificationType]
(
	[Id] [uniqueidentifier] NOT NULL,
	[FeatureId] [uniqueidentifier] NOT NULL,
	[NotificationTypeName] [nvarchar](800) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_NotificationType] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)   WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_NotificationType_NotificationTypeName] UNIQUE (FeatureId,[NotificationTypeName])
)
GO

ALTER TABLE [dbo].[NotificationType]  WITH NOCHECK ADD CONSTRAINT [FK_Feature_NotificationType_FeatureId] FOREIGN KEY ([FeatureId])
REFERENCES [dbo].[Feature] ([Id])
GO

ALTER TABLE [dbo].[NotificationType] CHECK CONSTRAINT [FK_Feature_NotificationType_FeatureId]
GO
