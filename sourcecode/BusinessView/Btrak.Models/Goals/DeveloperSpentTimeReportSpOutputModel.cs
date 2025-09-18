using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class DeveloperSpentTimeReportSpOutputModel
    {
        public string UserStoryName { get; set; }
        public Guid UserStoryId { get; set; }
        public string UserStoryStatus { get; set; }
        public string StatusColor { get; set; }
        public DateTime Date { get; set; }
        public string DeveloperName { get; set; }
        public decimal? UserStorySpentTime { get; set; }
        public int? SummaryValue { get; set; }
        public string UniqueName { get; set; }
        public int? TotalSpentTimeSoFar { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserStoryId   = " + UserStoryId);
            stringBuilder.Append(", DeveloperName   = " + DeveloperName);
            stringBuilder.Append(", UserStoryName   = " + UserStoryName);
            stringBuilder.Append(", UserStoryStatus  = " + UserStoryStatus);
            stringBuilder.Append(", UserStorySpentTime  = " + UserStorySpentTime);
            stringBuilder.Append(", TotalSpentTimeSoFar  = " + TotalSpentTimeSoFar);
            stringBuilder.Append(", StatusColor  = " + StatusColor);
            stringBuilder.Append(", UniqueName  = " + UniqueName);
            stringBuilder.Append(", SummaryValue  = " + SummaryValue);
            stringBuilder.Append(", Date   = " + Date);
            return stringBuilder.ToString();
        }
    }
}