using System;

namespace Btrak.Models.HrManagement
{
    public class ShiftWeekSearchOutputModel
    {
        public Guid? ShiftWeekId { get; set; }
        public string DayOfWeek { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public TimeSpan? StartTime { get; set; }
        public TimeSpan? EndTime { get; set; }
        public TimeSpan? DeadLine { get; set; }
        public int? AllowedBreakTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? ShiftTimingId { get; set; }
        public int? TotalCount { get; set; }
        public bool IsPaidBreak { get; set; }
    }
}
