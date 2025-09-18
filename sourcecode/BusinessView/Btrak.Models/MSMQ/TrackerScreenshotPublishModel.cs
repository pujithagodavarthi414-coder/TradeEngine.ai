using Btrak.Models.ActivityTracker;
using System;

namespace Btrak.Models.MSMQ
{
    public class TrackerScreenshotPublishModel
    {
        public InsertUserActivityScreenShotInputModel InsertUserActivityScreenShot { get; set; }

        public Guid? LoggedInUser { get; set; }

        public int RetryCount { get; set; }
    }
}
