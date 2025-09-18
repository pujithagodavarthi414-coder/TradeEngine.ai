using System;
using System.Text;

namespace Btrak.Models.Dashboard
{
    public class ProcessDashboardApiReturnModel
    {
        public Guid? ProcessDashboardId { get; set; }

        public Guid? GoalId { get; set; }
        public string GoalName { get; set; }
        public string GoalStatusName { get; set; }
        public DateTimeOffset? MileStone { get; set; }
        public string MileStoneDate { get; set; }
        public Guid? ProcessDashBoardCreatedByUserId { get; set; }
        public int? Delay { get; set; }
        public string DelayColor { get; set; }

        public int? DashboardId { get; set; }

        public DateTimeOffset? GeneratedDateTime { get; set; }
        public string GeneratedOn { get; set; }

        public string GoalStatusColor { get; set; }

        public DateTimeOffset? OnboardProcessDate { get; set; }
        public string OnboardProcessedOn { get; set; }

        public Guid? GoalResponsibleUserId { get; set; }
        public string GoalResponsibleUserName { get; set; }
        public string Members { get; set; }
        public decimal Deviation { get; set; }
        public Guid? ProjectId { get; set; }

        public string GeneratedDateTimeZoneAbbreviation { get; set; }
        public string GeneratedDateTimeZoneName { get; set; }
        public string OnboardProcessDateTimeZoneAbbreviation { get; set; }
        public string OnboardProcessDateTimeZoneName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ProcessDashboardId = " + ProcessDashboardId);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", GoalName = " + GoalName);
            stringBuilder.Append(", MileStone = " + MileStone);
            stringBuilder.Append(", MileStoneDate = " + MileStoneDate);
            stringBuilder.Append(", Delay = " + Delay);
            stringBuilder.Append(", DelayColor = " + DelayColor);
            stringBuilder.Append(", GoalStatusColor = " + GoalStatusColor);
            stringBuilder.Append(", DashboardId = " + DashboardId);
            stringBuilder.Append(", GeneratedDateTime = " + GeneratedDateTime);
            stringBuilder.Append(", GeneratedOn = " + GeneratedOn);
            stringBuilder.Append(", OnboardProcessDate = " + OnboardProcessDate);
            stringBuilder.Append(", OnboardProcessedOn = " + OnboardProcessedOn);
            stringBuilder.Append(", GoalResponsibleUserId = " + GoalResponsibleUserId);
            stringBuilder.Append(", GoalResponsibleUserName = " + GoalResponsibleUserName);
            stringBuilder.Append(", Members = " + Members);
            stringBuilder.Append(", Deviation = " + Deviation);
            stringBuilder.Append(", GeneratedDateTimeZoneAbbreviation = " + GeneratedDateTimeZoneAbbreviation);
            stringBuilder.Append(", GeneratedDateTimeZoneName = " + GeneratedDateTimeZoneName);
            stringBuilder.Append(", OnboardProcessDateTimeZoneAbbreviation = " + OnboardProcessDateTimeZoneAbbreviation);
            stringBuilder.Append(", OnboardProcessDateTimeZoneName = " + OnboardProcessDateTimeZoneName);
            return stringBuilder.ToString();
        }
    }
}
