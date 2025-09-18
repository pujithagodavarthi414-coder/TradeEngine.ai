using System;
using System.Text;

namespace Btrak.Models.HrDashboard
{
    public class DailyLogTimeReportOutputModel
    {
        public Guid? UserId { get; set; }
        public string EmployeeName { get; set; }
        public string UserProfileImage { get; set; }
        public DateTime? Date { get; set; }
        public string OfficeSpentTime { get; set; }
        public string LoggedSpentTime { get; set; }
        public string Status { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", UserName = " + EmployeeName);
            stringBuilder.Append(", UserProfileImage = " + UserProfileImage);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", SpentTime = " + OfficeSpentTime);
            stringBuilder.Append(", LogTime = " + LoggedSpentTime);
            stringBuilder.Append(", Status = " + Status);
            return stringBuilder.ToString();
        }
    }
}
