CREATE TABLE [dbo].[TaxEducationCess]
(
	[Id] [uniqueidentifier] NOT NULL,
	[EducationCessPercentage] FLOAT NOT NULL,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL, 
    CONSTRAINT [PK_TaxEducationCess] PRIMARY KEY ([Id]),
)
