using System;

namespace Btrak.Models.UserStory
{
    public class UserStoriesForAllGoalsSpReturnModel
    {
        public Guid? GoalId { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public bool? ProjectIsArchived { get; set; }
        public DateTimeOffset? ProjectArchivedDateTime { get; set; }
        public string ProjectStatusColor { get; set; }
        public Guid? BoardTypeId { get; set; }
        public Guid? BoardTypeApiId { get; set; }
        public DateTimeOffset? GoalArchivedDateTime { get; set; }
        public DateTimeOffset? InActiveDateTime { get; set; }
        public string GoalBudget { get; set; }
        public string GoalName { get; set; }
        public string Version { get; set; }
        public Guid? GoalStatusId { get; set; }
        public string GoalShortName { get; set; }
        public string GoalStatusColor { get; set; }
        public DateTimeOffset? GoalDeadLine { get; set; }
        public decimal? GoalEstimatedTime { get; set; }
        public bool? GoalIsArchived { get; set; }
        public bool? IsLocked { get; set; }
        public bool? IsProductiveBoard { get; set; }
        public bool? IsToBeTracked { get; set; }
        public DateTimeOffset? OnboardProcessDate { get; set; }
        public bool? GoalIsParked { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsWarning { get; set; }
        public DateTimeOffset? ParkedDateTime { get; set; }
        public Guid? GoalResponsibleUserId { get; set; }
        public string GoalResponsibleUserName { get; set; }
        public string GoalResponsibleProfileImage { get; set; }
        public string ProfileImage { get; set; }
        public Guid? ConfigurationId { get; set; }
        public Guid? ConsiderEstimatedHoursId { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string BoardTypeName { get; set; }
        public Guid? WorkFlowId { get; set; }
        public string WorkFlowName { get; set; }
        public int? ActiveUserStoryCount { get; set; }
        public int? WorkItemsCount { get; set; }
        public string EntityFeaturesXml { get; set; }
        public int? TotalCount { get; set; }
        public Guid? BoardTypeUiId { get; set; }
        public Guid? TestSuiteId { get; set; }
        public string TestSuiteName { get; set; }

        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public decimal? EstimatedTime { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public Guid? OwnerUserId { get; set; }
        public string OwnerName { get; set; }
        public string OwnerFirstName { get; set; }
        public string OwnerSurName { get; set; }
        public string OwnerEmail { get; set; }
        public string OwnerPassword { get; set; }
        public Guid? OwnerRoleId { get; set; }
        public string OwnerProfileImage { get; set; }
        public string OwnerRoleName { get; set; }
        public Guid? DependencyUserId { get; set; }
        public string DependencyName { get; set; }
        public string DependencyFirstName { get; set; }
        public string DependencySurName { get; set; }
        public Guid? DependencyRoleId { get; set; }
        public string DependencyProfileImage { get; set; }
        public string DependencyRoleName { get; set; }
        public int? Order { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }
        public bool? UserStoryStatusIsArchived { get; set; }
        public bool? IsBugBoard { get; set; }
        public bool? IsSuperAgileBoard { get; set; }
        public bool? IsDefault { get; set; }
        public DateTimeOffset? UserStoryStatusArchivedDateTime { get; set; }
        public DateTimeOffset? ActualDeadLineDate { get; set; }
        public DateTimeOffset? UserStoryArchivedDateTime { get; set; }
        public Guid? BugPriorityId { get; set; }
        public Guid? BugPriority { get; set; }
        public string BugPriorityColor { get; set; }
        public Guid? BugCausedUserId { get; set; }
        public string BugCausedUserName { get; set; }
        public string BugCausedUserFirstName { get; set; }
        public string BugCausedUserSurName { get; set; }
        public Guid? BugCausedUserRoleId { get; set; }
        public string BugCausedUserProfileImage { get; set; }
        public string BugCausedUserRoleName { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public Guid? ProjectFeatureId { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTimeOffset? UpdatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public string GoalUniqueName { get; set; }
        public bool? IsDateTimeConfiguration { get; set; }
        public bool IsEnableTestRepo { get; set; }
        public string Tag { get; set; }

        public string Features { get; set; }
    }
}
