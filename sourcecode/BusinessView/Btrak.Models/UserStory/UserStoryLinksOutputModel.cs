using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.UserStory
{
    public class UserStoryLinksOutputModel
    {
        public string ProjectName { get; set; }
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public string GoalName { get; set; }
        public string GoalShortName { get; set; }
        public string DependencyName { get; set; }
        public string OwnerName { get; set; }
        public decimal? EstimatedTime { get; set; }
        public int TotalCount { get; set; }
        public DateTimeOffset? DeadLineDate { get; set; }
        public DateTimeOffset? UserStoryArchivedDateTime { get; set; }
        public DateTimeOffset? UserStoryParkedDateTime { get; set; }
        public bool IsForQa { get; set; }
        public string VersionName { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public Guid? OwnerUserId { get; set; }
        public Guid? DependencyUserId { get; set; }
        public string OwnerProfileImage { get; set; }
        public string DependencyProfileImage { get; set; }
        public string BugPriority { get; set; }
        public string BugPriorityDescription { get; set; }
        public string BugPriorityColor { get; set; }
        public Guid? BugCausedUserId { get; set; }
        public string BugCausedUserName { get; set; }
        public string BugCausedUserProfileImage { get; set; }
        public string Icon { get; set; }
        public int? Order { get; set; }
        public string ProjectFeatureName { get; set; }
        public Guid ProjectId { get; set; }
        public Guid GoalId { get; set; }
        public Byte[] TimeStamp { get; set; }
        public Guid? BugPriorityId { get; set; }
        public Guid? ProjectFeatureId { get; set; }
        public DateTimeOffset? TransitionDateTime { get; set; }
        public string Tag { get; set; }
        public Guid? LinkUserStoryId { get; set; }
        public Guid? LinkUserStoryTypeId { get; set; }
        public string LinkUserStoryTypeName { get; set; }
        public string UserStoryUniqueName { get; set; }
        public string UserStoryTypeColor { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", GoalShortName = " + GoalShortName);
            stringBuilder.Append(", BugPriorityDescription = " + BugPriorityDescription);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", DeadLineDate = " + DeadLineDate);
            stringBuilder.Append(", OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", OwnerName = " + OwnerName);
            stringBuilder.Append(", OwnerProfileImage = " + OwnerProfileImage);
            stringBuilder.Append(", DependencyName = " + DependencyName);
            stringBuilder.Append(", DependencyProfileImage = " + DependencyProfileImage);
            stringBuilder.Append(", Order = " + Order);
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
            return stringBuilder.ToString();
        }
    }
}
