CREATE TABLE [dbo].[CustomAppDashboardPersistance](
	[Id] [uniqueidentifier] NOT NULL,
	[DashboardId] [uniqueidentifier] NOT NULL,
	[DashboardIdToNavigate] [uniqueidentifier] NULL,
	[CustomApplicationId] [uniqueidentifier] NOT NULL,
	[CustomFormId] [uniqueidentifier] NOT NULL,
	[QueryToFilter] NVARCHAR(MAX) NULL, 
	[IsDefault] BIT,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedDateTime] DATETIME NULL,
    CONSTRAINT [PK_CustomAppDashboardPersistance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomAppDashboardPersistance]  WITH CHECK ADD  CONSTRAINT [FK_CustomAppDashboardPersistance_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomAppDashboardPersistance] CHECK CONSTRAINT [FK_CustomAppDashboardPersistance_User]
GO

ALTER TABLE [dbo].[CustomAppDashboardPersistance]  WITH CHECK ADD  CONSTRAINT [FK_CustomAppDashboardPersistance_WorkspaceDashboards] FOREIGN KEY([DashboardId])
REFERENCES [dbo].[WorkspaceDashboards] ([Id])
GO

ALTER TABLE [dbo].[CustomAppDashboardPersistance] CHECK CONSTRAINT [FK_CustomAppDashboardPersistance_WorkspaceDashboards]
GO


