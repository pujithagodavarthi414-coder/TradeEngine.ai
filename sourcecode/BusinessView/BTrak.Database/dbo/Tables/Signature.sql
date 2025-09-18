CREATE TABLE [dbo].[Signature]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [ReferenceId] UNIQUEIDENTIFIER NOT NULL, 
    [SignatureUrl] NVARCHAR(600) NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [InviteeId] UNIQUEIDENTIFIER NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL,
    [InActiveDateTime] DATETIME NULL, 
    CONSTRAINT [PK_Signature] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[Signature]  WITH CHECK ADD  CONSTRAINT [FK_Signature_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[Signature] CHECK CONSTRAINT [FK_Signature_Company]
GO

ALTER TABLE [dbo].[Signature]  WITH CHECK ADD  CONSTRAINT [FK_Signature_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Signature] CHECK CONSTRAINT [FK_Signature_User]
GO

ALTER TABLE [dbo].[Signature]  WITH CHECK ADD  CONSTRAINT [FK_Signature_User1] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Signature] CHECK CONSTRAINT [FK_Signature_User1]
GO