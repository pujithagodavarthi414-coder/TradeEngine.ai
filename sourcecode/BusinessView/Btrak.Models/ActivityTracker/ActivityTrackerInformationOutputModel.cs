using System;

namespace Btrak.Models.ActivityTracker
{
    public class ActivityTrackerInformationOutputModel
    {
        public DateTime StartTime { get; set; }
        public int ScreenShotFrequency { get; set; }
        public int Multiplier { get; set; }
    }
}
