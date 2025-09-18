CREATE TABLE [dbo].[UserStory](
	[Id] [uniqueidentifier] NOT NULL,
	[GoalId] [uniqueidentifier] NULL,
	[UserStoryName] [nvarchar](800) NOT NULL,
	[Description] [nvarchar](MAX) NULL,
	[EstimatedTime] [decimal](18, 2) NULL,
	[DeadLineDate] DATETIMEOFFSET NULL,
	[DeadLineDateTimeZone] UNIQUEIDENTIFIER NULL,
	[OwnerUserId] [uniqueidentifier] NULL,
	[TestSuiteSectionId] [uniqueidentifier] NULL,
	[TestCaseId] [uniqueidentifier] NULL,
	[DependencyUserId] [uniqueidentifier] NULL,
	[Order] [int] NULL,
	[UserStoryStatusId] [uniqueidentifier] NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZone] UNIQUEIDENTIFIER NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[ActualDeadLineDate] DATETIMEOFFSET NULL,
	[ActualDeadLineDateTimeZone] UNIQUEIDENTIFIER NULL,
	[ArchivedDateTime] DATETIMEOFFSET NULL,
	[BugPriorityId] [UNIQUEIDENTIFIER] NULL,
	[UserStoryTypeId] [UNIQUEIDENTIFIER] NULL,
	[ProjectFeatureId] [UNIQUEIDENTIFIER] NULL,
	[ParkedDateTime] DATETIMEOFFSET NULL,
	[ParkedDateTimeZoneId] [UNIQUEIDENTIFIER] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[InActiveDateTimeZoneId] [UNIQUEIDENTIFIER] NULL,
	[VersionName] [varchar](250) NULL,
	[EpicName] [varchar](250) NULL,
    [TimeStamp] TIMESTAMP,
    [UserStoryPriorityId] UNIQUEIDENTIFIER NULL, 
    [UserStoryUniqueName] NVARCHAR(250) NULL, 
	[ReviewerUserId] UNIQUEIDENTIFIER NULL, 
	[ParentUserStoryId] UNIQUEIDENTIFIER NULL, 
	[WorkFlowId] UNIQUEIDENTIFIER NULL, 
    [Tag] NVARCHAR(MAX) NULL, 
    [IsForQa] BIT NULL, 
	TemplateId UNIQUEIDENTIFIER NULL,
    [CustomApplicationId] UNIQUEIDENTIFIER NULL,
	[FormId] UNIQUEIDENTIFIER NULL,
	[WorkFlowTaskId] UNIQUEIDENTIFIER NULL, 
    [GenericFormSubmittedId] UNIQUEIDENTIFIER NULL, 
	[ReferenceId] UNIQUEIDENTIFIER NULL,
	[ReferenceTypeId] UNIQUEIDENTIFIER NULL,
    [SprintId] UNIQUEIDENTIFIER NULL, 
    [SprintEstimatedTime] DECIMAL(18, 2) NULL, 
    [ProjectId] UNIQUEIDENTIFIER,
    [IsBacklog] BIT NULL, 
	[RAGStatus] NVARCHAR(50),
	[WorkspaceDashboardId]  UNIQUEIDENTIFIER NULL,
	[AuditConductQuestionId] NVARCHAR (MAX),
	[ActionCategoryId] UNIQUEIDENTIFIER NULL,
	[StartDate] DATETIMEOFFSET NULL,
    CONSTRAINT [PK_UserStory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[UserStory]  WITH CHECK ADD  CONSTRAINT [FK_Goal_UserStory_GoalId] FOREIGN KEY([GoalId])
REFERENCES [dbo].[Goal] ([Id])
GO

ALTER TABLE [dbo].[UserStory] CHECK CONSTRAINT [FK_Goal_UserStory_GoalId]
GO

ALTER TABLE [dbo].[UserStory]  WITH CHECK ADD  CONSTRAINT [FK_TestSuiteSection_UserStory_TestSuiteSectionId] FOREIGN KEY([TestSuiteSectionId])
REFERENCES [dbo].[TestSuiteSection] ([Id])
GO

ALTER TABLE [dbo].[UserStory] CHECK CONSTRAINT [FK_TestSuiteSection_UserStory_TestSuiteSectionId]
GO

ALTER TABLE [dbo].[UserStory]  WITH NOCHECK ADD CONSTRAINT [FK_UserStoryPriority_UserStory_UserStoryPriorityId] FOREIGN KEY ([UserStoryPriorityId])
REFERENCES [dbo].[UserStoryPriority] ([Id])
GO

ALTER TABLE [dbo].[UserStory] CHECK CONSTRAINT [FK_UserStoryPriority_UserStory_UserStoryPriorityId]
GO

ALTER TABLE [dbo].[UserStory]  WITH NOCHECK ADD CONSTRAINT [FK_BugPriority_UserStory_BugPriorityId] FOREIGN KEY ([BugPriorityId])
REFERENCES [dbo].[BugPriority] ([Id])
GO

ALTER TABLE [dbo].[UserStory] CHECK CONSTRAINT [FK_BugPriority_UserStory_BugPriorityId]
GO
ALTER TABLE [dbo].[UserStory]  WITH CHECK ADD  CONSTRAINT [FK_UserStory_UserStoryStatus_UserStoryStatusId] FOREIGN KEY([UserStoryStatusId])
REFERENCES [dbo].[UserStoryStatus] ([Id])
GO
ALTER TABLE [dbo].[UserStory] CHECK CONSTRAINT [FK_UserStory_UserStoryStatus_UserStoryStatusId]
GO

ALTER TABLE [dbo].[UserStory]  WITH NOCHECK ADD  CONSTRAINT [FK_Templates_UserStory_TemplateId] FOREIGN KEY([TemplateId])
REFERENCES [dbo].[Templates] ([Id])
GO
ALTER TABLE [dbo].[UserStory] CHECK CONSTRAINT [FK_Templates_UserStory_TemplateId]
GO

ALTER TABLE [dbo].[UserStory]  WITH NOCHECK ADD CONSTRAINT [FK_WorkspaceDashboards_UserStory_WorkspaceDashboardId] FOREIGN KEY ([WorkspaceDashboardId])
REFERENCES [dbo].[WorkspaceDashboards] ([Id])
GO

CREATE NONCLUSTERED INDEX IX_UserStory_ArchivedDateTime_ParkedDateTime_InActiveDateTime 
ON [dbo].[UserStory] (  ArchivedDateTime ASC  , BugPriorityId ASC  , ParkedDateTime ASC  , InActiveDateTime ASC  )   
INCLUDE ( GoalId , OwnerUserId , UserStoryStatusId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_UserStory_CreatedDateTime_UserStoryTypeId 
ON [dbo].[UserStory] (  CreatedDateTime ASC  , UserStoryTypeId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_UserStory_DependencyUserId_ArchivedDateTime_ParkedDateTime 
ON [dbo].[UserStory] (  DependencyUserId ASC  , ArchivedDateTime ASC  , ParkedDateTime ASC  , InActiveDateTime ASC  )   
INCLUDE ( DeadLineDate , EstimatedTime , GoalId , [Order] , OwnerUserId , UserStoryName , UserStoryStatusId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_UserStory_InActiveDateTime ON [dbo].[UserStory] (  InActiveDateTime ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX UserStory_GoalId 
ON [dbo].[UserStory] (  GoalId ASC  )   
INCLUDE ( ArchivedDateTime , BugPriorityId , DeadLineDate , DependencyUserId , EstimatedTime , InActiveDateTime , IsForQa , [Order] , OwnerUserId , ParkedDateTime , ProjectFeatureId , ReviewerUserId , [TimeStamp] , UserStoryName , UserStoryPriorityId , UserStoryStatusId , UserStoryTypeId , VersionName )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_UserStory_OwnerUserId_InActiveDateTime
ON [dbo].[UserStory] ([OwnerUserId],[InActiveDateTime])
GO
CREATE NONCLUSTERED INDEX [IDX_UserStory_TestCaseId_ArchivedDateTime_ParkedDateTime_InActiveDateTime]
ON [dbo].[UserStory] ([TestCaseId],[ArchivedDateTime],[ParkedDateTime],[InActiveDateTime])
INCLUDE ([GoalId],[UserStoryStatusId],[UserStoryTypeId])
GO

CREATE NONCLUSTERED INDEX IX_UserStory_ParentUserStoryId_SprintId
ON [dbo].[UserStory] ([ParentUserStoryId],[SprintId])
INCLUDE ([Id],[UserStoryName],[EstimatedTime],[OwnerUserId],[TestSuiteSectionId],[TestCaseId],[DependencyUserId],[Order],[UserStoryStatusId],[UserStoryTypeId],[ProjectFeatureId],[ParkedDateTime],[InActiveDateTime],[TimeStamp],[UserStoryUniqueName],[Tag],[SprintEstimatedTime],[RAGStatus])
GO

CREATE NONCLUSTERED INDEX [IX_UserStory_ProjectId]
ON [dbo].[UserStory] ([ProjectId])
INCLUDE ([Id],[GoalId],[UserStoryName],[Description],[EstimatedTime],[DeadLineDate],[OwnerUserId],[TestSuiteSectionId],[TestCaseId],[DependencyUserId],[Order],[UserStoryStatusId],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[ActualDeadLineDate],[ArchivedDateTime],[BugPriorityId],[UserStoryTypeId],[ProjectFeatureId],[ParkedDateTime],[InActiveDateTime],[VersionName],[EpicName],[TimeStamp],[UserStoryPriorityId],[UserStoryUniqueName],[ReviewerUserId],[ParentUserStoryId],[WorkFlowId],[Tag],[IsForQa],[TemplateId],[CustomApplicationId],[FormId],[WorkFlowTaskId],[GenericFormSubmittedId],[SprintId],[SprintEstimatedTime],[IsBacklog],[RAGStatus],[WorkspaceDashboardId],[AuditConductQuestionId])
GO

CREATE NONCLUSTERED  INDEX IX_UserStory_ParentUserStoryId_TestCaseId_ParkedDateTime_InActiveDateTime
ON [dbo].[UserStory] (ParentUserStoryId,[InActiveDateTime],[ParkedDateTime],[TestCaseId])
GO

CREATE NONCLUSTERED INDEX IX_UserStory_ParentUserStoryId
ON [dbo].[UserStory] ([ArchivedDateTime],[ParkedDateTime],[InActiveDateTime],[SprintId])
INCLUDE ([UserStoryStatusId],[ParentUserStoryId])
GO

CREATE NONCLUSTERED INDEX IX_UserStory_UserStoryStatusId_ArchivedDateTime_ParkedDateTime_InActiveDateTime_SprintId
ON [dbo].[UserStory] ([UserStoryStatusId],[ArchivedDateTime],[ParkedDateTime],[InActiveDateTime],[SprintId])
INCLUDE ([ParentUserStoryId])
GO
CREATE NONCLUSTERED   INDEX [IX_UserStory_ParkedDateTime]
ON [dbo].[UserStory] ([ParkedDateTime],[InActiveDateTime])
INCLUDE ([Id],[GoalId],[UserStoryName],[EstimatedTime],[DeadLineDate],[OwnerUserId],[TestSuiteSectionId],[TestCaseId],[DependencyUserId],[Order],[UserStoryStatusId],[CreatedDateTime],[CreatedByUserId],[BugPriorityId],[UserStoryTypeId],[ProjectFeatureId],[VersionName],[TimeStamp],[UserStoryUniqueName],[ParentUserStoryId],[WorkFlowId],[Tag],[CustomApplicationId],[FormId],[WorkFlowTaskId],[GenericFormSubmittedId],[ReferenceId],[ReferenceTypeId],[SprintId],[ProjectId],[WorkspaceDashboardId],[AuditConductQuestionId],[ActionCategoryId])
GO

  CREATE NONCLUSTERED  INDEX [IX_UserStory_SprintId]
ON [dbo].[UserStory] ([SprintId])
INCLUDE ([Id],[GoalId],[UserStoryName],[UserStoryUniqueName],[ProjectId])
GO
