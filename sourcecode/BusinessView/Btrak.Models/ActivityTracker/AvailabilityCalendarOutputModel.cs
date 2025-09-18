using System;

namespace Btrak.Models.ActivityTracker
{
    public class AvailabilityCalendarOutputModel
    {
        public int Id { get; set; }
        public DateTime Date { get; set; }
        public Guid? UserId { get; set; }
        public bool IsAllDay { get; set; }
        public bool IsBlock { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public string Color { get; set; }
        public string Subject { get; set; }
        public bool IsOnLeave { get; set; }
        public bool IsHoliday { get; set; }
        public bool IsNoShift { get; set; }
    }
}
