using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Goals
{
    public class HeatMapApiOutputModel
    {
        public List<object> UserStoryName { get; set; }
        public List<object> UserStoryId { get; set; }
        public List<object> Date { get; set; }
        public List<object> SubSummaryValues { get; set; }
        public List<List<object>> SummaryValue { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserStoryName   = " + UserStoryName);
            stringBuilder.Append(", UserStoryName   = " + UserStoryId);
            stringBuilder.Append(", Date   = " + Date);
            stringBuilder.Append(", SummaryValue   = " + SummaryValue);
            return stringBuilder.ToString();
        }
    }
}