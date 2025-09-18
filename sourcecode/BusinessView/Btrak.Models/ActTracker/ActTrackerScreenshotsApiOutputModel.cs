using System;
using System.Collections.Generic;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerScreenshotsApiOutputModel
    {
        public DateTime Date { get; set; }
        public bool IsDelete { get; set; }
        public int TotalCount { get; set; }
        public List<ActTrackerUserActivityScreenshotsOutputModel> ScreenshotDetails { get; set; }
        public List<TrackerChartDetails> TrackerChartDetails { get; set; }
    }
}
