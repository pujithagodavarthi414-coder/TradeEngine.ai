using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.ActivityTracker
{
    public class ActivityTrackerTokenInputModel : InputModelBase
    {
        public ActivityTrackerTokenInputModel() : base(InputTypeGuidConstants.ActivityTrackerTokenInputCommandTypeGuid)
        {

        }

        public Guid? UserId { get; set; }
        public string DeviceId { get; set; }
        public string ActivityToken { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append("ActivityToken = " + ActivityToken);
            return stringBuilder.ToString();
        }
    }
}
