CREATE TABLE [dbo].[GoalStatusConfiguration](
    [Id] [uniqueidentifier] NOT NULL,
    [GoalStatusId] [uniqueidentifier] NULL,
    [FieldPermissionId] [uniqueidentifier] NULL,
    [CreatedDateTime] DATETIMEOFFSET NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
CONSTRAINT [PK_GoalStatusConfiguration] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_GoalStatusConfiguration_GoalStatusId_FieldPermissionId] UNIQUE ([GoalStatusId],[FieldPermissionId])
)
GO

ALTER TABLE [dbo].[GoalStatusConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_GoalStatusConfiguration_FieldPermission] FOREIGN KEY([FieldPermissionId])
REFERENCES [dbo].[FieldPermission] ([Id])
GO

ALTER TABLE [dbo].[GoalStatusConfiguration] CHECK CONSTRAINT [FK_GoalStatusConfiguration_FieldPermission]
GO