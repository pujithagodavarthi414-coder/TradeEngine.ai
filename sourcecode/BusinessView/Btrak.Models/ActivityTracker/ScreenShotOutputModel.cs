using System;

namespace Btrak.Models.ActivityTracker
{
    public class ScreenShotOutputModel
    {
        public string ScreenShotUrl { get; set; }
        public string ScreenShotDate { get; set; }
        public string FileName { get; set; }
        public string TimeZoneName { get; set; }
        public string TimeZoneAbbrevation { get; set; }
        public bool ScreenCast { get; set; }
    }
}
