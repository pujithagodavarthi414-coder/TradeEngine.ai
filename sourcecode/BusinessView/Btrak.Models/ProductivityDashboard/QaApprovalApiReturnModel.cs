using System;
using System.Text;

namespace Btrak.Models.ProductivityDashboard
{
    public class QaApprovalApiReturnModel
    {
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public string Goal { get; set; }
        public Guid? UserStoryId { get; set; }
        public string UserStory { get; set; }
        public Guid UserId { get; set; }
        public string UserProfileImage { get; set; }
        public string DeveloperName { get; set; }
        public DateTimeOffset? DeployedDateTime { get; set; }
        public string DeployedWeek { get; set; }
        public DateTimeOffset? QADeadline { get; set; }
        public string QADeadlineWeek { get; set; }
        public string Status { get; set; }
        public int Due { get; set; }
        public int TotalCount { get; set; }
        public string Sprint { get; set; }
        public string DeployedDateTimeZoneAbbreviation { get; set; }
        public string DeployedDateTimeZoneName { get; set; }
        public bool? IsFromSprint { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("DeveloperName = " + DeveloperName);
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append("UserProfileImage = " + UserProfileImage);
            stringBuilder.Append(", ProjectId = " + ProjectId);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", Goal = " + Goal);
            stringBuilder.Append(", UserStory = " + UserStory);
            stringBuilder.Append(", DeployedDateTime = " + DeployedDateTime);
            stringBuilder.Append(", DeployedWeek = " + DeployedWeek);
            stringBuilder.Append(", QADeadline = " + QADeadline);
            stringBuilder.Append(", QADeadlineWeek = " + QADeadlineWeek);
            stringBuilder.Append(", Status = " + Status);
            stringBuilder.Append(", Due = " + Due);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
