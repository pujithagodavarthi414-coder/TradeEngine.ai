CREATE TABLE [dbo].[DocumentSet]
(
	[Id] [uniqueidentifier] NOT NULL,
	[RootFolderId] [uniqueidentifier] NULL,
	[FileId] [uniqueidentifier] NOT NULL,
	[ReferenceId] [uniqueidentifier] NOT NULL,
	[ReferenceTypeId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_DocumentSet] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[DocumentSet]  WITH NOCHECK ADD CONSTRAINT [FK_Folder_DocumentSet_RootFolderId] FOREIGN KEY ([RootFolderId])
REFERENCES [dbo].[Folder] ([Id])
GO

ALTER TABLE [dbo].[DocumentSet] CHECK CONSTRAINT [FK_Folder_DocumentSet_RootFolderId]
GO

ALTER TABLE [dbo].[DocumentSet]  WITH NOCHECK ADD CONSTRAINT [FK_UploadFile_DocumentSet_FileId] FOREIGN KEY ([FileId])
REFERENCES [dbo].[UploadFile] ([Id])
GO

ALTER TABLE [dbo].[DocumentSet] CHECK CONSTRAINT [FK_UploadFile_DocumentSet_FileId]
GO
