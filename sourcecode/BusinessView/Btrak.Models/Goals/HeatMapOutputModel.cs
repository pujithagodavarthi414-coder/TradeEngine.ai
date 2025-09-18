using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Goals
{
    public class HeatMapOutputModel
    {
        public List<object> UserStoryId { get; set; }
        public List<object> UserStoryName { get; set; }
        public List<object> Dates { get; set; }
        public List<List<object>> SummaryValue { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", Dates = " + Dates);
            stringBuilder.Append(", SummaryValue = " + SummaryValue);
            return stringBuilder.ToString();
        }
    }
}
