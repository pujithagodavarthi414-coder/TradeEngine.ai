using System;
using System.Text;

namespace Btrak.Models.ProductivityDashboard
{
    public class TestingAgeApiReturnModel
    {
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public string Name { get; set; }
        public string ProjectName { get; set; }
        public string GoalName { get; set; }
        public string TesterName { get; set; }
        public Guid StatusId { get; set; }
        public string StatusName { get; set; }
        public DateTimeOffset OriginalDeployedDate { get; set; }
        public DateTimeOffset DeployedDate { get; set; }
        public DateTimeOffset LatestDeployedDate { get; set; }
        public DateTimeOffset ActionDate { get; set; }
        public int Age { get; set; }
        public int TotalCount { get; set; }
        public string SprintName { get; set; }
        public string OriginalDeployedDateTimeZoneAbbreviation { get; set; }
        public string ActionDateTimeZoneAbbreviation { get; set; }
        public string LatestDeployedDateTimeZoneAbbreviation { get; set; }
        public string OriginalDeployedDateTimeZoneName { get; set; }
        public string LatestDeployedDateTimeZoneName { get; set; }
        public string ActionDateTimeZoneName { get; set; }

        public bool? IsFromSprint { get; set; }
        public Guid? UserId { get; set; }
        public string ProfileImage { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", Name = " + Name);
            stringBuilder.Append(", ProjectName = " + ProjectName);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", TesterName = " + TesterName);
            stringBuilder.Append(", StatusId = " + StatusId);
            stringBuilder.Append(", StatusName = " + StatusName);
            stringBuilder.Append(", OriginalDeployedDate = " + OriginalDeployedDate);
            stringBuilder.Append(", LatestDeployedDate = " + LatestDeployedDate);
            stringBuilder.Append(", DeployedDate = " + DeployedDate);
            stringBuilder.Append(", ActionDate = " + ActionDate);
            stringBuilder.Append(", Age = " + Age);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
