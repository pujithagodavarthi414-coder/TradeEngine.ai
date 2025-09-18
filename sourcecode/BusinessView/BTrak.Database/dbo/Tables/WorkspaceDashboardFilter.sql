CREATE TABLE [dbo].[WorkspaceDashboardFilter]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[WorkspaceDashboardId] UNIQUEIDENTIFIER NOT NULL,
	[FilterJson] NVARCHAR(MAX) NULL,
	[IsCalenderView] BIT NOT NULL DEFAULT 0,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL
CONSTRAINT [PK_WorkspaceDashboardFilter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--ALTER TABLE [dbo].[WorkspaceDashboardFilter] ADD  CONSTRAINT [FK_WorkspaceDashboards_WorkspaceDashboardFilter_WorkspaceDashboardId] FOREIGN KEY([WorkspaceDashboardId])
--REFERENCES [dbo].[WorkspaceDashboards] ([Id])
--GO

ALTER TABLE [dbo].[WorkspaceDashboardFilter] ADD  CONSTRAINT [FK_User_WorkspaceDashboardFilter_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[WorkspaceDashboardFilter] ADD  CONSTRAINT [FK_User_WorkspaceDashboardFilter_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO