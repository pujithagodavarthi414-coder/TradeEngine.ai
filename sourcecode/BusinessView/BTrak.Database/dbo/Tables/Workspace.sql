CREATE TABLE [dbo].[Workspace](
	[Id] [uniqueidentifier] NOT NULL,
	[WorkspaceName] [nvarchar](250) NULL,
	[Description] [nvarchar](500) NULL,
	[IsHidden] [bit] NULL,
	[IsCustomizedFor] [nvarchar](250) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp],
	[IsListView] [bit] NULL,
	[MenuItemId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Workspace] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IDX_DashboardConfiguration_DashboardId]
ON [dbo].[DashboardConfiguration] ([DashboardId])
INCLUDE ([DefaultDashboardRoles],[ViewRoles],[EditRoles],[DeleteRoles])
GO

CREATE NONCLUSTERED INDEX [IDX_Workspace_IsCustomizedFor_CompanyId]
ON [dbo].[Workspace] ([IsCustomizedFor],[CompanyId])
GO

CREATE NONCLUSTERED INDEX [IX_WorkspaceDashboards_WorkspaceId_CreatedByUserId]
ON [dbo].[WorkspaceDashboards] ([WorkspaceId],[CreatedByUserId],[IsDraft])
GO