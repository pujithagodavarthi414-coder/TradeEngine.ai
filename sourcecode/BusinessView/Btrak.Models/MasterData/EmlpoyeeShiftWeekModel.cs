using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class EmlpoyeeShiftWeekModel
    {
        public Guid? EmployeeId { get; set; } 
        public string UserName { get; set; }
        public string DayOfWeek { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? StatusId { get; set; }

    }
    public class EmlpoyeeShiftWeekOutputModel
    {
        public Guid? EmployeeId { get; set; }
        public string UserName { get; set; }
        public string DayOfWeek { get; set; }
        public DateTime? Day { get; set; }
        public string StatusName { get; set; }
        public int? SortOrder { get; set; }
        public int? SpentTime { get; set; }
        public DateTime? InTime { get; set; }
        public DateTime? OutTime { get; set; }
        public string RejectedReason { get; set; }
        public bool? IsRejected { get; set; }
        public string Summary { get; set; }
        public int? Breakmins { get; set; }
        public bool? IsOnLeave { get; set; }
        public string StatusColour { get; set; }
        public DateTime? TimesheetInTime { get; set; }
        public DateTime? TimeSheetOutTime { get; set; }
        public TimeSpan? ShiftInTime { get; set; }
        public TimeSpan? ShiftOutTime { get; set; }
        public TimeSpan? RosterInTime { get; set; }
        public TimeSpan? RosterOutTime { get; set; }
        public string LeaveReason { get; set; }
        public string HolidayReason { get; set; }
        public string ShiftName { get; set; }
        public string RosterName { get; set; }
    }
}
