CREATE TABLE [dbo].[FinancialYearType]
(
	[Id] [uniqueidentifier] NOT NULL,
	[FinancialYearTypeName] [NVARCHAR] (250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL, 
    CONSTRAINT [PK_FinancialYearType] PRIMARY KEY ([Id]),
)
GO