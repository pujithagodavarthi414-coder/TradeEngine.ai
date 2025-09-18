CREATE TABLE [dbo].[PeriodType]
(
	[Id] [uniqueidentifier] NOT NULL,
	[PeriodTypeName] [NVARCHAR] (250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL, 
    CONSTRAINT [PK_PeriodType] PRIMARY KEY ([Id]),
)
GO