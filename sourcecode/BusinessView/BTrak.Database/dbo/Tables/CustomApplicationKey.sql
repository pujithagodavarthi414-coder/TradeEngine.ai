CREATE TABLE CustomApplicationKey
(
	Id UNIQUEIDENTIFIER NOT NULL,
	CustomApplicationId UNIQUEIDENTIFIER NOT NULL,
	GenericFormKeyId UNIQUEIDENTIFIER NOT NULL,
	GenericFormId UNIQUEIDENTIFIER NULL,
	IsDefault BIT DEFAULT 0 NOT NULL,
	IsPrivate BIT DEFAULT 0 NOT NULL,
	IsTag BIT DEFAULT 0 NOT NULL,
	IsTrendsEnable BIT DEFAULT 0 NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	InActiveDateTime DATETIME NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TimeStamp NOT NULL
CONSTRAINT [PK_CustomApplicationKey] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomApplicationKey]  WITH NOCHECK ADD  CONSTRAINT [FK_CustomApplication_GenericFormKey_GenericFormKeyId] FOREIGN KEY([GenericFormKeyId])
REFERENCES [dbo].[GenericFormKey] ([Id])
GO

ALTER TABLE [dbo].[CustomApplicationKey] CHECK CONSTRAINT [FK_CustomApplication_GenericFormKey_GenericFormKeyId]
GO

ALTER TABLE [dbo].[CustomApplicationKey]  WITH NOCHECK ADD  CONSTRAINT [FK_User_CustomApplicationKey_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomApplicationKey] CHECK CONSTRAINT [FK_User_CustomApplicationKey_CreatedByUserId]
GO

CREATE NONCLUSTERED INDEX IX_CustomApplicationKey_CustomApplicationId_IsTag_InActiveDateTime
ON [dbo].[CustomApplicationKey] ([CustomApplicationId],[IsTag],[InActiveDateTime])
INCLUDE ([GenericFormKeyId])
GO

CREATE NONCLUSTERED INDEX IX_CustomApplicationKey_CustomApplicationId_IsPrivate_InActiveDateTime
ON [dbo].[CustomApplicationKey] ([CustomApplicationId],[IsPrivate],[InActiveDateTime])
INCLUDE ([GenericFormKeyId])
GO