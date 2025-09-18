CREATE TABLE [dbo].[EntityFeature](
	[Id] [uniqueidentifier] NOT NULL,
	[EntityTypeId] [uniqueidentifier] NOT NULL,
	[EntityFeatureName] [nvarchar](250) NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[ParentFeatureId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_EntityFeature] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EntityFeature] WITH NOCHECK ADD CONSTRAINT [FK_EntityType_EntityFeature_EntityTypeId] FOREIGN KEY ([EntityTypeId])
REFERENCES [dbo].[EntityType] ([Id])
GO

ALTER TABLE [dbo].[EntityFeature] CHECK CONSTRAINT [FK_EntityType_EntityFeature_EntityTypeId]
GO