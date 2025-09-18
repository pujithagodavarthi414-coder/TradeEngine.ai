CREATE TABLE [dbo].[TaxAllowanceType]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[TaxAllowanceTypeName] NVARCHAR(250) NOT NULL, 
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL
    CONSTRAINT [PK_TaxAllowanceType] PRIMARY KEY ([Id])
)
