CREATE TABLE [dbo].[RateTagRoleBranchConfiguration]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	[BranchId] UNIQUEIDENTIFIER NULL, 
	[RoleId] UNIQUEIDENTIFIER NULL, 
	[StartDate] DATETIME NULL,
	[EndDate] DATETIME NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime]  DATETIME          NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[CompanyId] UNIQUEIDENTIFIER NULL,
	[Priority] INT NULL
CONSTRAINT [PK_RateTagRoleBranchConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[RateTagRoleBranchConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_RateTagRoleBranchConfiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RateTagRoleBranchConfiguration] CHECK CONSTRAINT [FK_RateTagRoleBranchConfiguration_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[RateTagRoleBranchConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_RateTagRoleBranchConfiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[RateTagRoleBranchConfiguration] CHECK CONSTRAINT [FK_RateTagRoleBranchConfiguration_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[RateTagRoleBranchConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_RateTagRoleBranchConfiguration_Role_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

ALTER TABLE [dbo].[RateTagRoleBranchConfiguration] CHECK CONSTRAINT [FK_RateTagRoleBranchConfiguration_Role_RoleId]
GO
ALTER TABLE [dbo].[RateTagRoleBranchConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_RateTagRoleBranchConfiguration_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[RateTagRoleBranchConfiguration] CHECK CONSTRAINT [FK_RateTagRoleBranchConfiguration_Branch_BranchId]
GO