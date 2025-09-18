CREATE TABLE [dbo].[AssetHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[AssetId] [uniqueidentifier] NOT NULL,
	[AssetHistoryJson] [nvarchar] (MAX) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime ] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_AssetHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[AssetHistory]  WITH NOCHECK ADD CONSTRAINT [FK_Asset_AssetHistory_AssetId] FOREIGN KEY ([AssetId])
REFERENCES [dbo].[Asset] ([Id])
GO

ALTER TABLE [dbo].[AssetHistory] CHECK CONSTRAINT [FK_Asset_AssetHistory_AssetId]
GO
