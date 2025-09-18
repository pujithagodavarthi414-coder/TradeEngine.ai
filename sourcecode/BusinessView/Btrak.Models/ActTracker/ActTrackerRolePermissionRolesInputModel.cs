using System;
using System.Text;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerRolePermissionRolesInputModel
    {
        public bool? IsDeleteScreenShots { get; set; }
        public bool? IsManualEntryTime { get; set; }
        public bool? IsRecordActivity { get; set; }
        public bool? IsIdleTime { get; set; }
        public bool? IsOffileTracking { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", IsDeleteScreenShots = " + IsDeleteScreenShots);
            stringBuilder.Append(", IsManualEntryTime = " + IsManualEntryTime);
            stringBuilder.Append(", IsRecordActivity = " + IsRecordActivity);
            stringBuilder.Append(", IsIdleTime = " + IsIdleTime);
            stringBuilder.Append(", IsOffileTracking = " + IsOffileTracking);
            return stringBuilder.ToString();
        } 
    }
}
