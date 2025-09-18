CREATE TABLE [dbo].[HtmlTemplates]
(
	Id UNIQUEIDENTIFIER NOT NULL,
	TemplateName VARCHAR(2000),
	HtmlTemplate VARCHAR(MAX),
	CreatedDateTime DateTime NULL,
	IsConfigurable BIT NOT NULL DEFAULT 0,
	CreatedByUserId UNIQUEIDENTIFIER NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[CompanyId] UNIQUEIDENTIFIER NULL, 
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
CONSTRAINT [PK_HtmlTemplates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO