using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Sprints
{
    public class SprintSearchOutPutModel
    {
        public Guid? OwnerUserId { get; set; }
        public Guid? DependencyUserId { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public Guid? UserStoryId { get; set; }
        public Guid? ProjectId { get; set; }
        public Guid? SprintId { get; set; }
        public bool? IsSprintsConfiguration { get; set; }
        public Guid? BoardTypeId { get; set; }
        public Guid? WorkFlowId { get; set; }
        public string Workflow { get; set; }
        public string OwnerName { get; set; }
        public string SprintName { get; set; }
        public string OwnerProfileImage { get; set; }
        public string DependencyProfileImage { get; set; }
        public string DependencyName { get; set; }
        public decimal? EstimatedTime { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public string UserStoryName { get; set; }
        public int Order { get; set; }
        public Guid? UserStoryTypeId { get; set; }
        public byte[] TimeStamp { get; set; }
        public string Description { get; set; }
        public string UserStoryTypeName { get; set; }
        public string UserStoryTypeColor { get; set; }
        public string SubUserStories { get; set; }
        public bool? IsQaRequired { get; set; }
        public bool? IsLogTimeRequired { get; set; }
        public bool IsDateTimeConfiguration { get; set; }
        public string UserStoryStatusColor { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryUniqueName { get; set; }
        public decimal? SprintEstimatedTime { get; set; }
        public decimal? TotalSprintEstimatedTime { get; set; }
        public decimal? TotalEstimatedTime { get; set; }
        public Guid? TaskStatusId { get; set; }
        public string Tag { get; set; }
        public Guid?  ParentUserStoryId { get; set; }
        public string ProjectName { get; set; }
        public DateTime? SprintEndDate { get; set; }
        public DateTime? SprintStartDate { get; set; }
        public bool? IsReplan { get; set; }
        public Guid? BoardTypeUiId { get; set; }
        public string BoardTypeName { get; set; }
        public string SprintUniqueName { get; set; }
        public Guid? GoalId { get; set; }
        public string GoalShortName { get; set; }
        public bool? IsBugBoard { get; set; }
        public bool? IsSuperAgileBoard { get; set; }
        public bool? IsDefault { get; set; }
        public Guid? BugPriorityId { get; set; }
        public string BugPriority { get; set; }
        public string BugPriorityDescription { get; set; }
        public string BugPriorityColor { get; set; }
        public int BugsCount { get; set; }
        public string Icon { get; set; }

        public Guid? BugCausedUserId { get; set; }
        public string BugCausedUserName { get; set; }
        public string BugCausedUserProfileImage { get; set; }
        public Guid? ProjectFeatureId { get; set; }
        public string ProjectFeatureName { get; set; }
        public Guid? TestCaseId { get; set; }
        public Guid? TestSuiteId { get; set; }
        public Guid? TestSuiteSectionId { get; set; }
        public bool? IsFromSprints { get; set; }
        public bool AutoLog { get; set; }
        public bool IsAutoLog { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public string RAGStatus { get; set; }
        public int? TaskStatusOrder { get; set; }
        public DateTime? SprintInActiveDateTime { get; set; }
        public bool? IsComplete { get; set; }
        public bool IsEnableTestRepo { get; set; }
        public bool IsEnableBugBoards { get; set; }
        public bool IsEnableStartStop { get; set; }
        public string TestSuiteSectionName { get; set; }
        public string VersionName { get; set; }
        public string ParentUserStoryName { get; set; }
        public string UserSpentTime { get; set; }
        public Guid? ParentUserStoryGoalId { get; set; }
        public int TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", DependencyUserId = " + DependencyUserId);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", SprintId = " + SprintId);
            stringBuilder.Append(", BoardTypeId = " + BoardTypeId);
            stringBuilder.Append(", WorkFlowId = " + WorkFlowId);
            stringBuilder.Append(", Workflow = " + Workflow);
            stringBuilder.Append(", OwnerName = " + OwnerName);
            stringBuilder.Append(", SprintName = " + SprintName);
            stringBuilder.Append(", OwnerProfileImage = " + OwnerProfileImage);
            stringBuilder.Append(", DependencyProfileImage = " + DependencyProfileImage);
            stringBuilder.Append(", DependencyName = " + DependencyName);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", Order = " + Order);
            return stringBuilder.ToString();
        }
    }

    public class DownloadSprintModel
    {
        public List<SprintSearchOutPutModel> ChildUserStories { get; set; }
    }
}
