using System;
using System.Collections.Generic;

namespace Btrak.Models.UserStory
{
    public class UserStorySpReturnModel
    {
        public Guid? UserStoryId { get; set; }
        public Guid? GoalId { get; set; }
        public string UserStoryName { get; set; }
        public decimal? EstimatedTime { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public Guid? OwnerUserId { get; set; }
        public DateTimeOffset? UserStoryArchivedDateTime { get; set; }
        public DateTimeOffset? UserStoryParkedDateTime { get; set; }
        public string OwnerName { get; set; }
        public string OwnerProfileImage { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? BoardTypeId { get; set; }
        public Guid? BoardTypeApiId { get; set; }
        public Guid? BoardTypeUiId { get; set; }
        public DateTimeOffset? GoalArchivedDateTime { get; set; }
        public Guid? GoalStatusId { get; set; }
        public DateTimeOffset? OnboardProcessDate { get; set; }
        public Guid? ConfigurationId { get; set; }
        public Guid? DependencyUserId { get; set; }
        public string DependencyName { get; set; }
        public string DependencyProfileImage { get; set; }
        public int? Order { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }
        public Guid? BugPriorityId { get; set; }
        public Guid? ParentUserStoryId { get; set; }
        public Guid? ParentUserStoryGoalId { get; set; }
        public string BugPriority { get; set; }
        public string BugPriorityDescription { get; set; }
        public string BugPriorityColor { get; set; }
        public string Icon { get; set; }
        public Guid? BugCausedUserId { get; set; }
        public string BugCausedUserName { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public string UserStoryTypeName { get; set; }
        public Guid? UserStoryPriorityId { get; set; }
        public string PriorityName { get; set; }
        public int? UserStoryPriorityOder { get; set; }
        public Guid? ProjectFeatureId { get; set; }
        public string ProjectFeatureName { get; set; }
        public DateTimeOffset? ParkedDateTime { get; set; }
        public string UserStoryUniqueName { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public Guid? ReviewerUserId { get; set; }
        public string ReviewerUserName { get; set; }
        public string Description { get; set; }
        public Guid? WorkFlowId { get; set; }
        public int TotalCount { get; set; }

        public Guid? ProjectResponsiblePersonId { get; set; }
        public string GoalName { get; set; }
        public string GoalShortName { get; set; }
        public bool? IsLocked { get; set; }
        public Guid? GoalResponsibleUserId { get; set; }
        public string GoalResponsibleUserName { get; set; }
        public string GoalResponsibleProfileImage { get; set; }

        public bool? IsProductiveBoard { get; set; }
        public bool? IsToBeTracked { get; set; }
        public Guid? ConsiderEstimatedHoursId { get; set; }
        public string ConsiderHourName { get; set; }
        public string BoardTypeName { get; set; }
        public string BoardTypeApiName { get; set; }
        public string ConfigurationTypeName { get; set; }
        public decimal? GoalBudget { get; set; }
        public string Version { get; set; }
        public bool IsArchived { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }
        public DateTimeOffset? ActualDeadLineDate { get; set; }
        public string BugCausedUserProfileImage { get; set; }
        public string GoalStatusColor { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsOnTrack { get; set; }
        public string CreatedOn { get; set; }
        public string Remarks { get; set; }
        public Guid UserStoryExistedStatusId { get; set; }
        public List<Guid> UserStoryIds { get; set; }
        public string UserStoryIdsXml { get; set; }
        public int UserStoriesCount { get; set; }
        public int DaysCount { get; set; }
        public int AbsDaysCount { get; set; }
        public List<Guid> GoalIds { get; set; }
        public Guid? FeatureId { get; set; }
        public string ReviewerUserProfileImage { get; set; }
        public byte[] TimeStamp { get; set; }
        public string EntityFeaturesXml { get; set; }

        public string Tag { get; set; }
        public bool IsForQa { get; set; }
        public string VersionName { get; set; }
        public DateTimeOffset? TransitionDateTime { get; set; }
    }
}
