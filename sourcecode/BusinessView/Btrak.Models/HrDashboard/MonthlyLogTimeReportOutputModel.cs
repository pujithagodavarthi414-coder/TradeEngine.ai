using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.HrDashboard
{
    public class MonthlyLogTimeReportOutputModel
    {
        public List<object> EmployeeName { get; set; }
        public List<object> UserId { get; set; }
        public List<object> SubDates { get; set; }
        public List<object> SubSummary { get; set; }
        public List<List<object>> SummaryValue { get; set; }
        public List<List<object>> Dates { get; set; }
 
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", EmployeeName = " + EmployeeName);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", Dates = " + Dates);
            stringBuilder.Append(", SummaryValue = " + SummaryValue);
            return stringBuilder.ToString();
        }
    }
}
