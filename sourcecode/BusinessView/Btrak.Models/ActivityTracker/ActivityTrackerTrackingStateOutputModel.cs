
namespace Btrak.Models.ActivityTracker
{
    public class ActivityTrackerTrackingStateOutputModel
    {
        public string ActivityToken { get; set; }
        public bool ProcessEnable { get; set; }
        public bool ScreenShotEnable { get; set; }
        public bool KeyboardTracking { get; set; }
        public bool MouseTracking { get; set; }
    }
}
