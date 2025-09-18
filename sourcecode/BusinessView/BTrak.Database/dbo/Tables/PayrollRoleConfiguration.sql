CREATE   TABLE [dbo].[PayrollRoleConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[PayrollTemplateId]  [uniqueidentifier] NOT NULL,
	[CompanyId]  [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_PayrollRoleConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[PayrollRoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PayrollRoleConfiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollRoleConfiguration] CHECK CONSTRAINT [FK_PayrollRoleConfiguration_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[PayrollRoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PayrollRoleConfiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollRoleConfiguration] CHECK CONSTRAINT [FK_PayrollRoleConfiguration_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[PayrollRoleConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollRoleConfiguration_Role_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

ALTER TABLE [dbo].[PayrollRoleConfiguration] CHECK CONSTRAINT [FK_PayrollRoleConfiguration_Role_RoleId]
GO
ALTER TABLE [dbo].[PayrollRoleConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollRoleConfiguration_PayrollTemplate_PayrollTemplateId] FOREIGN KEY([PayrollTemplateId])
REFERENCES [dbo].[PayrollTemplate] ([Id])
GO

ALTER TABLE [dbo].[PayrollRoleConfiguration] CHECK CONSTRAINT [FK_PayrollRoleConfiguration_PayrollTemplate_PayrollTemplateId]
GO
