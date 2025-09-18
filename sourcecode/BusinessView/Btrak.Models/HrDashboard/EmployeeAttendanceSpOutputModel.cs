using System;
using System.Text;

namespace Btrak.Models.HrDashboard
{
    public class EmployeeAttendanceSpOutputModel
    {
        public Guid CompanyId { get; set; }
        public string CompanyName { get; set; }
        public Guid UserId { get; set; }
        public string FullName { get; set; }
        public DateTime? Date { get; set; }
        public TimeSpan? InTime { get; set; }
        public TimeSpan? OutTime { get; set; }
        public TimeSpan? LunchBreakStartTime { get; set; }
        public TimeSpan? LunchBreakEndTime { get; set; }
        public bool? IsHoliday { get; set; }
        public bool? IsSunday { get; set; }
        public bool? IsNoShift { get; set; }
        public TimeSpan? DeadlineTime { get; set; }
        public TimeSpan? InTimeStartFrom { get; set; }
        public bool? IsAbsent { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public string LeaveType { get; set; }
        public string LateBy { get; set; }
        public bool? IsActive { get; set; }
        public int? SummaryValue { get; set; }
        public string Summary { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CompanyName = " + CompanyName);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", FullName = " + FullName);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", InTime = " + InTime);
            stringBuilder.Append(", OutTime = " + OutTime);
            stringBuilder.Append(", LunchBreakStartTime = " + LunchBreakStartTime);
            stringBuilder.Append(", LunchBreakEndTime = " + LunchBreakEndTime);
            stringBuilder.Append(", IsHoliday = " + IsHoliday);
            stringBuilder.Append(", IsSunday = " + IsSunday);
            stringBuilder.Append(", IsNoShift = " + IsNoShift);
            stringBuilder.Append(", DeadlineTime = " + DeadlineTime);
            stringBuilder.Append(", InTimeStartFrom = " + InTimeStartFrom);
            stringBuilder.Append(", IsAbsent = " + IsAbsent);
            stringBuilder.Append(", LeaveTypeId = " + LeaveTypeId);
            stringBuilder.Append(", LeaveType = " + LeaveType);
            stringBuilder.Append(", LateBy = " + LateBy);
            stringBuilder.Append(", IsActive = " + IsActive);
            stringBuilder.Append(", SummaryValue = " + SummaryValue);
            stringBuilder.Append(", Summary = " + Summary);
            return stringBuilder.ToString();
        }
    }
}
