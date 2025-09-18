CREATE TABLE [dbo].[EntityRoleFeature](
	[Id] [uniqueidentifier] NOT NULL,
	[EntityFeatureId] [uniqueidentifier] NOT NULL,
	[EntityRoleId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_EntityRoleFeature] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[EntityRoleFeature] WITH NOCHECK ADD CONSTRAINT [FK_EntityFeature_EntityRoleFeature_EntityFeatureId] FOREIGN KEY ([EntityFeatureId])
REFERENCES [dbo].[EntityFeature] ([Id])
GO

ALTER TABLE [dbo].[EntityRoleFeature] CHECK CONSTRAINT [FK_EntityFeature_EntityRoleFeature_EntityFeatureId]
GO

ALTER TABLE [dbo].[EntityRoleFeature] WITH NOCHECK ADD CONSTRAINT [FK_EntityRole_EntityRoleFeature_EntityRoleId] FOREIGN KEY ([EntityRoleId])
REFERENCES [dbo].[EntityRole] ([Id])
GO

ALTER TABLE [dbo].[EntityRoleFeature] CHECK CONSTRAINT [FK_EntityRole_EntityRoleFeature_EntityRoleId]
GO

CREATE NONCLUSTERED INDEX IX_EntityRoleFeature_EntityRoleId_InActiveDateTime
ON [dbo].[EntityRoleFeature] ([EntityRoleId],[InActiveDateTime])
INCLUDE ([Id],[EntityFeatureId])
GO