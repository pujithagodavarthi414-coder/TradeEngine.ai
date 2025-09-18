CREATE TABLE [dbo].[RoleConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NULL,
	[FieldPermissionId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_RoleConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_RoleConfiguration_RoleId_FieldPermissionId] UNIQUE ([RoleId],[FieldPermissionId])
)

GO

ALTER TABLE [dbo].[RoleConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_RoleConfiguration_FieldPermission] FOREIGN KEY([FieldPermissionId])
REFERENCES [dbo].[FieldPermission] ([Id])
GO

ALTER TABLE [dbo].[RoleConfiguration] CHECK CONSTRAINT [FK_RoleConfiguration_FieldPermission]
GO