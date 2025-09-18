CREATE TABLE [dbo].[WorkspaceDashboards](
	[Id] [uniqueidentifier] NOT NULL,
	[WorkspaceId] [uniqueidentifier] NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[Col] [int] NULL,
	[Row] [int] NULL,
	[MinItemCols] [int] NULL,
	[MinItemRows] [int] NULL,
	[Name] [nvarchar](600) NOT NULL,
	[Component] [nvarchar](1000) NULL,
	[PersistanceJson] [nvarchar](max) NULL,
	[CustomWidgetId] [uniqueidentifier] NULL,
	[IsCustomWidget] [bit] NULL,
	[InActiveDateTime] DATETIME NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CustomAppVisualizationId] UNIQUEIDENTIFIER NULL, 
    [DashboardName] NVARCHAR(600) NULL,
	[ExtraVariableJson] NVARCHAR(max) NULL,
	[Order] INT NULL,
    [IsDraft] BIT NULL, 
    CONSTRAINT [PK_WorkspaceDashboards] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[WorkspaceDashboards]  WITH CHECK ADD  CONSTRAINT [FK_WorkspaceDashboards_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[WorkspaceDashboards] CHECK CONSTRAINT [FK_WorkspaceDashboards_User]
GO

ALTER TABLE [dbo].[WorkspaceDashboards]  WITH CHECK ADD  CONSTRAINT [FK_WorkspaceDashboards_User1] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[WorkspaceDashboards] CHECK CONSTRAINT [FK_WorkspaceDashboards_User1]
GO


