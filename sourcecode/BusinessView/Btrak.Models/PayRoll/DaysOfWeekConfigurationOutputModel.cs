using System;

namespace Btrak.Models.PayRoll
{
    public class DaysOfWeekConfigurationOutputModel
    {
        public Guid Id { get; set; }
        public Guid BranchId { get; set; }
        public string BranchName { get; set; }
        public Guid DaysOfWeekId { get; set; }
        public string WeekDayName { get; set; }
        public Guid PartsOfDayId { get; set; }
        public string PartsOfDayName { get; set; }
        public TimeSpan FromTime { get; set; }
        public TimeSpan ToTime { get; set; }
        public bool IsWeekend { get; set; }
        public bool IsBankHoliday { get; set; }
        public DateTime ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
