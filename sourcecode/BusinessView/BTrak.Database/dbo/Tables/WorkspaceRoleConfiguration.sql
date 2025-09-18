CREATE TABLE [dbo].[WorkspaceRoleConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[WorkspaceId] [uniqueidentifier] NULL,
	[RoleId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NULL,
 CONSTRAINT [PK_WorkspaceRoleConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[WorkspaceRoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WorkspaceRoleConfiguration_Role] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

ALTER TABLE [dbo].[WorkspaceRoleConfiguration] CHECK CONSTRAINT [FK_WorkspaceRoleConfiguration_Role]
GO

ALTER TABLE [dbo].[WorkspaceRoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WorkspaceRoleConfiguration_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[WorkspaceRoleConfiguration] CHECK CONSTRAINT [FK_WorkspaceRoleConfiguration_User]
GO

ALTER TABLE [dbo].[WorkspaceRoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WorkspaceRoleConfiguration_Workspace] FOREIGN KEY([WorkspaceId])
REFERENCES [dbo].[Workspace] ([Id])
GO

ALTER TABLE [dbo].[WorkspaceRoleConfiguration] CHECK CONSTRAINT [FK_WorkspaceRoleConfiguration_Workspace]
GO