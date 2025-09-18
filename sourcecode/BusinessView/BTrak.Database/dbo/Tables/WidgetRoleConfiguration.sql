CREATE TABLE [dbo].[WidgetRoleConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[WidgetId] [uniqueidentifier] NULL,
	[RoleId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] [timestamp] NULL,
 CONSTRAINT [PK_WidgetRoleConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WidgetRoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WidgetRoleConfiguration_Role] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

ALTER TABLE [dbo].[WidgetRoleConfiguration] CHECK CONSTRAINT [FK_WidgetRoleConfiguration_Role]
GO

ALTER TABLE [dbo].[WidgetRoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WidgetRoleConfiguration_User] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[WidgetRoleConfiguration] CHECK CONSTRAINT [FK_WidgetRoleConfiguration_User]
GO


ALTER TABLE [dbo].[WidgetRoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WidgetRoleConfiguration_WidgetRoleConfiguration] FOREIGN KEY([WidgetId])
REFERENCES [dbo].[Widget] ([Id])
GO

ALTER TABLE [dbo].[WidgetRoleConfiguration] CHECK CONSTRAINT [FK_WidgetRoleConfiguration_WidgetRoleConfiguration]
GO