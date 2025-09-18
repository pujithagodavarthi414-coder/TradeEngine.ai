CREATE TABLE GenericFormKey
(
	Id UNIQUEIDENTIFIER NOT NULL,
	GenericFormId UNIQUEIDENTIFIER NOT NULL,
	[Key] NVARCHAR(250),
	[Label] NVARCHAR(500) NULL,
	IsDefault BIT NOT NULL DEFAULT 0,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	InActiveDateTime DATETIME NULL,
	[TimeStamp] TimeStamp NOT NULL,
	[DataType] NVARCHAR(MAX) NULL
CONSTRAINT [PK_GenericFormKey] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[GenericFormKey]  WITH NOCHECK ADD  CONSTRAINT [FK_GenericForm_GenericFormKey_GenericFormId] FOREIGN KEY([GenericFormId])
REFERENCES [dbo].[GenericForm] ([Id])
GO

ALTER TABLE [dbo].[GenericFormKey] CHECK CONSTRAINT [FK_GenericForm_GenericFormKey_GenericFormId]
GO


CREATE NONCLUSTERED INDEX IX_GenericFormKey_InActiveDateTime
ON [dbo].[GenericFormKey] ([InActiveDateTime])
INCLUDE ([Id],[GenericFormId],[Key],[Label],[IsDefault],[CreatedDateTime],[CreatedByUserId])
GO
