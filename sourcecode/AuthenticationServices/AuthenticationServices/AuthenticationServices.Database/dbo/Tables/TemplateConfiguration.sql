CREATE TABLE [dbo].[TemplateConfiguration]
(
	Id UNIQUEIDENTIFIER NOT NULL,
	HtmlTemplateId UNIQUEIDENTIFIER NOT NULL,
	Roles NVARCHAR(MAX) NULL,
	Mails NVARCHAR(MAX) NULL,
	CreatedDateTime DateTime NULL,
	CreatedByUserId UNIQUEIDENTIFIER NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[CompanyId] UNIQUEIDENTIFIER NULL, 
	[InActiveDateTime] [datetime] NULL
CONSTRAINT [PK_TemplateConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO