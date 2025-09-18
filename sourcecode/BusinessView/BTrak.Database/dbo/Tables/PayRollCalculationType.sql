CREATE TABLE [dbo].[PayRollCalculationType]
(
	[Id] [uniqueidentifier] NOT NULL,
	[PayRollCalculationTypeName] [NVARCHAR] (250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL, 
    CONSTRAINT [PK_PayRollCalculationType] PRIMARY KEY ([Id]),
)
