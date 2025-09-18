CREATE TABLE [dbo].[ProjectFeatureResponsiblePerson]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [ProjectFeatureId] UNIQUEIDENTIFIER NOT NULL, 
    [UserId] UNIQUEIDENTIFIER NULL, 
    [IsDelete] BIT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIMEOFFSET NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIMEOFFSET NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
	CONSTRAINT [PK_ProjectFeatureResponsiblePerson] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

) 
GO

ALTER TABLE [dbo].[ProjectFeatureResponsiblePerson]  WITH CHECK ADD  CONSTRAINT [FK_ProjectFeatureResponsiblePerson_ProjectFeature] FOREIGN KEY([ProjectFeatureId])
REFERENCES [dbo].[ProjectFeature] ([Id])
GO

ALTER TABLE [dbo].[ProjectFeatureResponsiblePerson] CHECK CONSTRAINT [FK_ProjectFeatureResponsiblePerson_ProjectFeature]
GO

ALTER TABLE [dbo].[ProjectFeatureResponsiblePerson]  WITH CHECK ADD  CONSTRAINT [FK_ProjectFeatureResponsiblePerson_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ProjectFeatureResponsiblePerson] CHECK CONSTRAINT [FK_ProjectFeatureResponsiblePerson_User]
GO