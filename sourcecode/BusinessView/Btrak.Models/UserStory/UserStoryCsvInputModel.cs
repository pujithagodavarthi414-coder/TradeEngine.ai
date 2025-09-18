using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class UserStoryCsvInputModel : InputModelBase
    {
        public UserStoryCsvInputModel() : base(InputTypeGuidConstants.UserStoryCsvInputCommandTypeGuid)
        {
        }

        public string UserStoryName { get; set; }
        public string ETime { get; set; }
        public string DeadLine { get; set; }
        public string OwnerName { get; set; }
        public string DependencyName { get; set; }
        public string BugPriority { get; set; }
        public string BugCausedUserName { get; set; }
        public string ProjectFeatureName { get; set; }

        public string Remarks { get; set; }

        public decimal? EstimatedTime { get; set; }
        public Guid? OwnerUserId { get; set; }
        public Guid? DependencyUserId { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public Guid? BugPriorityId { get; set; }
        public Guid? BugCausedUserId { get; set; }
        public Guid? ProjectFeatureId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryName = " + UserStoryName);
            stringBuilder.Append(", EstimatedTime = " + EstimatedTime);
            stringBuilder.Append(", ETime = " + ETime);
            stringBuilder.Append(", DeadLine = " + DeadLine);
            stringBuilder.Append(", OwnerName = " + OwnerName);
            stringBuilder.Append(", DependencyName = " + DependencyName);
            stringBuilder.Append(", BugPriority = " + BugPriority);
            stringBuilder.Append(", BugCausedUserName = " + BugCausedUserName);
            stringBuilder.Append(", ProjectFeatureName = " + ProjectFeatureName);
            stringBuilder.Append(", Remarks = " + Remarks);
            stringBuilder.Append(", OwnerUserId = " + OwnerUserId);
            stringBuilder.Append(", DependencyUserId = " + DependencyUserId);
            stringBuilder.Append(", UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", BugPriorityId = " + BugPriorityId);
            stringBuilder.Append(", BugCausedUserId = " + BugCausedUserId);
            stringBuilder.Append(", ProjectFeatureId = " + ProjectFeatureId);
            return stringBuilder.ToString();
        }
    }
}
