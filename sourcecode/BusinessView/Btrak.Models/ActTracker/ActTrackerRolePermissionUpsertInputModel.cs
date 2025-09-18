using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerRolePermissionUpsertInputModel : InputModelBase
    {
        public ActTrackerRolePermissionUpsertInputModel() : base(InputTypeGuidConstants.ActTrackerRolePermissionUpsertInputCommandTypeGuid)
        {
        }

        public List<Guid?> RoleId { get; set; }
        public int? IdleScreenShotCaptureTime { get; set; }
        public int? IdleAlertTime { get; set; }
        public int? MinimumIdelTime { get; set; }
        public bool? IsDeleteScreenShots { get; set; }
        public bool? IsManualEntryTime { get; set; }
        public bool? IsRecordActivity { get; set; }
        public bool? IsIdleTime { get; set; }
        public bool? IsOfflineTracking { get; set; }
        public bool? IsMouseActivity { get; set; }
        public string RoleIdXml { get; set; }
        public List<Guid?> ConfiguredRoleIds { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("RoleIds = " + RoleId);
            stringBuilder.Append(", IdleScreenShotCaptureTime = " + IdleScreenShotCaptureTime);
            stringBuilder.Append(", IdleAlertTime = " + IdleAlertTime);
            stringBuilder.Append(", MinimumIdelTime = " + MinimumIdelTime);
            stringBuilder.Append(", IsDeleteScreenShots = " + IsDeleteScreenShots);
            stringBuilder.Append(", IsManualEntryTime = " + IsManualEntryTime);
            stringBuilder.Append(", IsRecordActivity = " + IsRecordActivity);
            stringBuilder.Append(", IsIdleTime = " + IsIdleTime);
            stringBuilder.Append(", IsOfflineTracking = " + IsOfflineTracking);
            stringBuilder.Append(", IsMouseActivity = " + IsMouseActivity);
            stringBuilder.Append(", RoleIdXml = " + RoleIdXml);
            stringBuilder.Append(", ConfiguredRoleIds = " + ConfiguredRoleIds);
            return stringBuilder.ToString();
        }
    }
}
