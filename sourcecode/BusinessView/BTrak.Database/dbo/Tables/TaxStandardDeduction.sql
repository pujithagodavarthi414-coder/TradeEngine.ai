CREATE TABLE [dbo].[TaxStandardDeduction]
(
	[Id] [uniqueidentifier] NOT NULL,
	[StandardDeduction] FLOAT NOT NULL,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL, 
    CONSTRAINT [PK_TaxStandardDeduction] PRIMARY KEY ([Id]),
)
