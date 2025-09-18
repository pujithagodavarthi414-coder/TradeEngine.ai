CREATE TABLE [dbo].[CustomFieldsMapping](
	[Id] [uniqueidentifier] NOT NULL,
	[CustomApplicationId] [uniqueidentifier] NOT NULL,
	[MappingName] [nvarchar](500) NOT NULL,
	[MappingJson] [nvarchar](max) NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] DATETIME NULL,
    [TimeStamp] TIMESTAMP NOT NULL, 
    CONSTRAINT [PK_CustomFieldsMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomFieldsMapping]  WITH CHECK ADD  CONSTRAINT [FK_CustomFieldsMapping_CustomApplication] FOREIGN KEY([CustomApplicationId])
REFERENCES [dbo].[CustomApplication] ([Id])
GO

ALTER TABLE [dbo].[CustomFieldsMapping] CHECK CONSTRAINT [FK_CustomFieldsMapping_CustomApplication]
GO

ALTER TABLE [dbo].[CustomFieldsMapping]  WITH CHECK ADD  CONSTRAINT [FK_CustomFieldsMapping_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomFieldsMapping] CHECK CONSTRAINT [FK_CustomFieldsMapping_User]
GO

ALTER TABLE [dbo].[CustomFieldsMapping]  WITH CHECK ADD  CONSTRAINT [FK_CustomFieldsMapping_User1] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomFieldsMapping] CHECK CONSTRAINT [FK_CustomFieldsMapping_User1]
GO