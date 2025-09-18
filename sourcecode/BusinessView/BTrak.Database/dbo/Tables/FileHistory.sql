CREATE TABLE [dbo].[FileHistory]
(
	[Id] [uniqueidentifier] NOT NULL,
	[Comment] [nvarchar] (2000) NOT NULL,
	[FileId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL, 
 CONSTRAINT [PK_FileHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[FileHistory]  WITH NOCHECK ADD CONSTRAINT [FK_UploadFile_FileHistory_FileId] FOREIGN KEY ([FileId])
REFERENCES [dbo].[UploadFile] ([Id])
GO

ALTER TABLE [dbo].[FileHistory] CHECK CONSTRAINT [FK_UploadFile_FileHistory_FileId]
GO