CREATE TABLE [dbo].[LoanType]
(
	[Id] [uniqueidentifier] NOT NULL,
	[LoanTypeName] [NVARCHAR] (250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL, 
    CONSTRAINT [PK_LoanType] PRIMARY KEY ([Id]),
)
GO