CREATE TABLE [dbo].[WidgetModuleConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[WidgetId] [uniqueidentifier] NULL,
	[ModuleId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] [timestamp] NULL,
 CONSTRAINT [PK_WidgetModuleConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[WidgetModuleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_WidgetModuleConfiguration_Module] FOREIGN KEY([ModuleId])
REFERENCES [dbo].[Module] ([Id])
GO

ALTER TABLE [dbo].[WidgetModuleConfiguration] CHECK CONSTRAINT [FK_WidgetModuleConfiguration_Module]
GO