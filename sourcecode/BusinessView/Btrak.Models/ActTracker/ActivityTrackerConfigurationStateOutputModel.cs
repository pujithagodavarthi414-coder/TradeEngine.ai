using System;

namespace Btrak.Models.ActTracker
{
    public class ActivityTrackerConfigurationStateOutputModel
    {
        public Guid Id { get; set; }
        public bool IsTracking { get; set; }
        public bool IsBasicTracking { get; set; }
        public bool IsScreenshot { get; set; }
        public bool IsDelete { get; set; }
        public bool DeleteRoles { get; set; }
        public bool IsRecord { get; set; }
        public bool RecordRoles { get; set; }
        public bool IsIdealTime { get; set; }
        public bool IdealTimeRoles { get; set; }
        public bool IsManualTime { get; set; }
        public bool ManualTimeRole { get; set; }
        public bool IsOfflineTracking { get; set; }
        public bool OfflineOpen { get; set; }
        public bool IsMouse { get; set; }
        public bool MouseRoles { get; set; }
        public bool DisableUrls { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
