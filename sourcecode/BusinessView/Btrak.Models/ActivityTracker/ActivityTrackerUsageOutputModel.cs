using System;

namespace Btrak.Models.ActivityTracker
{
    public class ActivityTrackerUsageOutputModel
    {
        public DateTime MinTrackedDateTime { get; set; }
        public DateTime MaxTrackedDateTime { get; set; }
        public int TotalIdleTime { get; set; }
        public int TimeGaps { get; set; }
        public string ApplicationName { get; set; }
        public int UserActivityTime { get; set; }
        public string IdsXml { get; set; }
    }
}