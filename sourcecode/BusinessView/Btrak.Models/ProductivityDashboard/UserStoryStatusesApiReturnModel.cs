using System;
using System.Text;

namespace Btrak.Models.ProductivityDashboard
{
    public class UserStoryStatusesApiReturnModel
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string UserProfileImage { get; set; }
        public string ProjectName { get; set; }
        public Guid? ProjectId { get; set; }
        public string Goal { get; set; }
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public string CurrentStatus { get; set; }
        public DateTimeOffset? OriginalDeployDate { get; set; }
        public DateTime? LatestDeployedDate { get; set; }
        public DateTime? QAApprovalDate { get; set; }
        public int DeployedToInprogressCount { get; set; }
        public int TotalCount { get; set; }
        public int ReOpen { get; set; }
        public string GoalShortName { get; set; }
        public string SprintName { get; set; }
        public bool? IsFromSprint { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", UserProfileImage = " + UserProfileImage);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", Goal = " + Goal);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", CurrentStatus = " + CurrentStatus);
            stringBuilder.Append(", OriginalDeployDate = " + OriginalDeployDate);
            stringBuilder.Append(", LatestDeployedDate = " + LatestDeployedDate);
            stringBuilder.Append(", QAApprovalDate = " + QAApprovalDate);
            stringBuilder.Append(", DeployedToInprogressCount = " + DeployedToInprogressCount);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", ReOpen = " + ReOpen);
            stringBuilder.Append(", GoalShortName = " + GoalShortName);
            return stringBuilder.ToString();
        }
    }
}
