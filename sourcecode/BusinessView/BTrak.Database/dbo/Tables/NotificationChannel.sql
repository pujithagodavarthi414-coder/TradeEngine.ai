CREATE TABLE [dbo].[NotificationChannel]
(
	[Id] [uniqueidentifier] NOT NULL,
	[NotificationId] [uniqueidentifier] NOT NULL,
	[Channel] [nvarchar](300),
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	CONSTRAINT [PK_NotificationChannel] PRIMARY KEY CLUSTERED (
		[Id] ASC
    )
)
GO