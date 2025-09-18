CREATE TABLE [dbo].[UserGoalFilter]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [GoalFilterId] UNIQUEIDENTIFIER NULL, 
    [GoalFilterJson] NVARCHAR(MAX) NULL, 
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL CONSTRAINT [PK_UserGoalFilter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    [InActiveDateTime] DATETIME NULL, 
)
GO

ALTER TABLE [dbo].[UserGoalFilter]  WITH NOCHECK ADD CONSTRAINT [FK_UserGoalFilter_UserGoalFilter_GoalFilterId] FOREIGN KEY ([GoalFilterId])
REFERENCES [dbo].[GoalFilter] ([Id])
GO

ALTER TABLE [dbo].[UserGoalFilter] CHECK CONSTRAINT [FK_UserGoalFilter_UserGoalFilter_GoalFilterId]
GO