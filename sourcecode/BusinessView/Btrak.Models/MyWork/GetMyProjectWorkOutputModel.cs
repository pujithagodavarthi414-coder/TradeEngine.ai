using System;
using System.Text;

namespace Btrak.Models.MyWork
{
    public class GetMyProjectWorkOutputModel
    {
        public Guid? UserStoryId { get; set; }
        public Guid? GoalId { get; set; }
        public string GoalName { get; set; }
        public string GoalShortName { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public bool IsDateTimeConfiguration { get; set; }
        public Guid? ProjectResponsiblePersonId { get; set; }
        public string UserStoryName { get; set; }
        public decimal? EstimatedTime { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public Guid? OwnerUserId { get; set; }
        public string OwnerName { get; set; }
        public string OwnerProfileImage { get; set; }
        public Guid? DependencyUserId { get; set; }
        public string DependencyName { get; set; }
        public string DependencyProfileImage { get; set; }
        public Guid? GoalStatusId { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public DateTimeOffset? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? BugCausedUserId { get; set; }
        public string BugCausedUserName { get; set; }
        public string BugCausedUserProfileImage { get; set; }
        public Guid? BugPriorityId { get; set; }
        public string BugPriority { get; set; }
        public string BugPriorityDescription { get; set; }
        public string BugPriorityColor { get; set; }
        public Guid? ProjectFeatureId { get; set; }
        public string ProjectFeatureName { get; set; }
        public bool CanArchive { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }
        public bool CanUserStoryPark { get; set; }
        public DateTimeOffset? UserStoryParkedDateTime { get; set; }
        public int Order { get; set; }
        public bool IsStarted { get; set; }
        public int UserStoriesCount { get; set; }
        public Guid BoardTypeId { get; set; }
        public int TotalCount { get; set; }
        public string UserStoryTypeName { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public Guid? WorkFlowId { get; set; }
        public Guid? BoardTypeUIId { get; set; }
        public string EntityFeaturesXml { get; set; }
        public Byte[] TimeStamp { get; set; }
        public string UserStoryUniqueName { get; set; }
        public decimal TotalEstimatedTime { get; set; }
        public DateTimeOffset? TransitionDateTime { get; set; }
        public string UserStoryTypeColor { get; set; }
        public string Tag { get; set; }
        public bool AutoLog { get; set; }
        public bool? BreakType { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public Guid? SprintId { get; set; }
        public string SprintName { get; set; }
        public Guid? SprintInActiveDateTime { get; set; }
        public bool? IsSprintUserStory { get; set; }
        //cron expression 
        public byte[] CronExpressionTimeStamp { get; set; }
        public string CronExpression { get; set; }
        public Guid? CronExpressionId { get; set; }
        public int JobId { get; set; }
        public DateTime? ScheduleEndDate { get; set; }
        public bool? IsPaused { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" UserStoryId = " + UserStoryId);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", IsDateTimeConfiguration = " + IsDateTimeConfiguration);
            stringBuilder.Append(", ProjectResponsiblePersonId = " + ProjectResponsiblePersonId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", DeadLineDate = " + DeadLineDate);
            stringBuilder.Append(", OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", OwnerName = " + OwnerName);
            stringBuilder.Append(", OwnerProfileImage = " + OwnerProfileImage);
            stringBuilder.Append(", DependencyUserId = " + DependencyUserId);
            stringBuilder.Append(", DependencyName = " + DependencyName);
            stringBuilder.Append(", DependencyProfileImage = " + DependencyProfileImage);
            stringBuilder.Append(", GoalStatusId = " + GoalStatusId);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", UserStoryStatusName = " + UserStoryStatusName);
            stringBuilder.Append(", UserStoryStatusColor = " + UserStoryStatusColor);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", BugCausedUserId = " + BugCausedUserId);
            stringBuilder.Append(", BugCausedUserName = " + BugCausedUserName);
            stringBuilder.Append(", BugCausedUserProfileImage = " + BugCausedUserProfileImage);
            stringBuilder.Append(", BugPriorityId = " + BugPriorityId);
            stringBuilder.Append(", BugPriority = " + BugPriority);
            stringBuilder.Append(", BugPriorityDescription = " + BugPriorityDescription);
            stringBuilder.Append(", BugPriorityColor = " + BugPriorityColor);
            stringBuilder.Append(", ProjectFeatureId = " + ProjectFeatureId);
            stringBuilder.Append(", ProjectFeatureName = " + ProjectFeatureName);
            stringBuilder.Append(", CanArchive = " + CanArchive);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            stringBuilder.Append(", CanUserStoryPark = " + CanUserStoryPark);
            stringBuilder.Append(", UserStoryParkedDateTime = " + UserStoryParkedDateTime);
            stringBuilder.Append(", Order = " + Order);
            stringBuilder.Append(", IsStarted = " + IsStarted);
            stringBuilder.Append(", UserStoriesCount = " + UserStoriesCount);
            stringBuilder.Append(", BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", UserStoryTypeName = " + UserStoryTypeName);
            stringBuilder.Append(", UserStoryTypeId = " + UserStoryTypeId);
            stringBuilder.Append(", WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", AutoLog = " + AutoLog);
            stringBuilder.Append(", StartTime = " + StartTime);
            stringBuilder.Append(", EndTime = " + EndTime);
            stringBuilder.Append(", BreakType = " + BreakType);
            return stringBuilder.ToString();
        }

    }
}
