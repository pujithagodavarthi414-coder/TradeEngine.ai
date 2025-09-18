CREATE TABLE [dbo].[AssetComment](
	[Id] [uniqueidentifier] NOT NULL,
	[AssetId] [uniqueidentifier] NOT NULL,
	[Comment] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_AssetComment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[AssetComment]  WITH CHECK ADD  CONSTRAINT [FK_Asset_AssetComment_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[Asset] ([Id])
GO

ALTER TABLE [dbo].[AssetComment] CHECK CONSTRAINT [FK_Asset_AssetComment_AssetId]
GO
