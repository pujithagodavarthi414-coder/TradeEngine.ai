CREATE TABLE [dbo].[AuditFolder]
(
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[AuditFolderName] [nvarchar](300) NOT NULL,
    [ParentAuditFolderId] [uniqueidentifier] NULL,
	[Description] [nvarchar](MAX) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
	[InActiveDateTime] [datetime] NULL,
	[ProjectId] [uniqueidentifier] NULL, --DEFAULT NOT NULL
    CONSTRAINT [PK_AuditFolder] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[AuditFolder]  WITH NOCHECK ADD  CONSTRAINT [FK_Project_AuditFolder_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO

ALTER TABLE [dbo].[AuditFolder] CHECK CONSTRAINT [FK_Project_AuditFolder_ProjectId]
GO
