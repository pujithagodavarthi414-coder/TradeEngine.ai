using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Goals
{
    public class DeveloperSpentTimeReportOutputModel
    {
        public List<object> DeveloperName { get; set; }
        public List<object> UserStoryName { get; set; }
        public List<object> UserStoryId { get; set; }
        public List<object> UserStoryStatus { get; set; }
        public List<object> StatusColor { get; set; }
        public List<object> Date { get; set; }
        public List<object> SpentTime { get; set; }
        public List<object> SummaryValue { get; set; }
        public List<object> TotalSpentTimeSoFar { get; set; }
        public List<object> UniqueName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", DeveloperName   = " + DeveloperName);
            stringBuilder.Append(", UniqueName   = " + UniqueName);
            stringBuilder.Append(", UserStoryName   = " + UserStoryName); 
            stringBuilder.Append(", UserStoryName   = " + UserStoryId);
            stringBuilder.Append(", UserStoryStatus  = " + UserStoryStatus);
            stringBuilder.Append(", SpentTime  = " + SpentTime);
            stringBuilder.Append(", StatusColor  = " + StatusColor);
            stringBuilder.Append(", SummaryValue  = " + SummaryValue);
            stringBuilder.Append(", TotalSpentTimeSoFar  = " + TotalSpentTimeSoFar);
            stringBuilder.Append(", Date   = " + Date);
            return stringBuilder.ToString();
        }
    }
}
