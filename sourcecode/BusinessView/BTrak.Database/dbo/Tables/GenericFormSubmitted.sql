CREATE TABLE GenericFormSubmitted
(
	Id UNIQUEIDENTIFIER NOT NULL,
	CustomApplicationId UNIQUEIDENTIFIER NULL,
	DataSetId UNIQUEIDENTIFIER NULL,
	DataSourceId UNIQUEIDENTIFIER NULL,
	FormJson NVARCHAR(MAX) NOT NULL,
	UniqueNumber NVARCHAR(250) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[FormId] [uniqueidentifier] NULL,
	[IsApproved] BIT NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	InActiveDateTime DATETIME NULL,
	[TimeStamp] TimeStamp NOT NULL
CONSTRAINT [PK_GenericFormSubmitted] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO


GO

CREATE NONCLUSTERED INDEX [IX_GenericFormSubmitted_FormId]
ON [dbo].[GenericFormSubmitted] ([FormId])
INCLUDE ([CustomApplicationId],[FormJson])
GO