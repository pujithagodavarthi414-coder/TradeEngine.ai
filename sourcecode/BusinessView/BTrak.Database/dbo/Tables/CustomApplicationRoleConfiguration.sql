CREATE TABLE [CustomApplicationRoleConfiguration]
(
	Id UNIQUEIDENTIFIER NOT NULL,
	CustomApplicationId UNIQUEIDENTIFIER NOT NULL,
	RoleId UNIQUEIDENTIFIER NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TimeStamp NOT NULL
CONSTRAINT [PK_CustomApplicationRoleConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomApplicationRoleConfiguration]  WITH NOCHECK ADD  CONSTRAINT [FK_Role_CustomApplicationRoleConfiguration_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

ALTER TABLE [dbo].[CustomApplicationRoleConfiguration] CHECK CONSTRAINT [FK_Role_CustomApplicationRoleConfiguration_RoleId]
GO

ALTER TABLE [dbo].[CustomApplicationRoleConfiguration]  WITH NOCHECK ADD  CONSTRAINT [FK_User_CustomApplicationRoleConfiguration_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomApplicationRoleConfiguration] CHECK CONSTRAINT [FK_User_CustomApplicationRoleConfiguration_CreatedByUserId]
GO

