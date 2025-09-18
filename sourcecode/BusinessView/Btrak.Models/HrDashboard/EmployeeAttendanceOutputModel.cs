using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.HrDashboard
{
    public class EmployeeAttendanceOutputModel
    {
        public List<object> Names { get; set; }
        public List<object> UserIds { get; set; }
        public List<object> Dates { get; set; }
        public List<List<object>> SummaryValue { get; set; }
        public List<List<object>> Summary { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Names = " + Names);
            stringBuilder.Append(", Dates = " + Dates);
            stringBuilder.Append(", UserIds = " + UserIds);
            stringBuilder.Append(", SummaryValue = " + SummaryValue);
            stringBuilder.Append(", Summary = " + Summary);
            return stringBuilder.ToString();
        }
    }
}
