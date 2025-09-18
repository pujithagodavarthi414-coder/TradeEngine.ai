CREATE TABLE [dbo].[FileDownload]
(
	[Id] [uniqueidentifier] NOT NULL,
	[FileId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_FileDownload] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[FileDownload]  WITH NOCHECK ADD CONSTRAINT [FK_User_FileDownload_UserId] FOREIGN KEY ([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[FileDownload] CHECK CONSTRAINT [FK_User_FileDownload_UserId]
GO

ALTER TABLE [dbo].[FileDownload]  WITH NOCHECK ADD CONSTRAINT [FK_UploadFile_FileDownload_FileId] FOREIGN KEY ([FileId])
REFERENCES [dbo].[UploadFile] ([Id])
GO

ALTER TABLE [dbo].[FileDownload] CHECK CONSTRAINT [FK_UploadFile_FileDownload_FileId]
GO