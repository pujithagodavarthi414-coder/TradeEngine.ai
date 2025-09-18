using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.ActTracker
{
    public class ActivityTrackerUserConfigurationInputModel : InputModelBase
    {
        public ActivityTrackerUserConfigurationInputModel() : base(InputTypeGuidConstants.ActivityTrackerUserConfigurationInputCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public Guid? AppUrlId { get; set; }
        public Guid UserId { get; set; }
        public Guid EmployeeId { get; set; }
        public int ScreenshotFrequency { get; set; }
        public int Multiplier { get; set; }
        public bool? Track { get; set; }
        public bool? IsTrack { get; set; }
        public bool? IsScreenshot { get; set; }
        public bool? IsKeyboardTracking { get; set; }
        public bool? IsMouseTracking { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", AppUrlId = " + AppUrlId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", ScreenshotFrequency = " + ScreenshotFrequency);
            stringBuilder.Append(", Multiplier = " + Multiplier);
            stringBuilder.Append(", Track = " + Track);
            stringBuilder.Append(", IsTrack = " + IsTrack);
            stringBuilder.Append(", IsScreenshot = " + IsScreenshot);
            stringBuilder.Append(", IsKeyboardTracking = " + IsKeyboardTracking);
            stringBuilder.Append(", IsMouseTracking = " + IsMouseTracking);
            return stringBuilder.ToString();
        }
    }
}