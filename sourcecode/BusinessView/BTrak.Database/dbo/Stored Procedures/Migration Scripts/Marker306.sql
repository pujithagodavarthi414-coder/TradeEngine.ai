CREATE PROCEDURE [dbo].[Marker306]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN

DROP INDEX IF EXISTS IX_UserStory_ParkedDateTime ON UserStory
DROP INDEX IF EXISTS IX_UserStory_ProjectId ON UserStory

ALTER TABLE UserStory
ALTER COLUMN AuditConductQuestionId NVARCHAR(MAX)

CREATE NONCLUSTERED INDEX [IX_UserStory_ProjectId]
ON [dbo].[UserStory] ([ProjectId])
INCLUDE ([Id],[GoalId],[UserStoryName],[Description],[EstimatedTime],[DeadLineDate],[OwnerUserId],[TestSuiteSectionId],[TestCaseId],[DependencyUserId],[Order],[UserStoryStatusId],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[ActualDeadLineDate],[ArchivedDateTime],[BugPriorityId],[UserStoryTypeId],[ProjectFeatureId],[ParkedDateTime],[InActiveDateTime],[VersionName],[EpicName],[TimeStamp],[UserStoryPriorityId],[UserStoryUniqueName],[ReviewerUserId],[ParentUserStoryId],[WorkFlowId],[Tag],[IsForQa],[TemplateId],[CustomApplicationId],[FormId],[WorkFlowTaskId],[GenericFormSubmittedId],[SprintId],[SprintEstimatedTime],[IsBacklog],[RAGStatus],[WorkspaceDashboardId],[AuditConductQuestionId])

CREATE NONCLUSTERED   INDEX [IX_UserStory_ParkedDateTime]
ON [dbo].[UserStory] ([ParkedDateTime],[InActiveDateTime])
INCLUDE ([Id],[GoalId],[UserStoryName],[EstimatedTime],[DeadLineDate],[OwnerUserId],[TestSuiteSectionId],[TestCaseId],[DependencyUserId],[Order],[UserStoryStatusId],[CreatedDateTime],[CreatedByUserId],[BugPriorityId],[UserStoryTypeId],[ProjectFeatureId],[VersionName],[TimeStamp],[UserStoryUniqueName],[ParentUserStoryId],[WorkFlowId],[Tag],[CustomApplicationId],[FormId],[WorkFlowTaskId],[GenericFormSubmittedId],[ReferenceId],[ReferenceTypeId],[SprintId],[ProjectId],[WorkspaceDashboardId],[AuditConductQuestionId],[ActionCategoryId])
END

GO