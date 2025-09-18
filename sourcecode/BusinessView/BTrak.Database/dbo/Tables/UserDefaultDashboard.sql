CREATE TABLE [dbo].[UserDefaultDashboard](
    [Id] [uniqueidentifier] NOT NULL,
    [DashboardId] [uniqueidentifier] NOT NULL,
	[IsDefault] BIT NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [UpdatedDateTime] [datetime] NULL,
 CONSTRAINT [PK_UserDefaultDashboard] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserDefaultDashboard]  WITH CHECK ADD  CONSTRAINT [FK_UserDefaultDashboard_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[UserDefaultDashboard] CHECK CONSTRAINT [FK_UserDefaultDashboard_User]
GO
ALTER TABLE [dbo].[UserDefaultDashboard]  WITH CHECK ADD  CONSTRAINT [FK_UserDefaultDashboard_Workspace] FOREIGN KEY([DashboardId])
REFERENCES [dbo].[Workspace] ([Id])
GO
ALTER TABLE [dbo].[UserDefaultDashboard] CHECK CONSTRAINT [FK_UserDefaultDashboard_Workspace]
GO