CREATE TABLE [dbo].[PayrollTemplateConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[PayrollComponentId] [uniqueidentifier] NOT NULL,
	[PayrollTemplateId] [uniqueidentifier] NOT NULL,
	[Ispercentage] [bit] NULL DEFAULT 1,
	[Amount] [decimal](18, 4) NULL,
	[Percentagevalue] [decimal](18, 4) NULL,
	[IsCtcDependent] [bit] NULL DEFAULT 1,
	[DependentPayrollComponentId] [uniqueidentifier] NULL,
	[IsRelatedToPT] [bit] NULL,
	[ComponentId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[Order] INT NULL,
	[IsBands] [bit] NULL
    CONSTRAINT [PK_PayrollTemplateConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[PayrollTemplateConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollTemplateConfiguration_PayrollComponent_PayrollComponentId] FOREIGN KEY([PayrollComponentId])
REFERENCES [dbo].[PayrollComponent] ([Id])
GO

ALTER TABLE [dbo].[PayrollTemplateConfiguration] CHECK CONSTRAINT [FK_PayrollTemplateConfiguration_PayrollComponent_PayrollComponentId]
GO

ALTER TABLE [dbo].[PayrollTemplateConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollTemplateConfiguration_PayrollComponent_DependentPayrollComponentId] FOREIGN KEY([PayrollComponentId])
REFERENCES [dbo].[PayrollComponent] ([Id])
GO

ALTER TABLE [dbo].[PayrollTemplateConfiguration] CHECK CONSTRAINT [FK_PayrollTemplateConfiguration_PayrollComponent_DependentPayrollComponentId]
GO

ALTER TABLE [dbo].[PayrollTemplateConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollTemplateConfiguration_PayrollTemplate_PayrollTemplateId] FOREIGN KEY([PayrollTemplateId])
REFERENCES [dbo].[PayrollTemplate] ([Id])
GO

ALTER TABLE [dbo].[PayrollTemplateConfiguration] CHECK CONSTRAINT [FK_PayrollTemplateConfiguration_PayrollTemplate_PayrollTemplateId]
GO
ALTER TABLE [dbo].[PayrollTemplateConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PayrollTemplateConfiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollTemplateConfiguration] CHECK CONSTRAINT [FK_PayrollTemplateConfiguration_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[PayrollTemplateConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PayrollTemplateConfiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollTemplateConfiguration] CHECK CONSTRAINT [FK_PayrollTemplateConfiguration_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[PayrollTemplateConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollTemplateConfiguration_Component_ComponentId] FOREIGN KEY([ComponentId])
REFERENCES [dbo].[Component] ([Id])
GO
ALTER TABLE [dbo].[PayrollTemplateConfiguration] CHECK CONSTRAINT [FK_PayrollTemplateConfiguration_Component_ComponentId]
GO