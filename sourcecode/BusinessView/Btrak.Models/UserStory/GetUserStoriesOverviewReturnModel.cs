using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
    public class GetUserStoriesOverviewReturnModel
    {
        public string ProjectName { get; set; }
        public bool IsDateTimeConfiguration { get; set; }
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public string GoalName { get; set; }
        public string SprintName { get; set; }
        public string GoalShortName { get; set; }
        public string DependencyName { get; set; }
        public string OwnerName { get; set; }
        public string UserSpentTime { get; set; }
        public string DescriptionDetails { get; set; }
        public string Description { get; set; }
        public decimal? EstimatedTime { get; set; }
        public decimal? TotalEstimatedTime { get; set; }
        public int TotalCount { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public DateTimeOffset? UserStoryArchivedDateTime { get; set; }
        public DateTimeOffset? UserStoryParkedDateTime { get; set; }
        public bool? IsForQa { get; set; }
        public string VersionName { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public Guid? OwnerUserId { get; set; }
        public Guid? DependencyUserId { get; set; }
        public Guid? ParentUserStoryGoalId { get; set; }
        public Guid? ParentUserStoryId { get; set; }
        public Guid? TestCaseId { get; set; }
        public Guid? TestSuiteId { get; set; }
        public Guid? TestSuiteSectionId { get; set; }
        public Guid? ActionCategoryId { get; set; }
        public string ActionCategoryName { get; set; }
        public string TestSuiteSectionName { get; set; }
        public string OwnerProfileImage { get; set; }
        public string DependencyProfileImage { get; set; }
        public string BugPriority { get; set; }
        public string BugPriorityDescription { get; set; }
        public string BugPriorityColor { get; set; }
        public Guid? BugCausedUserId { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public bool? IsBugBoard { get; set; }
        public string BugCausedUserName { get; set; }
        public string BugCausedUserProfileImage { get; set; }
        public bool IsEnableTestRepo { get; set; }
        public string Icon { get; set; }
        public int? Order { get; set; }
        public int BugsCount { get; set; }
        public string ProjectFeatureName { get; set; }
        public Guid ProjectId { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? SprintId { get; set; }
        public Byte[] TimeStamp { get; set; }
        public Guid? BugPriorityId { get; set; }
        public Guid? ProjectFeatureId { get; set; }
        public DateTimeOffset? TransitionDateTime { get; set; }
        public string UserStoryUniqueName { get; set; }
        public bool? IsOnTrack { get; set; }
        public Guid? GoalStatusId { get; set; }
        public string Tag { get; set; }
        public string SubUserStories { get; set; }
        public Guid? WorkFlowId { get; set; }
        public Guid? WorkFlowStatusId { get; set; }
        public string UserStoryTypeName { get; set; }
        public string UserStoryTypeColor { get; set; }
        public bool AutoLog { get; set; }
        public bool IsAutoLog { get; set; }
        public bool? BreakType { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public Guid? BoardTypeId { get; set; }
        public bool? IsFromSprints { get; set; }
        public bool? IsBacklog { get; set; }
        public string RAGStatus { get; set; }
        public string UserStoryCustomFieldsXml { get; set; }
        public List<UserStoryCustomFieldsModel> UserStoryCustomFields { get; set; }
        public bool IsEnableBugBoards { get; set; }
        public bool IsEnableStartStop { get; set; }
        public bool? IsBug { get; set; }
        public Guid? BoardTypeUiId { get; set; }
        public Guid? TaskStatusId { get; set; }
        public string ParentUserStoryName { get; set; }
        public bool? IsSuperAgileBoard { get; set; }
        //cron expression 
        public byte[] CronExpressionTimeStamp { get; set; }
        public string CronExpression { get; set; }
        public Guid? CronExpressionId { get; set; }
        public int JobId { get; set; }
        public DateTime? ScheduleEndDate { get; set; }
        public DateTimeOffset? CreatedDate { get; set; }
        public bool? IsPaused { get; set; }
        public string GoalUniqueName { get; set; }
        public string CreatedOnTimeZoneAbbreviation { get; set; }
        public string DeadLineTimeZoneAbbreviation { get; set; }
        public DateTimeOffset OnboardProcessDate { get; set; }
        public int TaskStatusOrder { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", IsDateTimeConfiguration = " + IsDateTimeConfiguration);
            stringBuilder.Append(", GoalShortName = " + GoalShortName);
            stringBuilder.Append(", BugPriorityDescription = " + BugPriorityDescription);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", DeadLineDate = " + DeadLineDate);
            stringBuilder.Append(", OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", ParentUserStoryGoalId = " + ParentUserStoryGoalId);
            stringBuilder.Append(", ParentUserStoryId = " + ParentUserStoryId);
            stringBuilder.Append(", TestCaseId = " + TestCaseId);
            stringBuilder.Append(", TestSuiteId = " + TestSuiteId);
            stringBuilder.Append(", UserStoryTypeId = " + UserStoryTypeId);
            stringBuilder.Append(", TestSuiteSectionId = " + TestSuiteSectionId);
            stringBuilder.Append(", TestSuiteSectionName = " + TestSuiteSectionName);
            stringBuilder.Append(", OwnerName = " + OwnerName);
            stringBuilder.Append(", OwnerProfileImage = " + OwnerProfileImage);
            stringBuilder.Append(", DependencyName = " + DependencyName);
            stringBuilder.Append(", DependencyProfileImage = " + DependencyProfileImage);
            stringBuilder.Append(", Order = " + Order);
            stringBuilder.Append(", BugsCount = " + BugsCount);
            stringBuilder.Append(", UserStoryStatusName = " + UserStoryStatusName);
            stringBuilder.Append(", UserStoryStatusColor = " + UserStoryStatusColor);
            stringBuilder.Append(", UserStoryArchivedDateTime = " + UserStoryArchivedDateTime);
            stringBuilder.Append(", BugPriority = " + BugPriority);
            stringBuilder.Append(", BugPriorityColor = " + BugPriorityColor);
            stringBuilder.Append(", BugCausedUserId = " + BugCausedUserId);
            stringBuilder.Append(", BugCausedUserName = " + BugCausedUserName);
            stringBuilder.Append(", BugCausedUserProfileImage = " + BugCausedUserProfileImage);
            stringBuilder.Append(", ProjectFeatureName = " + ProjectFeatureName);
            stringBuilder.Append(", UserStoryParkedDateTime = " + UserStoryParkedDateTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", VersionName = " + VersionName);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", TransitionDateTime = " + TransitionDateTime);
            stringBuilder.Append(", AutoLog = " + AutoLog);
            stringBuilder.Append(", StartTime = " + StartTime);
            stringBuilder.Append(", EndTime = " + EndTime);
            stringBuilder.Append(", BreakType = " + BreakType);
            stringBuilder.Append(", UserStoryCustomFieldsXml = " + UserStoryCustomFieldsXml);
            stringBuilder.Append(", UserStoryCustomFields = " + UserStoryCustomFields);
            return stringBuilder.ToString();
        }
    }

    public class DownloadWorkItemsModel
    {
        public List<GetUserStoriesOverviewReturnModel> ChildUserStories { get; set; }
    }
}
