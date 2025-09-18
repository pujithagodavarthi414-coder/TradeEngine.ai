CREATE TABLE [dbo].[ClientTemplateConfiguration]
(
	[Id] [uniqueidentifier] NOT NULL,	
	[TemplateConfigurationName] [nvarchar](250) NOT NULL,
	[TemplateConfiguration] [nvarchar](MAX) NOT NULL,
	[LegalEntityId] [uniqueidentifier] NULL,
	[ClientTypeId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InactiveDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP
	CONSTRAINT [PK_ClientTemplateConfiguration] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    [ContractTypeIds] NVARCHAR(MAX) NULL, 
)
GO