using System;
using System.Collections.Generic;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerScreenshotFrequencySearchOutputModel
    {
        public Guid? Id { get; set; }
        public int ScreenShotFrequency { get; set; }
        public int Multiplier { get; set; }
        public List<string> MACAddress { get; set; }
        public Guid UserId { get; set; }
        public int MinimumIdelTime { get; set; }
        public bool? RandomScreenshot { get; set; }
        public bool? OfflineTracking { get; set; }
    }
}
