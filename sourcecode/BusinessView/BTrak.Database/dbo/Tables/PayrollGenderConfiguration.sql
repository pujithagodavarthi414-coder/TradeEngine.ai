CREATE   TABLE [dbo].[PayrollGenderConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[GenderId] [uniqueidentifier] NOT NULL,
	[PayrollTemplateId]  [uniqueidentifier] NOT NULL,
	[CompanyId]  [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_PayrollGenderConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[PayrollGenderConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PayrollGenderConfiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollGenderConfiguration] CHECK CONSTRAINT [FK_PayrollGenderConfiguration_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[PayrollGenderConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PayrollGenderConfiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollGenderConfiguration] CHECK CONSTRAINT [FK_PayrollGenderConfiguration_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[PayrollGenderConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollGenderConfiguration_Gender_GenderId] FOREIGN KEY([GenderId])
REFERENCES [dbo].[Gender] ([Id])
GO

ALTER TABLE [dbo].[PayrollGenderConfiguration] CHECK CONSTRAINT [FK_PayrollGenderConfiguration_Gender_GenderId]
GO
ALTER TABLE [dbo].[PayrollGenderConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollGenderConfiguration_PayrollTemplate_PayrollTemplateId] FOREIGN KEY([PayrollTemplateId])
REFERENCES [dbo].[PayrollTemplate] ([Id])
GO

ALTER TABLE [dbo].[PayrollGenderConfiguration] CHECK CONSTRAINT [FK_PayrollGenderConfiguration_PayrollTemplate_PayrollTemplateId]
GO