using System;
using System.Collections.Generic;

namespace Btrak.Models.ActTracker
{
    public class ActTrackerRolePermissionRolesOutputModel
    {
        public Guid? RoleId { get; set; }
        public string RoleName { get; set; }
        public bool? IsDeleteScreenShots { get; set; }
        public bool? IsRecordActivity { get; set; }
        public bool? IsIdleTime { get; set; }
        public int? IdleAlertTime { get; set; }
        public int? IdleScreenShotCaptureTime { get; set; }
        public int? MinimumIdelTime { get; set; }
        public bool? IsManualEntryTime { get; set; }
        public bool? IsOfflineTracking { get; set; }
        public bool? IsMouseTracking { get; set; }
    }

    public class PermissionRoles
    {
        public List<ActTrackerRoleDropOutputModel> DeleteScreenShotRoleIds { get; set; }
        public List<ActTrackerRoleDropOutputModel> RecordActivityRoleIds { get; set; }
        public List<ActTrackerIdleRolesModel> IdleTimeRoleIds { get; set; }
        public List<ActTrackerRoleDropOutputModel> ManualEntryRoleIds { get; set; }
        public List<ActTrackerRoleDropOutputModel> OfflineTrackingRoleIds { get; set; }
        public List<ActTrackerRoleDropOutputModel> MouseTrackingRoleIds { get; set; }
    }
}