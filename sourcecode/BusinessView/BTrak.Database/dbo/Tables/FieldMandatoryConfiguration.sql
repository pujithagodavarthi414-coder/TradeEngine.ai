CREATE TABLE [dbo].[FieldMandatoryConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[FieldId] [uniqueidentifier] NULL,
	[ConfigurationTypeId] [uniqueidentifier] NULL,
	[IsMandatory] [bit] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_FieldMandatoryConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_FieldMandatoryConfiguration_FieldId_ConfigurationTypeId] UNIQUE ([FieldId],[ConfigurationTypeId])
)

GO

--ALTER TABLE [dbo].[FieldMandatoryConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_FieldMandatoryConfiguration_ConfigurationType] FOREIGN KEY([ConfigurationTypeId])
--REFERENCES [dbo].[ConfigurationType] ([Id])
--GO

--ALTER TABLE [dbo].[FieldMandatoryConfiguration] CHECK CONSTRAINT [FK_FieldMandatoryConfiguration_ConfigurationType]
--GO

ALTER TABLE [dbo].[FieldMandatoryConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_FieldMandatoryConfiguration_Field] FOREIGN KEY([FieldId])
REFERENCES [dbo].[Field] ([Id])
GO

ALTER TABLE [dbo].[FieldMandatoryConfiguration] CHECK CONSTRAINT [FK_FieldMandatoryConfiguration_Field]
GO