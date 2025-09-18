using System;

namespace Btrak.Models.ActTracker
{
    public class ActivityTrackerUserStatusOutputModel
    {
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public string ProfileImage { get; set; }
        public string RoleName { get; set; }
        public DateTime? ActiveTime { get; set; }
        public bool Status { get; set; }
        public bool IsBreak { get; set; }
        public bool IsLeave { get; set; }
        public int ScreenshotCount { get; set; }
    }
}
