using Btrak.Models.ActivityTracker;
using System;

namespace Btrak.Models.MSMQ
{
    public class TrackerActivityPublishModel
    {
        public InsertUserActivityInputModel ActivityInputModel { get; set; }
        public Guid? LoggedInUser { get; set; }
        public int RetryCount { get; set; }
    }
}
