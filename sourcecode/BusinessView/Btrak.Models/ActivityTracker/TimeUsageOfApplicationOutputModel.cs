using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.ActivityTracker
{
    public class TimeUsageOfApplicationOutputModel
    {
        public List<DateTime> Dates { get; set; }
        public List<TimeUsageOfApplicationSearchOutputModel> TimeUsage { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Names = " + Dates);
            stringBuilder.Append(", Dates = " + TimeUsage);
            return stringBuilder.ToString();
        }
    }
}
