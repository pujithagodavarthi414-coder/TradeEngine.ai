CREATE TABLE [dbo].[WorkspaceFilter]
(
	Id UNIQUEIDENTIFIER NOT NULL,
	WorkspaceParameterId UNIQUEIDENTIFIER NOT NULL,
	FilterValue NVARCHAR(500) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
CONSTRAINT [PK_WorkspaceFilter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
))
GO

ALTER TABLE [dbo].[WorkspaceFilter] ADD CONSTRAINT [FK_WorkspaceParameter_WorkspaceFilter_WorkspaceParameterId] FOREIGN KEY ([WorkspaceParameterId])
REFERENCES [dbo].[WorkspaceParameter] ([Id])
GO

ALTER TABLE [dbo].[WorkspaceFilter] ADD CONSTRAINT [FK_User_WorkspaceFilter_CreatedByUserId] FOREIGN KEY ([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO