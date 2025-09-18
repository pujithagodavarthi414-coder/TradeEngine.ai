CREATE TABLE [dbo].[LoanFrequency]
(
	[Id] [uniqueidentifier] NOT NULL,
	[LoanFrequencyName] [NVARCHAR] (250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL, 
    CONSTRAINT [PK_LoanFrequency] PRIMARY KEY ([Id]),
)
GO