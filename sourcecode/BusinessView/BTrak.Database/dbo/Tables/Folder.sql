CREATE TABLE [dbo].[Folder]
(
	[Id] [uniqueidentifier] NOT NULL,
	[FolderName] [nvarchar](300) NOT NULL,
    [ParentFolderId] [uniqueidentifier] NULL,
	[StoreId] [uniqueidentifier] NOT NULL,
	[FolderSize] BIGINT NULL, 
	[FolderReferenceId] [uniqueidentifier] NULL,
	[FolderReferenceTypeId] [uniqueidentifier] NULL,
	[Description] [nvarchar](MAX) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
	[InActiveDateTime] [datetime] NULL,
    CONSTRAINT [PK_Folder] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [FK_Folder_Store_StoreId] FOREIGN KEY ([StoreId]) REFERENCES [Store]([Id])
)
GO
CREATE NONCLUSTERED INDEX [IDX_Folder_InActiveDateTime]
ON [dbo].[Folder] ([InActiveDateTime])
INCLUDE ([ParentFolderId])
GO

CREATE NONCLUSTERED INDEX [IDX_UploadFile_CompanyId_FolderId]
ON [dbo].[UploadFile] ([CompanyId],[FolderId])
GO



CREATE NONCLUSTERED INDEX [IDX_Folder_StoreId]
ON [dbo].[Folder] ([StoreId])
INCLUDE ([FolderName],[ParentFolderId],[FolderSize],[CreatedDateTime],[CreatedByUserId],[TimeStamp],[InActiveDateTime])
Go