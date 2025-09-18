using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class UserStoriesForAllGoalsSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public UserStoriesForAllGoalsSearchCriteriaInputModel() : base(InputTypeGuidConstants.GetAccessibleIpAddresses)
        {
        }

        public Guid? UserStoryId { get; set; }
        public Guid? GoalId { get; set; }
        public string ProjectId { get; set; }
        public string UserStoryTypeIds { get; set; }
        public string BugCausedUserIds { get; set; }
        public string DependencyUserIds { get; set; }
        public string BugPriorityIds { get; set; }
        public string ProjectFeatureIds { get; set; }
        public string UserStoryName { get; set; }
        public string VersionName { get; set; }
        public DateTime? DeadLineDate { get; set; }
        public DateTime? CreatedDateFrom { get; set; }
        public DateTime? CreatedDateTo { get; set; }
        public DateTime? UpdatedDateFrom { get; set; }
        public DateTime? UpdatedDateTo { get; set; }

        public string OwnerUserId { get; set; }
        public string GoalResponsiblePersonId { get; set; }
        public string UserStoryStatusId { get; set; }
        public string GoalStatusId { get; set; }
        public string GoalName { get; set; }
        public DateTimeOffset? DeadLineDateFrom { get; set; }
        public DateTimeOffset? DeadLineDateTo { get; set; }
        public bool? IsRed { get; set; }
        public bool? IsWarning { get; set; }
        public bool? IsTracked { get; set; }
        public bool? IsProductive { get; set; }
        public bool? IsArchivedGoal { get; set; }
        public bool? IsParkedGoal { get; set; }
        public bool IsAdvancedSearch { get; set; }
        public bool? IsIncludedArchive { get; set; }
        public bool? IsIncludedPark { get; set; }
        public bool? IsOnTrack { get; set; }
        public bool? IsNotOnTrack { get; set; }
        public string Tags { get; set; }
        public string WorkItemTags { get; set; }
        public string WorkItemTagsXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" UserStoryId = " + UserStoryId);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", GoalResponsiblePersonId = " + GoalResponsiblePersonId);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", GoalStatusId = " + GoalStatusId);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", DeadLineDateFrom = " + DeadLineDateFrom);
            stringBuilder.Append(", DeadLineDateTo = " + DeadLineDateTo);
            stringBuilder.Append(", IsRed = " + IsRed);
            stringBuilder.Append(", IsWarning = " + IsWarning);
            stringBuilder.Append(", IsTracked = " + IsTracked);
            stringBuilder.Append(", IsProductive = " + IsProductive);
            stringBuilder.Append(", IsArchivedGoal = " + IsArchivedGoal);
            stringBuilder.Append(", IsParkedGoal = " + IsParkedGoal);

            stringBuilder.Append(", UserStoryTypeIds  = " + UserStoryTypeIds);
            stringBuilder.Append(", BugCausedUserIds  = " + BugCausedUserIds);
            stringBuilder.Append(", DependencyUserIds = " + DependencyUserIds);
            stringBuilder.Append(", BugPriorityIds = " + BugPriorityIds);
            stringBuilder.Append(", ProjectFeatureIds = " + ProjectFeatureIds);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", VersionName = " + VersionName);
            stringBuilder.Append(", DeadLineDate = " + DeadLineDate);
            stringBuilder.Append(",CreatedDateFrom = " + CreatedDateFrom);
            stringBuilder.Append(",CreatedDateTo  = " + CreatedDateTo);
            return stringBuilder.ToString();
        }
    }
}
