CREATE TABLE [dbo].[DashboardPersistance](
	[Id] [uniqueidentifier] NOT NULL,
	[DashboardId] [uniqueidentifier] NOT NULL,
	[X] [int] NOT NULL,
	[Y] [int] NOT NULL,
	[Col] [int] NOT NULL,
	[Row] [int] NOT NULL,
	[MinItemCols] [int] NOT NULL,
	[MinItemRows] [int] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
 CONSTRAINT [PK_DashboardPersistance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DashboardPersistance]  WITH CHECK ADD  CONSTRAINT [FK_DashboardPersistance_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[DashboardPersistance] CHECK CONSTRAINT [FK_DashboardPersistance_User]
GO

ALTER TABLE [dbo].[DashboardPersistance]  WITH CHECK ADD  CONSTRAINT [FK_DashboardPersistance_WorkspaceDashboards] FOREIGN KEY([DashboardId])
REFERENCES [dbo].[WorkspaceDashboards] ([Id])
GO

ALTER TABLE [dbo].[DashboardPersistance] CHECK CONSTRAINT [FK_DashboardPersistance_WorkspaceDashboards]
GO

ALTER TABLE [dbo].[DashboardPersistance] 
ADD CONSTRAINT UK_DashboardPersistance_DashboardId_CreatedByUserId UNIQUE (DashboardId, CreatedByUserId)
GO