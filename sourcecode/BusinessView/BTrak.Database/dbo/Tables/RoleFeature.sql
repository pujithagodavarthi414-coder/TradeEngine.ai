CREATE TABLE [dbo].[RoleFeature](
	[Id] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[FeatureId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_RoleFeature] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[RoleFeature]  WITH CHECK ADD  CONSTRAINT [FK_Feature_RoleFeature_FeatureId] FOREIGN KEY([FeatureId])
REFERENCES [dbo].[Feature] ([Id])
GO

ALTER TABLE [dbo].[RoleFeature] CHECK CONSTRAINT [FK_Feature_RoleFeature_FeatureId]
GO
ALTER TABLE [dbo].[RoleFeature]  WITH CHECK ADD  CONSTRAINT [FK_Role_RoleFeature_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

ALTER TABLE [dbo].[RoleFeature] CHECK CONSTRAINT [FK_Role_RoleFeature_RoleId]
GO
ALTER TABLE [dbo].[RoleFeature]  WITH CHECK ADD  CONSTRAINT [FK_User_RoleFeature_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RoleFeature] CHECK CONSTRAINT [FK_User_RoleFeature_CreatedByUserId]
GO
ALTER TABLE [dbo].[RoleFeature]  WITH CHECK ADD  CONSTRAINT [FK_User_RoleFeature_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RoleFeature] CHECK CONSTRAINT [FK_User_RoleFeature_UpdatedByUserId]
GO

CREATE NONCLUSTERED INDEX [IX_RoleFeature_RoleId_InActiveDateTime]
ON [dbo].[RoleFeature] ([RoleId],[InActiveDateTime])
INCLUDE ([FeatureId])
GO

CREATE NONCLUSTERED INDEX IX_RoleFeature_FeatureId_InActiveDateTime
ON [dbo].[RoleFeature] ([FeatureId],[InActiveDateTime])
INCLUDE ([RoleId])
GO

CREATE NONCLUSTERED INDEX IX_RoleFeature_RoleId_FeatureId_InActiveDateTime
ON [dbo].[RoleFeature] ([RoleId],[FeatureId],[InActiveDateTime])
GO

CREATE  NONCLUSTERED   INDEX [IX_RoleFeature_Feature_RoleId_InActiveDateTime] ON [RoleFeature]
([FeatureId] , [RoleId] ,[InActiveDateTime])INCLUDE ([CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
GO