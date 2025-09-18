CREATE TABLE [dbo].[CustomWidgetRoleConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[CustomWidgetId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InActiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_CustomWidgetRoleConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomWidgetRoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgetRoleConfiguration_CustomWidgets] FOREIGN KEY([CustomWidgetId])
REFERENCES [dbo].[CustomWidgets] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgetRoleConfiguration] CHECK CONSTRAINT [FK_CustomWidgetRoleConfiguration_CustomWidgets]
GO

ALTER TABLE [dbo].[CustomWidgetRoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgetRoleConfiguration_Role] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgetRoleConfiguration] CHECK CONSTRAINT [FK_CustomWidgetRoleConfiguration_Role]
GO

ALTER TABLE [dbo].[CustomWidgetRoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgetRoleConfiguration_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgetRoleConfiguration] CHECK CONSTRAINT [FK_CustomWidgetRoleConfiguration_User]
GO

ALTER TABLE [dbo].[CustomWidgetRoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgetRoleConfiguration_User1] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomWidgetRoleConfiguration] CHECK CONSTRAINT [FK_CustomWidgetRoleConfiguration_User1]
GO

CREATE NONCLUSTERED INDEX [IX_CustomWidgetRoleConfiguration_RoleId_InActiveDateTime]
ON [dbo].[CustomWidgetRoleConfiguration] ([RoleId],[InActiveDateTime])
INCLUDE ([CustomWidgetId])
GO


