using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class UserStoryStatusReportSearchSpOutputModel
    {
        public string UserStoryName { get; set; }
        public Guid UserStoryId { get; set; }
        public string UserStoryStatus { get; set; }
        public string StatusColour { get; set; }
        public DateTime Date { get; set; }
        public int? SummaryValue { get; set; }
        public string UniqueName { get; set; }
        public string DeveloperName { get; set; }
        public Guid? WorkFlowId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserStoryId   = " + UserStoryId);
            stringBuilder.Append(", UserStoryName   = " + UserStoryName);
            stringBuilder.Append(", UserStoryStatus  = " + UserStoryStatus);
            stringBuilder.Append(", SummaryValue  = " + SummaryValue);
            stringBuilder.Append(", StatusColor  = " + StatusColour);
            stringBuilder.Append(", Date   = " + Date);
            stringBuilder.Append(", UniqueName   = " + UniqueName);
            stringBuilder.Append(", DeveloperName   = " + DeveloperName);
            return stringBuilder.ToString();
        }
    }
}