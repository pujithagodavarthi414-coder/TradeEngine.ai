using System;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerScreenshotsOutputModel
    {
        public DateTime Date { get; set; }
        public bool IsDelete { get; set; }
        public int TotalCount { get; set; }
        public string ScreenshotDetails { get; set; }
        public string TrackerChartDetails { get; set; }
    }
}
