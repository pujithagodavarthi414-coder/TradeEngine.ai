using System;

namespace Btrak.Models.ActivityTracker
{
    public class ActivityTrackerUserDetailsOutputModel
    {
        public Guid Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string WorkEmail { get; set; }
        public DateTime? TrackStart { get; set; }
    }
}
