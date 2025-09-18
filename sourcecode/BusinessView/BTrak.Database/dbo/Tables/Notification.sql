CREATE TABLE [dbo].[Notification]
(
	[Id] [uniqueidentifier] NOT NULL,
	[NotificationTypeId] [uniqueidentifier] NOT NULL,
	[Summary] [nvarchar](500) NOT NULL,
	[NotificationJson] [nvarchar](MAX) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	CONSTRAINT [PK_Notification] PRIMARY KEY CLUSTERED (
		[Id] ASC
    )
)
GO