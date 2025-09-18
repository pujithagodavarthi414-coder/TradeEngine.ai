CREATE TABLE [dbo].[CustomAppFilter]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [DashboardId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [FilterQuery] NVARCHAR(MAX) NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [UpdatedDateTime] DATETIME NULL,
    CONSTRAINT [PK_CustomAppFilter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[CustomAppFilter]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkspaceDashboards_CustomAppFilter_DashboardId] FOREIGN KEY ([DashboardId])
REFERENCES [dbo].[WorkspaceDashboards] ([Id])
GO

ALTER TABLE [dbo].[CustomAppFilter] CHECK CONSTRAINT [FK_WorkspaceDashboards_CustomAppFilter_DashboardId]
GO

ALTER TABLE [dbo].[CustomAppFilter]  WITH NOCHECK ADD  CONSTRAINT [FK_User_CustomAppFilter_CreatedByUserId] FOREIGN KEY ([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomAppFilter] CHECK CONSTRAINT [FK_User_CustomAppFilter_CreatedByUserId]
GO