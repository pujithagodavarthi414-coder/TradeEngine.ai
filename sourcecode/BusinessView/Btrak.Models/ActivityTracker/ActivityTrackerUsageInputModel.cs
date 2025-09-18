using System;

namespace Btrak.Models.ActivityTracker
{
    public class ActivityTrackerUsageInputModel
    {
        public Guid? UserId { get; set; }
        public DateTime? UsageDate { get; set; }
        public bool GetIds { get; set; }
    }
}