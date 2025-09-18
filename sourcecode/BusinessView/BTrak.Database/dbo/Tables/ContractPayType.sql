CREATE TABLE [dbo].[ContractPayType]
(
	[Id] [uniqueidentifier] NOT NULL,
	[ContractPayTypeName] [NVARCHAR] (250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL, 
    CONSTRAINT [PK_ContractPayType] PRIMARY KEY ([Id]),
)
GO