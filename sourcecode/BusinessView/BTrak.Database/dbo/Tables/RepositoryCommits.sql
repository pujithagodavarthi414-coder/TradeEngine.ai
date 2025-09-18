CREATE TABLE [dbo].[RepositoryCommits]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[FromSource] NVARCHAR(50) NULL,
	[CommitMessage] NVARCHAR(2000) NULL,
	[CommiterEmail] NVARCHAR(50) NULL,
	[CommiterName] NVARCHAR(100) NULL,
	[FilesModified] NVARCHAR(MAX) NULL,
	[FiledAdded] NVARCHAR(MAX) NULL,
	[FilesRemoved] NVARCHAR(MAX) NULL,
	[RepositoryName] NVARCHAR(250) NULL,
	[CommitReferenceUrl] NVARCHAR(600) NULL,
    [CreatedDateTime] DATETIME NULL, 
    [CommitedByUserId] UNIQUEIDENTIFIER NULL, 
	[CompanyId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_RepositoryCommits] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RepositoryCommits]  WITH CHECK ADD  CONSTRAINT [FK_RepositoryCommits_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[Badge] CHECK CONSTRAINT [FK_RepositoryCommits_Company]
GO