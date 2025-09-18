using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Goals
{
    public class DeveloperSpentTimeReportApiOutputModel
    {
        public List<object> DeveloperName { get; set; }
        public List<object> UserStoryName { get; set; }
        public List<object> UserStoryId { get; set; }
        public List<object> UniqueName { get; set; }
        public List<object> SubUserStoryStatus { get; set; }
        public List<List<object>> UserStoryStatus { get; set; }
        public List<object> SubStatusColors { get; set; }
        public List<List<object>> StatusColor { get; set; }
        public List<object> SubDates { get; set; }
        public List<object> SubSpentTime { get; set; }
        public List<string> Date { get; set; }
        public List<List<object>> SpentTime { get; set; }
        public List<object> SubSummaryValue { get; set; }
        public List<List<object>> SummaryValue { get; set; }
        public List<object> SubTotalSpentTimeSoFar { get; set; }
        public List<List<object>> TotalSpentTimeSoFar { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", DeveloperName   = " + DeveloperName);
            stringBuilder.Append(", UserStoryName   = " + UserStoryName);
            stringBuilder.Append(", UserStoryName   = " + UserStoryId);
            stringBuilder.Append(", UserStoryName   = " + UniqueName);
            stringBuilder.Append(", UserStoryStatus  = " + UserStoryStatus);
            stringBuilder.Append(", SpentTime  = " + SpentTime);
            stringBuilder.Append(", StatusColor  = " + StatusColor);
            stringBuilder.Append(", SubSummaryValue  = " + SubSummaryValue);
            stringBuilder.Append(", SummaryValue  = " + SummaryValue);
            stringBuilder.Append(", SubTotalSpentTimeSoFar  = " + SubTotalSpentTimeSoFar);
            stringBuilder.Append(", TotalSpentTimeSoFar  = " + TotalSpentTimeSoFar);
            stringBuilder.Append(", Date   = " + Date);
            return stringBuilder.ToString();
        }
    }
}