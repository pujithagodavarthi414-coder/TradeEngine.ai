using System;

namespace Btrak.Models.HrDashboard
{
    public class MonthlyLogTimeReportSpOutputModel
    {
        public Guid? UserId { get; set; }
        public string EmployeeName { get; set; }
        public DateTime? Date { get; set; }
        public decimal? SpentTime { get; set; }
        public decimal? LogTime { get; set; }
        public string SummaryValue { get; set; }
        public string Summary { get; set; }
    }
}
