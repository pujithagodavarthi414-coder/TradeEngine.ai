using System;

namespace Btrak.Models.ActivityTracker
{
    public class ActivityTrackerScreenShotValidationModel
    {
        public Guid UserId { get; set; }
        public string MAC { get; set; }
        public Guid CompanyId { get; set; }
        public bool CanAcceptScreenShot { get; set; }
        public string ActivityToken { get; set; }
        public string TimeZoneName { get; set; }
        public string TimeZoneAbbrevation { get; set; }

    }
}