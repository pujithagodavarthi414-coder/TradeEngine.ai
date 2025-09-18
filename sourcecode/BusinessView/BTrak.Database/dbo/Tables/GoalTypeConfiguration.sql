CREATE TABLE [dbo].[GoalTypeConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[GoalTypeId] [uniqueidentifier] NULL,
	[FieldPermissionId] [uniqueidentifier] NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_GoalTypeConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_GoalTypeConfiguration_GoalTypeId_FieldPermissionId] UNIQUE ([GoalTypeId],[FieldPermissionId])
)

GO

ALTER TABLE [dbo].[GoalTypeConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_GoalTypeConfiguration_FieldPermission] FOREIGN KEY([FieldPermissionId])
REFERENCES [dbo].[FieldPermission] ([Id])
GO

ALTER TABLE [dbo].[GoalTypeConfiguration] CHECK CONSTRAINT [FK_GoalTypeConfiguration_FieldPermission]
GO