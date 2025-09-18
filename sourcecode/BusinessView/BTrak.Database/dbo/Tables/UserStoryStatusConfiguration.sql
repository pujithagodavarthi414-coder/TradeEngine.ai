CREATE TABLE [dbo].[UserStoryStatusConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[UserStoryStatusId] [uniqueidentifier] NULL,
	[FieldPermissionId] [uniqueidentifier] NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_UserStoryStatusConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_UserStoryStatusConfiguration_UserStoryStatusId_FieldPermissionId] UNIQUE ([UserStoryStatusId],[FieldPermissionId])
)

GO

ALTER TABLE [dbo].[UserStoryStatusConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_UserStoryStatusConfiguration_FieldPermission] FOREIGN KEY([FieldPermissionId])
REFERENCES [dbo].[FieldPermission] ([Id])
GO

ALTER TABLE [dbo].[UserStoryStatusConfiguration] CHECK CONSTRAINT [FK_UserStoryStatusConfiguration_FieldPermission]
GO

ALTER TABLE [dbo].[UserStoryStatusConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_UserStoryStatusConfiguration_UserStoryStatus_UserStoryStatusId] FOREIGN KEY([UserStoryStatusId])
REFERENCES [dbo].[UserStoryStatus] ([Id])
GO
ALTER TABLE [dbo].[UserStoryStatusConfiguration] CHECK CONSTRAINT [FK_UserStoryStatusConfiguration_UserStoryStatus_UserStoryStatusId]
GO