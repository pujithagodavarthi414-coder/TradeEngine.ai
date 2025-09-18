CREATE TABLE [dbo].[DashboardCustomViewOrder](
	[Id] [uniqueidentifier] NOT NULL,
	[WorkspaceId] [uniqueidentifier] NOT NULL,
	[DashboardId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[Order] [int] NOT NULL,
	[CreatedDateTime] [datetimeoffset](7) NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetimeoffset](7) NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_DashboardCustomViewOrder] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DashboardCustomViewOrder]  WITH CHECK ADD  CONSTRAINT [FK_WorkSpace_DashboardView_WorkspaceId] FOREIGN KEY([WorkspaceId])
REFERENCES [dbo].[Workspace] ([Id])
GO

ALTER TABLE [dbo].[DashboardCustomViewOrder] CHECK CONSTRAINT [FK_WorkSpace_DashboardView_WorkspaceId]
GO

ALTER TABLE [dbo].[DashboardCustomViewOrder]  WITH CHECK ADD  CONSTRAINT [FK_User_DashboardView_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[DashboardCustomViewOrder] CHECK CONSTRAINT [FK_User_DashboardView_UserId]
GO