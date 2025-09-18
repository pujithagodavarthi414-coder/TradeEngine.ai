CREATE TABLE [dbo].[UserProject](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ProjectId] [uniqueidentifier] NOT NULL,
	[GoalId] [uniqueidentifier] NULL,
	[EntityRoleId] [uniqueidentifier] NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZoneId]  [uniqueidentifier]  NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedDateTimeZoneId]  [uniqueidentifier]  NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_UserProject] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[UserProject]  WITH CHECK ADD  CONSTRAINT [FK_Goal_UserProject_GoalId] FOREIGN KEY([GoalId])
REFERENCES [dbo].[Goal] ([Id])
GO

ALTER TABLE [dbo].[UserProject] CHECK CONSTRAINT [FK_Goal_UserProject_GoalId]
GO
ALTER TABLE [dbo].[UserProject]  WITH CHECK ADD  CONSTRAINT [FK_Project_UserProject_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO

ALTER TABLE [dbo].[UserProject] CHECK CONSTRAINT [FK_Project_UserProject_ProjectId]
GO
ALTER TABLE [dbo].[UserProject]  WITH CHECK ADD  CONSTRAINT [FK_User_UserProject_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserProject] CHECK CONSTRAINT [FK_User_UserProject_UserId]
GO

ALTER TABLE [dbo].[UserProject]  WITH CHECK ADD  CONSTRAINT [FK_EntityRole_UserProject_EntityRoleId] FOREIGN KEY([EntityRoleId])
REFERENCES [dbo].[EntityRole] ([Id])
GO

ALTER TABLE [dbo].[UserProject] CHECK CONSTRAINT [FK_EntityRole_UserProject_EntityRoleId]
GO

CREATE NONCLUSTERED INDEX IX_UserProject_ProjecId 
ON [dbo].[UserProject] (  ProjectId ASC  )
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_UserProject_UserId_InActiveDateTime
ON [dbo].[UserProject] ([UserId],[InActiveDateTime])
GO