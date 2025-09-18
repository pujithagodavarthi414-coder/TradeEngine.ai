using System;
using System.Text;

namespace Btrak.Models.HrDashboard
{
    public class EmployeeSpentTimeOutputModel
    {
        public string UserName { get; set; }
        public DateTime? Date { get; set; }
        public string TimeSpent { get; set; }
        public decimal? TotalTimeSpent { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", TimeSpent = " + TimeSpent);
            stringBuilder.Append(", TotalTimeSpent = " + TotalTimeSpent);
            return stringBuilder.ToString();
        }
    }
}
