CREATE TABLE [dbo].[ClientProjects](
	[Id] [uniqueidentifier] NOT NULL,
	[ClientId] [uniqueidentifier] NOT NULL,
	[ProjectId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_ClientProjects] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClientProjects] WITH CHECK ADD CONSTRAINT [FK_Client_ClientProjects_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([Id])
GO

ALTER TABLE [dbo].[ClientProjects] CHECK CONSTRAINT [FK_Client_ClientProjects_ClientId]
GO

ALTER TABLE [dbo].[ClientProjects] WITH CHECK ADD CONSTRAINT [FK_Project_ClientProjects_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO

ALTER TABLE [dbo].[ClientProjects] CHECK CONSTRAINT [FK_Project_ClientProjects_ProjectId]
GO
