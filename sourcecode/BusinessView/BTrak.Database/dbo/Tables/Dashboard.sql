CREATE TABLE [dbo].[Dashboard]
(
	[Id] [uniqueidentifier] NOT NULL,
	[WorkspaceId] [uniqueidentifier] NOT NULL,
	[WidgetContent] [nvarchar](MAX) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CompanyId] UNIQUEIDENTIFIER NULL, 
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_Dashboard] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [dbo].[Dashboard]  WITH NOCHECK ADD CONSTRAINT [FK_Workspace_Dashboard_WorkspaceId] FOREIGN KEY ([WorkspaceId])
REFERENCES [dbo].[Workspace] ([Id])
GO

ALTER TABLE [dbo].[Dashboard] CHECK CONSTRAINT [FK_Workspace_Dashboard_WorkspaceId]
GO