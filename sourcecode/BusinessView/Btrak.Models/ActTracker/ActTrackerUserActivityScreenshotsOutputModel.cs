using System;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerUserActivityScreenshotsOutputModel
    {
        public Guid ScreenShotId { get; set; }
        public string Name { get; set; }
        public Guid UserId { get; set; }
        public string ProfileImage { get; set; }
        public string RoleName { get; set; }
        public bool IsArchived { get; set; }
        public string Reason { get; set; }
        public string ScreenShotUrl { get; set; }
        public string ScreenShotName { get; set; }
        public string TimeZoneAbbreviation { get; set; }
        public string TimeZoneName { get; set; }
        public string ApplicationName { get; set; }
        public string ApplicationTypeName { get; set; }
        public string ScreenShotDateTime { get; set; }
        public double KeyStroke { get; set; }
        public double MouseMovement { get; set; }
        public bool IsDelete { get; set; }
        public string DeletedByUser { get; set; }
        public bool RecordActivity { get; set; }
        public bool MouseTracking { get; set; }
    }
}
