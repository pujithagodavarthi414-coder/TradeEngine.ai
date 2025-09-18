CREATE TABLE [dbo].[SMSTemplate]
(
	[Id] [uniqueidentifier] NOT NULL,
	[TemplateCode] nvarchar(50),
	[TemplateName] nvarchar(250),
	[Template] nvarchar(MAX),
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	CONSTRAINT [PK_SMSTemplate] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
