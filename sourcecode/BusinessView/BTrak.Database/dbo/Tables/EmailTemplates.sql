﻿CREATE TABLE [dbo].[EmailTemplates]
(
	Id UNIQUEIDENTIFIER NOT NULL,
	EmailTemplateName VARCHAR(250) NOT NULL,
	EmailSubject VARCHAR(2000),
	EmailTemplate VARCHAR(MAX) NOT NULL,
	ClientId UNIQUEIDENTIFIER NOT NULL,
	EmailTemplateReferenceId UNIQUEIDENTIFIER NOT NULL,
	CreatedDateTime DateTime NOT NULL,
	CreatedByUserId UNIQUEIDENTIFIER NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[CompanyId] UNIQUEIDENTIFIER NOT NULL, 
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
CONSTRAINT [PK_EmailTemplates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
