CREATE TABLE [dbo].[Policy] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [Name]             NVARCHAR (250)    NOT NULL,
    [Description]      NVARCHAR (800)   NULL,
    [PdfFileBlobPath]  NVARCHAR (MAX)   NULL,
    [WordFileBlobPath] NVARCHAR (MAX)   NULL,
    [ReviewDate]       DATETIME         NOT NULL,
    [CategoryId]       UNIQUEIDENTIFIER NOT NULL,
    [MustRead]         BIT              NULL DEFAULT 0,
    [CompanyId]        UNIQUEIDENTIFIER NULL,
    [CreatedDateTime]  DATETIME         NOT NULL,
    [CreatedByUserId]  UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime]  DATETIME         NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER NULL,
    [InActiveDateTime]  DATETIME         NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_Policy] PRIMARY KEY CLUSTERED ([Id] ASC)
)
