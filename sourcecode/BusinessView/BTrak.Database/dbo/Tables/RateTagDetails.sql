CREATE TABLE [dbo].[RateTagDetails]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [RateTagId] [uniqueidentifier] NULL,
    [RateTagForId] [uniqueidentifier] NULL,
	[RateTagForType] NVARCHAR(50) NULL,
	[RateTagForTypeName] NVARCHAR(250) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime]  DATETIME          NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
CONSTRAINT [PK_RateTagDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [dbo].[RateTagDetails]  WITH NOCHECK ADD CONSTRAINT [FK_RateTagDetails_RateTag_RateTagId] FOREIGN KEY([RateTagId])
REFERENCES [dbo].[RateTag] ([Id])
GO

ALTER TABLE [dbo].[RateTagDetails] CHECK CONSTRAINT [FK_RateTagDetails_RateTag_RateTagId]
GO

ALTER TABLE [dbo].[RateTagDetails]  WITH CHECK ADD  CONSTRAINT [FK_RateTagDetails_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RateTagDetails] CHECK CONSTRAINT [FK_RateTagDetails_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[RateTagDetails]  WITH CHECK ADD  CONSTRAINT [FK_RateTagDetails_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RateTagDetails] CHECK CONSTRAINT [FK_RateTagDetails_User_UpdatedByUserId]
GO