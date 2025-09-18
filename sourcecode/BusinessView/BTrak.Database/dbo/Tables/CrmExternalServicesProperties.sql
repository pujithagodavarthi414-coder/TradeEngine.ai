CREATE TABLE [dbo].[CrmExternalServicesProperties]
(
	[Id] [uniqueidentifier] NOT NULL,
	[ExternalId] [uniqueidentifier] NOT NULL,
	[Name] nvarchar(250) NULL,
	[Value] nvarchar(max) NULL,
	[CompanyId] [uniqueidentifier] not null,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	CONSTRAINT [PK_CrmExternalServicesProperties] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
)ON [PRIMARY]
GO

ALTER TABLE [dbo].[CrmExternalServicesProperties]  WITH NOCHECK ADD  CONSTRAINT [FK_CrmExternalServicesProperties_CrmExternalServices] FOREIGN KEY([ExternalId])
REFERENCES [dbo].[CrmExternalServices] ([Id])
GO

ALTER TABLE [dbo].[CrmExternalServicesProperties] CHECK CONSTRAINT [FK_CrmExternalServicesProperties_CrmExternalServices]
GO