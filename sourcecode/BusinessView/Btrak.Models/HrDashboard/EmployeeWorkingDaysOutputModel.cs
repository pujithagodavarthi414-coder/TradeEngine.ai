using System;
using System.Text;

namespace Btrak.Models.HrDashboard
{
    public class EmployeeWorkingDaysOutputModel
    {
        public Guid UserId { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string SurName { get; set; }
        public string FullName { get; set; }
        public string ProfileImage { get; set; }
        public int? TotalDays { get; set; }
        public int? WorkingDays { get; set; }
        public decimal Absents { get; set; }
        public int? LateDays { get; set; }
        public decimal WorkedDays { get; set; }
        public int? Holidays { get; set; }
        public int? WeekOffDays { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeName = " + EmployeeName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", FullName = " + FullName);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", TotalDays = " + TotalDays);
            stringBuilder.Append(", WorkingDays = " + WorkingDays);
            stringBuilder.Append(", Absents = " + Absents);
            stringBuilder.Append(", LateDays = " + LateDays);
            stringBuilder.Append(", WorkedDays = " + WorkedDays);
            stringBuilder.Append(", Holidays = " + Holidays);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
