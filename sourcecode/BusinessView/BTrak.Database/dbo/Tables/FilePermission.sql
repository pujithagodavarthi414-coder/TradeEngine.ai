CREATE TABLE [dbo].[FilePermission]
(
	[Id] [uniqueidentifier] NOT NULL,
	[FileId] [uniqueidentifier] NULL,
	[IsReadPermission] [bit] NULL,
	[IsWritePermission] [bit] NULL,
	[IsDownloadPermission] [bit] NULL,
	[UserId] [uniqueidentifier] NULL,
	[RoleId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_FilePermission] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[FilePermission]  WITH NOCHECK ADD CONSTRAINT [FK_User_FilePermission_UserId] FOREIGN KEY ([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[FilePermission] CHECK CONSTRAINT [FK_User_FilePermission_UserId]
GO

ALTER TABLE [dbo].[FilePermission]  WITH NOCHECK ADD CONSTRAINT [FK_User_FilePermission_RoleId] FOREIGN KEY ([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

ALTER TABLE [dbo].[FilePermission] CHECK CONSTRAINT [FK_User_FilePermission_RoleId]
GO
ALTER TABLE [dbo].[FilePermission]  WITH NOCHECK ADD CONSTRAINT [FK_UploadFile_FilePermission_FileId] FOREIGN KEY ([FileId])
REFERENCES [dbo].[UploadFile] ([Id])
GO

ALTER TABLE [dbo].[FilePermission] CHECK CONSTRAINT [FK_UploadFile_FilePermission_FileId]
GO