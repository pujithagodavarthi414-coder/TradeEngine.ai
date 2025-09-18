CREATE TABLE [dbo].[DocumentTemplates]
(
	Id UNIQUEIDENTIFIER NOT NULL,
	TemplateName VARCHAR(2000),
	TemplatePath VARCHAR(MAX),
	CreatedDateTime DateTime NULL,
	CreatedByUserId UNIQUEIDENTIFIER NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[CompanyId] UNIQUEIDENTIFIER NULL, 
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
CONSTRAINT [PK_DocumentTemplates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO