CREATE TABLE [dbo].[Widget]
(
	[Id] [uniqueidentifier] NOT NULL,
	[WidgetName] [nvarchar](250)  NULL,
	[Description] [nvarchar] (1000) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CompanyId] UNIQUEIDENTIFIER NULL, 
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_Widget] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

CREATE NONCLUSTERED INDEX [IX_WidgetRoleConfiguration_WidgetId_InActiveDateTime]
ON [dbo].[WidgetRoleConfiguration] ([WidgetId],[InActiveDateTime])
GO

CREATE NONCLUSTERED INDEX [IX_Widget_CompanyId]
ON [dbo].[Widget] ([CompanyId])
INCLUDE ([Id],[WidgetName],[Description],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime],[TimeStamp])
GO

CREATE NONCLUSTERED INDEX [IX_WidgetRoleConfiguration_InActiveDateTime]
ON [dbo].[WidgetRoleConfiguration] ([InActiveDateTime])
INCLUDE ([WidgetId],[RoleId])
GO

ALTER TABLE [dbo].[Widget] 
ADD CONSTRAINT UK_Widget_WidgetName_CompanyId UNIQUE ([WidgetName], [CompanyId])
GO

CREATE NONCLUSTERED INDEX [IX_Widget_InActiveDateTime_Id]
ON [dbo].[Widget] ([InActiveDateTime])
INCLUDE ([Id])
GO