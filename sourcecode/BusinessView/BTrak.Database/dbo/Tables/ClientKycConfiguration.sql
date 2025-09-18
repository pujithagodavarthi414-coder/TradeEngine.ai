CREATE TABLE [dbo].[ClientKycConfiguration]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [Name] NVARCHAR(250) NOT NULL, 
	[SelectedRoles] NVARCHAR(MAX) NULL,
	[SelectedLegalEntities] NVARCHAR(MAX) NULL,
	[IsDraft] BIT NOT NULL,
    [FormJson] NVARCHAR(MAX) NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDatetime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDatetime] DATETIME NULL,
	[InActiveDatetime] DATETIME NULL, 
	[TimeStamp] TimeStamp NOT NULL,
    [ClientTypeId] UNIQUEIDENTIFIER NULL, 
    [LegalEntityTypeId] UNIQUEIDENTIFIER NULL, 
    [FormBgColor] NVARCHAR(150) NULL, 
    CONSTRAINT [PK_ClientKycConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClientKycConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_ClientKycConfiguration_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ClientKycConfiguration] CHECK CONSTRAINT [FK_ClientKycConfiguration_User]
GO

ALTER TABLE [dbo].[ClientKycConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_ClientKycConfiguration_User2] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ClientKycConfiguration] CHECK CONSTRAINT [FK_ClientKycConfiguration_User2]
GO

ALTER TABLE [dbo].[ClientKycConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_ClientKycConfiguration_Client] FOREIGN KEY([ClientTypeId])
REFERENCES [dbo].[ClientType] ([Id])
GO

ALTER TABLE [dbo].[ClientKycConfiguration] CHECK CONSTRAINT [FK_ClientKycConfiguration_Client]
GO