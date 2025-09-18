using System;

namespace Btrak.Models.HrDashboard
{
    public class LateEmployeeCountSpOutputModel
    {
        public DateTime? Date { get; set; }
        public int? TotalCount { get; set; }
        public int? MorningLateCount { get; set; }
        public int? LunchbreakLateCount { get; set; }
        public int? MorningLatePermissionCount { get; set; }
        public int? MorningLateExcludingPermissionCount { get; set; }
    }
}
