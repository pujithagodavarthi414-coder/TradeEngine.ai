using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.HrDashboard
{
    public class EmployeeAttendanceApiOutputModel
    {
        public List<object> Names { get; set; }
        public List<object> UserIds { get; set; }
        public List<object> SubDates { get; set; }
        public List<List<object>> Dates { get; set; }
        public List<object> SubSummary { get; set; }
        public List<object> SubSummaryList { get; set; }
        public List<List<object>> SummaryValue { get; set; }
        public List<List<object>> Summary{ get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Names = " + Names);
            stringBuilder.Append(", UserId = " + UserIds);
            stringBuilder.Append(", Dates = " + Dates);
            stringBuilder.Append(", Summary = " + Summary);
            stringBuilder.Append(", SubSummary = " + SubSummary);
            stringBuilder.Append(", SummaryValue = " + SummaryValue);
            return stringBuilder.ToString();
        }
    }
}
