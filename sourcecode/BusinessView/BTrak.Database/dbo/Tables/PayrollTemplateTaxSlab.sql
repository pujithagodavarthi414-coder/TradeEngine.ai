CREATE TABLE [dbo].[PayrollTemplateTaxSlab](
	[Id] [uniqueidentifier] NOT NULL,
	[PayrollTemplateId]  [uniqueidentifier] NOT NULL,
	[TaxSlabId]  [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_PayrollTemplateTaxSlab] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].PayrollTemplateTaxSlab  WITH NOCHECK ADD CONSTRAINT [FK_PayrollTemplateTaxSlab_PayrollTemplate_PayrollTemplateId] FOREIGN KEY([PayrollTemplateId])
REFERENCES [dbo].[PayrollTemplate] ([Id])
GO

ALTER TABLE [dbo].PayrollTemplateTaxSlab CHECK CONSTRAINT [FK_PayrollTemplateTaxSlab_PayrollTemplate_PayrollTemplateId]
GO

ALTER TABLE [dbo].PayrollTemplateTaxSlab  WITH NOCHECK ADD CONSTRAINT [FK_PayrollTemplateTaxSlab_TaxSlabs_TaxSlabId] FOREIGN KEY([TaxSlabId])
REFERENCES [dbo].[TaxSlabs] ([Id])
GO

ALTER TABLE [dbo].PayrollTemplateTaxSlab CHECK CONSTRAINT [FK_PayrollTemplateTaxSlab_TaxSlabs_TaxSlabId]
GO


ALTER TABLE [dbo].PayrollTemplateTaxSlab  WITH CHECK ADD  CONSTRAINT [FK_PayrollTemplateTaxSlab_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].PayrollTemplateTaxSlab CHECK CONSTRAINT [FK_PayrollTemplateTaxSlab_User_CreatedByUserId]
GO
ALTER TABLE [dbo].PayrollTemplateTaxSlab  WITH CHECK ADD  CONSTRAINT [FK_PayrollTemplateTaxSlab_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].PayrollTemplateTaxSlab CHECK CONSTRAINT [FK_PayrollTemplateTaxSlab_User_UpdatedByUserId]
GO

