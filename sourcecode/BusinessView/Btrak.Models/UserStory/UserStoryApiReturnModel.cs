using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStoryApiReturnModel
    {
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string UserStoryUniqueName { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public bool? IsSprintsConfiguration { get; set; }
        public bool? IsFromSprints { get; set; }
        public bool? IsBacklog { get; set; }
        public Guid? GoalId { get; set; }
        public string GoalName { get; set; }
        public string GoalShortName { get; set; }
        public DateTimeOffset? OnboardProcessDate { get; set; }
        public bool? IsLocked { get; set; }
        public Guid? GoalResponsibleUserId { get; set; }
        public string GoalResponsibleUserName { get; set; }
        public string GoalResponsibleProfileImage { get; set; }
        public string ParentUserStoryName { get; set; }
        public string GoalUniqueName { get; set; }

        public string ActionCategoryName { get; set; }
        public Guid? ActionCategoryId { get; set; }

        public bool? IsProductiveBoard { get; set; }
        public bool? IsOnTrack { get; set; }
        public bool? IsToBeTracked { get; set; }
        public bool? IsMyWork { get; set; }
        public Guid? ConsiderEstimatedHoursId { get; set; }
        public string ConsiderHourName { get; set; }

        public Guid? BoardTypeId { get; set; }
        public string BoardTypeName { get; set; }

        public Guid? BoardTypeApiId { get; set; }
        public string BoardTypeApiName { get; set; }

        public Guid? ConfigurationId { get; set; }
        public string ConfigurationTypeName { get; set; }

        public decimal? GoalBudget { get; set; }
        public string Version { get; set; }

        public bool IsArchived { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }
        public DateTimeOffset? ParkedDateTime { get; set; }

        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }

        public decimal? EstimatedTime { get; set; }
        public decimal? TotalEstimatedTime { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public DateTimeOffset? ActualDeadLineDate { get; set; }

        public Guid? OwnerUserId { get; set; }
        public string OwnerName { get; set; }
        public string OwnerProfileImage { get; set; }
        public Guid? DependencyUserId { get; set; }
        public string DependencyName { get; set; }
        public string DependencyProfileImage { get; set; }

        public int? Order { get; set; }
        public Guid? TaskStatusId { get; set; }

        public Guid? BugPriorityId { get; set; }
        public string BugPriority { get; set; }
        public string BugPriorityDescription { get; set; }
        public string BugPriorityColor { get; set; }
        public int BugsCount { get; set; }
        public string Icon { get; set; }

        public Guid? BugCausedUserId { get; set; }
        public string BugCausedUserName { get; set; }
        public string BugCausedUserProfileImage { get; set; }

        public Guid? GoalStatusId { get; set; }
        public string GoalStatusColor { get; set; }

        public Guid? UserStoryStatusId { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }

        public Guid? UserStoryTypeId { get; set; }
        public string UserStoryTypeName { get; set; }

        public Guid? ProjectFeatureId { get; set; }
        public string ProjectFeatureName { get; set; }

        public Guid? WorkFlowId { get; set; }
        public bool? IsApproved { get; set; }

        public DateTimeOffset CreatedDateTime { get; set; }
        public string CreatedOn { get; set; }

        public DateTimeOffset? UserStoryArchivedDateTime { get; set; }
        public DateTimeOffset? UserStoryParkedDateTime { get; set; }

        public string Remarks { get; set; }

        public Guid UserStoryExistedStatusId { get; set; }

        public List<Guid> UserStoryIds { get; set; }
        public string UserStoryIdsXml { get; set; }

        public int UserStoriesCount { get; set; }
        public int TotalCount { get; set; }

        public int DaysCount { get; set; }
        public int AbsDaysCount { get; set; }

        public List<Guid> GoalIds { get; set; }

        public Guid? FeatureId { get; set; }

        public Guid? UserStoryPriorityId { get; set; }
        public string PriorityName { get; set; }
        public int? UserStoryPriorityOder { get; set; }

        public Guid? ReviewerUserId { get; set; }
        public string ReviewerUserName { get; set; }
        public string ReviewerUserProfileImage { get; set; }

        public Guid? ParentUserStoryId { get; set; }
        public Guid? ParentUserStoryGoalId { get; set; }
        public Guid? TestSuiteId { get; set; }
        public Guid? TestCaseId { get; set; }
        public Guid? TestSuiteSectionId { get; set; }
        public string TestSuiteSectionName { get; set; }
        public string Description { get; set; }
        public byte[] TimeStamp { get; set; }
        public string EntityFeaturesXml { get; set; }
        public bool? IsSuperAgileBoard { get; set; }

        public string Tag { get; set; }
        public string VersionName { get; set; }
        public DateTimeOffset? TransitionDateTime { get; set; }
        public Guid? BoardTypeUiId { get; set; }
        public bool? IsBugBoard { get; set; }
        public string DescriptionSlug { get; set; }
        public DateTimeOffset? GoalParkedDateTime { get; set; }
        public DateTimeOffset? GoalArchivedDateTime { get; set; }
        public string SubUserStories { get; set; }
        public bool? IsQaRequired { get; set; }
        public bool? IsLogTimeRequired { get; set; }
        public Guid? WorkFlowStatusId { get; set; }
        public string UserStoryTypeColor { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? FormId { get; set; }
        public Guid? WorkFlowTaskId { get; set; }
        public Guid? GenericFormSubmittedId { get; set; }
        public bool IsDateTimeConfiguration { get; set; }
        public bool IsAdhocUserStory { get; set; }
        public bool IsFillForm { get; set; }
        public string SprintName { get; set; }
        public DateTime? SprintInActiveDateTime { get; set; }
        public Guid? SprintId { get; set; }
        public bool? IsSprintUserStory { get; set; }
        public bool AutoLog { get; set; }
        public bool IsAutoLog { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public bool? BreakType { get; set; }
        public bool? IsReplan { get; set; }
        public DateTime? SprintEndDate { get; set; }
        public DateTime? SprintStartDate { get; set; }
        public string RAGStatus { get; set; }
        public bool IsEnableTestRepo { get; set; }
        public bool IsEnableBugBoards { get; set; }
        public bool IsEnableStartStop { get; set; }
        public bool? IsBug { get; set; }

        //cron expression 
        public byte[] CronExpressionTimeStamp { get; set; }
        public string CronExpression { get; set; }
        public Guid? CronExpressionId { get; set; }
        public int JobId { get; set; }
        public DateTime? ScheduleEndDate { get; set; }
        public bool? IsPaused { get; set; }
        public string UserStoryCustomFieldsXml { get; set; }
        public List<UserStoryCustomFieldsModel> UserStoryCustomFields { get; set; }

        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public DateTimeOffset? UserStoryStartDate { get; set; }
        public Guid? ConductId { get; set; }
        public Guid? ConductQuestionId { get; set; }
        public Guid? AuditConductQuestionId { get; set; }
        public Guid? QuestionId { get; set; }
        public string QuestionName { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", IsDateTimeConfiguration = " + IsDateTimeConfiguration);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", GoalShortName = " + GoalShortName);
            stringBuilder.Append(", GoalBudget = " + GoalBudget);
            stringBuilder.Append(", GoalResponsibleUserId = " + GoalResponsibleUserId);
            stringBuilder.Append(", GoalResponsibleUserName = " + GoalResponsibleUserName);
            stringBuilder.Append(", BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", TestCaseId = " + TestCaseId);
            stringBuilder.Append(", TestSuiteSectionId = " + TestSuiteSectionId);
            stringBuilder.Append(", TestSuiteSectionName = " + TestSuiteSectionName);
            stringBuilder.Append(", BoardTypeApiId = " + BoardTypeApiId);
            stringBuilder.Append(", BoardTypeName = " + BoardTypeName);
            stringBuilder.Append(", BugPriorityDescription = " + BugPriorityDescription);
            stringBuilder.Append(", OnboardProcessDate = " + OnboardProcessDate);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", IsLocked = " + IsLocked);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            stringBuilder.Append(", ParkedDateTime = " + ParkedDateTime);
            stringBuilder.Append(", GoalStatusId = " + GoalStatusId);
            stringBuilder.Append(", GoalStatusColor = " + GoalStatusColor);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", IsProductiveBoard = " + IsProductiveBoard);
            stringBuilder.Append(", IsToBeTracked = " + IsToBeTracked);
            stringBuilder.Append(", ConsiderEstimatedHoursId = " + ConsiderEstimatedHoursId);
            stringBuilder.Append(", ConsiderHourName = " + ConsiderHourName);
            stringBuilder.Append(", ConfigurationId = " + ConfigurationId);
            stringBuilder.Append(", ConfigurationTypeName = " + ConfigurationTypeName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", DeadLineDate = " + DeadLineDate);
            stringBuilder.Append(", OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", OwnerName = " + OwnerName);
            stringBuilder.Append(", OwnerProfileImage = " + OwnerProfileImage);
            stringBuilder.Append(", ProjectResponsiblePersonId = " + ProjectResponsiblePersonId);
            stringBuilder.Append(", DependencyUserId = " + DependencyUserId);
            stringBuilder.Append(", DependencyName = " + DependencyName);
            stringBuilder.Append(", DependencyProfileImage = " + DependencyProfileImage);
            stringBuilder.Append(", Order = " + Order);
            stringBuilder.Append(", UserStoryStatusName = " + UserStoryStatusName);
            stringBuilder.Append(", UserStoryStatusColor = " + UserStoryStatusColor);
            stringBuilder.Append(", ActualDeadLineDate = " + ActualDeadLineDate);
            stringBuilder.Append(", UserStoryArchivedDateTime = " + UserStoryArchivedDateTime);
            stringBuilder.Append(", BugPriorityId = " + BugPriorityId);
            stringBuilder.Append(", BugPriority = " + BugPriority);
            stringBuilder.Append(", BugPriorityColor = " + BugPriorityColor);
            stringBuilder.Append(", BugCausedUserId = " + BugCausedUserId);
            stringBuilder.Append(", BugCausedUserName = " + BugCausedUserName);
            stringBuilder.Append(", BugCausedUserProfileImage = " + BugCausedUserProfileImage);
            stringBuilder.Append(", UserStoryTypeId = " + UserStoryTypeId);
            stringBuilder.Append(", ProjectFeatureId = " + ProjectFeatureId);
            stringBuilder.Append(", UserStoryTypeName = " + UserStoryTypeName);
            stringBuilder.Append(", ProjectFeatureName = " + ProjectFeatureName);
            stringBuilder.Append(", UserStoryParkedDateTime = " + UserStoryParkedDateTime);
            stringBuilder.Append(", UserStoryExistedStatusId = " + UserStoryExistedStatusId);
            stringBuilder.Append(", UserStoryIds = " + UserStoryIds);
            stringBuilder.Append(", UserStoryIdsXml = " + UserStoryIdsXml);
            stringBuilder.Append(", UserStoriesCount = " + UserStoriesCount);
            stringBuilder.Append(", GoalIds = " + GoalIds);
            stringBuilder.Append(", UserStoryPriorityId = " + UserStoryPriorityId);
            stringBuilder.Append(", PriorityName = " + PriorityName);
            stringBuilder.Append(", UserStoryPriorityOder = " + UserStoryPriorityOder);
            stringBuilder.Append(", ReviewerUserId = " + ReviewerUserId);
            stringBuilder.Append(", ReviewerUserName = " + ReviewerUserName);
            stringBuilder.Append(", ReviewerUserProfileImage = " + ReviewerUserProfileImage);
            stringBuilder.Append(", ParentUserStoryId = " + ParentUserStoryId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", Tag = " + Tag);
            stringBuilder.Append(", VersionName = " + VersionName);
            stringBuilder.Append(", IsAdhocUserStory = " + IsAdhocUserStory);
            stringBuilder.Append(", IsFillForm = " + IsFillForm);
            stringBuilder.Append(", CustomApplicationId = " + CustomApplicationId);
            stringBuilder.Append(", FormId = " + FormId);
            stringBuilder.Append(", GenericFormSubmittedId = " + GenericFormSubmittedId);
            stringBuilder.Append(", BreakType = " + BreakType);
            stringBuilder.Append(", UserStoryCustomFieldsXml = " + UserStoryCustomFieldsXml);
            stringBuilder.Append(", UserStoryCustomFields = " + UserStoryCustomFields);
            stringBuilder.Append(", UserStoryStartDate = " + UserStoryStartDate);
            return stringBuilder.ToString();
        }
    }
}
