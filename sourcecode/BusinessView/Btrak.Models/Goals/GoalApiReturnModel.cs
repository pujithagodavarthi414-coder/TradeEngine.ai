using Btrak.Models.UserStory;
using System;
using System.Collections.Generic;
using System.Text;
using Btrak.Models.EntityType;

namespace Btrak.Models.Goals
{
    public class GoalApiReturnModel
    {
        public GoalApiReturnModel()
        {
            UserStories = new List<UserStoryApiReturnModel>();
            GoalsList = new List<GoalApiReturnModel>();
            EntityFeaturesList = new List<EntityFeatureApiReturnModel>();
        }

        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public Guid? GoalId { get; set; }
        public string GoalName { get; set; }
        public string GoalShortName { get; set; }
        public string GoalUniqueName { get; set; }
        public decimal? GoalBudget { get; set; }
        public Guid? GoalResponsibleUserId { get; set; }
        public string GoalResponsibleUserName { get; set; }
        public string GoalResponsibleProfileImage { get; set; }
        public string ProfileImage { get; set; }
        public Guid? BoardTypeId { get; set; }
        public bool? IsBugBoard { get; set; }
        public bool? IsSuperAgileBoard { get; set; }
        public bool? IsDefault { get; set; }
        public string BoardTypeUiName { get; set; }
        public Guid? BoadTypeUiId { get; set; }
        public Guid? BoardTypeApiId { get; set; }
        public Guid? BoardTypeUiId { get; set; }
        public string BoardTypeName { get; set; }
        public string OnboardDate { get; set; }
        public DateTimeOffset? OnboardProcessDate { get; set; }
        public bool IsArchived { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }
        public DateTimeOffset? InActiveDateTime { get; set; }
        public bool? IsLocked { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsParked { get; set; }
        public bool? GoalIsParked { get; set; }
        public DateTimeOffset? ParkedDateTime { get; set; }
        public bool? IsCompleted { get; set; }
        public Guid? GoalStatusId { get; set; }
        public string GoalStatusName { get; set; }
        public string GoalStatusColor { get; set; }
        public string Version { get; set; }
        public bool? IsProductiveBoard { get; set; }
        public bool? IsToBeTracked { get; set; }
        public Guid? ConsiderEstimatedHoursId { get; set; }
        public string ConsiderHourName { get; set; }
        public Guid? ConfigurationId { get; set; }
        public string ConfigurationTypeName { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTimeOffset? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public string UserStoriesXml { get; set; }
        public string GoalsXml { get; set; }
        public Guid? WorkflowId { get; set; }
        public int? ActiveUserStoryCount { get; set; }
        public bool? IsWarning { get; set; }
        public DateTimeOffset? GoalDeadLine { get; set; }
        public decimal? GoalEstimatedTime { get; set; }
        public string EntityFeaturesXml { get; set; }
        public string Tag { get; set; }
        public bool IsEnableTestRepo { get; set; }

        public List<UserStoryApiReturnModel> UserStories { get; set; }
        public List<GoalApiReturnModel> GoalsList { get; set; }
        public List<EntityFeatureApiReturnModel> EntityFeaturesList { get; set; }

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
        public string OwnerProfileImage { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public bool? ProjectIsArchived { get; set; }
        public DateTimeOffset? ProjectArchivedDateTime { get; set; }
        public string ProjectStatusColor { get; set; }
        public DateTimeOffset? GoalArchivedDateTime { get; set; }
        public bool? GoalIsArchived { get; set; }
        public Guid? DependencyUserId { get; set; }
        public string DependencyName { get; set; }
        public string DependencyFirstName { get; set; }
        public string DependencySurName { get; set; }
        public string DependencyProfileImage { get; set; }
        public int? Order { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }
        public bool? UserStoryStatusIsArchived { get; set; }
        public DateTime? UserStoryStatusArchivedDateTime { get; set; }
        public DateTimeOffset? ActualDeadLineDate { get; set; }
        public DateTimeOffset? UserStoryArchivedDateTime { get; set; }
        public Guid? BugPriorityId { get; set; }
        public Guid? BugPriority { get; set; }
        public string BugPriorityColor { get; set; }
        public Guid? BugCausedUserId { get; set; }
        public string BugCausedUserName { get; set; }
        public string BugCausedUserFirstName { get; set; }
        public string BugCausedUserSurName { get; set; }
        public string BugCausedUserProfileImage { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public Guid? ProjectFeatureId { get; set; }
        public Guid? TestSuiteId { get; set; }
        public string TestSuiteName { get; set; }
        public int BugsCount { get; set; }
        public byte[] TimeStamp { get; set; }
        public string Description { get; set; }
        public int TotalCount { get; set; }
        public int GoalRepalnCount { get; set; }
        public int ActiveGoalsCount { get; set; }
        public int BackLogGoalsCount { get; set; }
        public int UnderReplanGoalsCount { get; set; }
        public bool?  IsDateTimeConfiguration { get; set; }
        public bool? IsSprintsConfiguration { get; set; }
        public DateTimeOffset? EndDate { get; set; }
        public decimal? GoalEstimateTime { get; set; }


        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProjectId = " + ProjectId);
            stringBuilder.Append(", GoalUniqueName = " + GoalUniqueName);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", GoalShortName = " + GoalShortName);
            stringBuilder.Append(", GoalBudget = " + GoalBudget);
            stringBuilder.Append(", GoalResponsibleUserId = " + GoalResponsibleUserId);
            stringBuilder.Append(", GoalResponsibleUserName = " + GoalResponsibleUserName);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", BoardTypeApiId = " + BoardTypeApiId);
            stringBuilder.Append(", BoardTypeUiId = " + BoardTypeUiId);
            stringBuilder.Append(", BoardTypeName = " + BoardTypeName);
            stringBuilder.Append(", OnboardDate = " + OnboardDate);
            stringBuilder.Append(", OnboardProcessDate = " + OnboardProcessDate);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", IsLocked = " + IsLocked);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            stringBuilder.Append(", IsParked = " + IsParked);
            stringBuilder.Append(", GoalIsParked = " + GoalIsParked);
            stringBuilder.Append(", ParkedDateTime = " + ParkedDateTime);
            stringBuilder.Append(", IsCompleted = " + IsCompleted);
            stringBuilder.Append(", GoalStatusId = " + GoalStatusId);
            stringBuilder.Append(", GoalStatusName = " + GoalStatusName);
            stringBuilder.Append(", GoalStatusColor = " + GoalStatusColor);
            stringBuilder.Append(", Version = " + Version);
            stringBuilder.Append(", IsProductiveBoard = " + IsProductiveBoard);
            stringBuilder.Append(", IsToBeTracked = " + IsToBeTracked);
            stringBuilder.Append(", ConsiderEstimatedHoursId = " + ConsiderEstimatedHoursId);
            stringBuilder.Append(", ConsiderHourName = " + ConsiderHourName);
            stringBuilder.Append(", ConfigurationId = " + ConfigurationId);
            stringBuilder.Append(", ConfigurationTypeName = " + ConfigurationTypeName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", UserStoriesXml = " + UserStoriesXml);
            stringBuilder.Append(", GoalsXml = " + GoalsXml);
            stringBuilder.Append(", WorkflowId = " + WorkflowId);
            stringBuilder.Append(", UserStories = " + UserStories);
            stringBuilder.Append(", GoalsList = " + GoalsList);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", DeadLineDate = " + DeadLineDate);
            stringBuilder.Append(", OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", OwnerName = " + OwnerName);
            stringBuilder.Append(", OwnerFirstName = " + OwnerFirstName);
            stringBuilder.Append(", OwnerSurName = " + OwnerSurName);
            stringBuilder.Append(", OwnerEmail = " + OwnerEmail);
            stringBuilder.Append(", OwnerPassword = " + OwnerPassword);
            stringBuilder.Append(", OwnerProfileImage = " + OwnerProfileImage);
            stringBuilder.Append(", ProjectResponsiblePersonId = " + ProjectResponsiblePersonId);
            stringBuilder.Append(", ProjectIsArchived = " + ProjectIsArchived);
            stringBuilder.Append(", ProjectArchivedDateTime = " + ProjectArchivedDateTime);
            stringBuilder.Append(", ProjectStatusColor = " + ProjectStatusColor);
            stringBuilder.Append(", GoalArchivedDateTime = " + GoalArchivedDateTime);
            stringBuilder.Append(", GoalIsArchived = " + GoalIsArchived);
            stringBuilder.Append(", DependencyUserId = " + DependencyUserId);
            stringBuilder.Append(", DependencyName = " + DependencyName);
            stringBuilder.Append(", DependencyFirstName = " + DependencyFirstName);
            stringBuilder.Append(", DependencySurName = " + DependencySurName);
            stringBuilder.Append(", DependencyProfileImage = " + DependencyProfileImage);
            stringBuilder.Append(", Order = " + Order);
            stringBuilder.Append(", BugsCount = " + BugsCount);
            stringBuilder.Append(", UserStoryStatusId = " + GoalArchivedDateTime);
            stringBuilder.Append(", UserStoryStatusName = " + UserStoryStatusName);
            stringBuilder.Append(", UserStoryStatusColor = " + UserStoryStatusColor);
            stringBuilder.Append(", UserStoryStatusIsArchived = " + UserStoryStatusIsArchived);
            stringBuilder.Append(", UserStoryStatusArchivedDateTime = " + UserStoryStatusArchivedDateTime);
            stringBuilder.Append(", ActualDeadLineDate = " + ActualDeadLineDate);
            stringBuilder.Append(", UserStoryArchivedDateTime = " + UserStoryArchivedDateTime);
            stringBuilder.Append(", BugPriorityId = " + BugPriorityId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", TestSuiteName = " + TestSuiteName);
            stringBuilder.Append(", BugPriority = " + BugPriority);
            stringBuilder.Append(", BugPriorityColor = " + BugPriorityColor);
            stringBuilder.Append(", BugCausedUserId = " + BugCausedUserId);
            stringBuilder.Append(", BugCausedUserName = " + BugCausedUserName);
            stringBuilder.Append(", BugCausedUserFirstName = " + BugCausedUserFirstName);
            stringBuilder.Append(", BugCausedUserSurName = " + BugCausedUserSurName);
            stringBuilder.Append(", BugCausedUserProfileImage = " + BugCausedUserProfileImage);
            stringBuilder.Append(", UserStoryTypeId = " + UserStoryTypeId);
            stringBuilder.Append(", ProjectFeatureId = " + ProjectFeatureId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", GoalRepalnCount = " + GoalRepalnCount);
            stringBuilder.Append(", ActiveGoalsCount = " + ActiveGoalsCount);
            stringBuilder.Append(", BackLogGoalsCount = " + BackLogGoalsCount);
            stringBuilder.Append(", UnderReplanGoalsCount = " + UnderReplanGoalsCount);
            stringBuilder.Append(", Tag = " + Tag);
            return stringBuilder.ToString();
        }
    }
}
