CREATE TABLE [dbo].[UploadFile]
(
	[Id] [uniqueidentifier] NOT NULL,
	[FileName] [nvarchar](800) NOT NULL,
	[FilePath] [nvarchar](2000) NOT NULL,
	[FileExtension] [nvarchar](50) NOT NULL,
	[FileSize] [BIGINT] NULL,
	[Description] [nvarchar](800) NULL,
	[ReferenceId] [uniqueidentifier] NULL,
	[ReferenceTypeId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
	[InActiveDateTime] [datetime] NULL,
	[IsQuestionDocuments] BIT NULL,
	[QuestionDocumentId] [uniqueidentifier] NULL,
	[FolderId] [uniqueidentifier] NULL,
	[StoreId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[IstoBeReviewed] BIT NULL,
	[ReviewedDateTime] [datetime] NULL,
	[ReviewedByUserId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_UploadFile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [FK_UploadFile_Store_StoreId] FOREIGN KEY ([StoreId]) REFERENCES [Store]([Id]), 
    CONSTRAINT [FK_UploadFile_Company_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [Company]([Id])
)
GO

ALTER TABLE [dbo].[UploadFile]  WITH NOCHECK ADD CONSTRAINT [FK_Folder_UploadFile_FolderId] FOREIGN KEY ([FolderId])
REFERENCES [dbo].[Folder] ([Id])
GO

ALTER TABLE [dbo].[UploadFile] CHECK CONSTRAINT [FK_Folder_UploadFile_FolderId]
GO