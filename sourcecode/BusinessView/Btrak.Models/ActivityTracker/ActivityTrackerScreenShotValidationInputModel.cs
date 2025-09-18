using System;
using System.Collections.Generic;

namespace Btrak.Models.ActivityTracker
{
    public class ActivityTrackerScreenShotValidationInputModel
    {
        public Guid? UserId { get; set; }
        public string DeviceId { get; set; }
        public DateTimeOffset? ScreenShotDate { get; set; }

        public string MacAddresses { get; set; }
        public string TimeZone { get; set; }
    }
}