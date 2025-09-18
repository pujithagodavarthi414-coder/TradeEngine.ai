using System;

namespace Btrak.Models.ActivityTracker
{
    public class TrackerPunchCardInputModel
    {
        public string DeviceId { get; set; }
        public Guid ButtonTypeId { get; set; }
    }
}
