CREATE TABLE [dbo].[PayRollMaritalStatusConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[MaritalStatusId] [uniqueidentifier] NOT NULL,
	[PayrollTemplateId]  [uniqueidentifier] NOT NULL,
	[CompanyId]  [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_PayRollMaritalStatusConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[PayRollMaritalStatusConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PayRollMaritalStatusConfiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayRollMaritalStatusConfiguration] CHECK CONSTRAINT [FK_PayRollMaritalStatusConfiguration_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[PayRollMaritalStatusConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PayRollMaritalStatusConfiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayRollMaritalStatusConfiguration] CHECK CONSTRAINT [FK_PayRollMaritalStatusConfiguration_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[PayRollMaritalStatusConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_PayRollMaritalStatusConfiguration_MaritalStatus_MaritalStatusId] FOREIGN KEY([MaritalStatusId])
REFERENCES [dbo].[MaritalStatus] ([Id])
GO

ALTER TABLE [dbo].[PayRollMaritalStatusConfiguration] CHECK CONSTRAINT [FK_PayRollMaritalStatusConfiguration_MaritalStatus_MaritalStatusId]
GO
ALTER TABLE [dbo].[PayRollMaritalStatusConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_PayRollMaritalStatusConfiguration_PayrollTemplate_PayrollTemplateId] FOREIGN KEY([PayrollTemplateId])
REFERENCES [dbo].[PayrollTemplate] ([Id])
GO

ALTER TABLE [dbo].[PayRollMaritalStatusConfiguration] CHECK CONSTRAINT [FK_PayRollMaritalStatusConfiguration_PayrollTemplate_PayrollTemplateId]
GO