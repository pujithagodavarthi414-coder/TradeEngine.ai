using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.HrDashboard
{
    public class LateEmployeeCountOutputModel
    {
        public DateTime? Date { get; set; }
        public int? TotalCount { get; set; }
        public int? MorningLateCount { get; set; }
        public int? LunchbreakLateCount { get; set; }
        public int? MorningLatePermissionCount { get; set; }
        public int? MorningLateExcludingPermissionCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Date = " + Date);
            stringBuilder.Append(", MorningLateCount = " + MorningLateCount);
            stringBuilder.Append(", LunchbreakLateCount = " + LunchbreakLateCount);
            stringBuilder.Append(", MorningLatePermissionCount = " + MorningLatePermissionCount);
            stringBuilder.Append(", MorningLateExcludingPermissionCount = " + MorningLateExcludingPermissionCount);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
