CREATE TABLE [dbo].[ControllerApiFeature](
	[Id] [uniqueidentifier] NOT NULL,
	[FeatureId] [uniqueidentifier] NOT NULL,
	[ControllerApiNameId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_ControllerApiFeature] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_ControllerApiFeature_FeatureId_ControllerApiNameId] UNIQUE ([FeatureId], [ControllerApiNameId])
)
GO
ALTER TABLE [dbo].[ControllerApiFeature]  WITH CHECK ADD  CONSTRAINT [FK_ControllerApiName_ControllerApiFeature_ControllerApiNameId] FOREIGN KEY([ControllerApiNameId])
REFERENCES [dbo].[ControllerApiName] ([Id])
GO

ALTER TABLE [dbo].[ControllerApiFeature] CHECK CONSTRAINT [FK_ControllerApiName_ControllerApiFeature_ControllerApiNameId]
GO
ALTER TABLE [dbo].[ControllerApiFeature]  WITH CHECK ADD  CONSTRAINT [FK_Feature_ControllerApiFeature_FeatureId] FOREIGN KEY([FeatureId])
REFERENCES [dbo].[Feature] ([Id])
GO

ALTER TABLE [dbo].[ControllerApiFeature] CHECK CONSTRAINT [FK_Feature_ControllerApiFeature_FeatureId]
GO
ALTER TABLE [dbo].[ControllerApiFeature]  WITH CHECK ADD  CONSTRAINT [FK_User_ControllerApiFeature_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ControllerApiFeature] CHECK CONSTRAINT [FK_User_ControllerApiFeature_CreatedByUserId]
GO
ALTER TABLE [dbo].[ControllerApiFeature]  WITH CHECK ADD  CONSTRAINT [FK_User_ControllerApiFeature_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ControllerApiFeature] CHECK CONSTRAINT [FK_User_ControllerApiFeature_UpdatedByUserId]