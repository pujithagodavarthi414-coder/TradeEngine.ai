CREATE TABLE [dbo].[PartsOfDay]
(
	[Id] [uniqueidentifier] NOT NULL,
	[PartsOfDayName] [NVARCHAR] (250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL, 
    CONSTRAINT [PK_PartsOfDay] PRIMARY KEY ([Id]),
)
GO