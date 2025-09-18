using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.ActTracker
{
    public class ActivityTrackerConfigurationStateInputModel : InputModelBase
    {
        public ActivityTrackerConfigurationStateInputModel() : base(InputTypeGuidConstants.ActivityTrackerConfigurationStateInputCommandTypeGuid)
        {

        }
        public Guid? Id {get;set;}
        public bool IsTracking { get; set; }
        public bool IsBasicTracking { get; set; }
        public bool IsScreenshot { get; set; }
        public bool IsDelete { get; set; }
        public bool DeleteRoles { get; set; }
        public bool IsRecord { get; set; }
        public bool RecordRoles { get; set; }
        public bool IsIdealTime { get; set; }
        public bool IdealTimeRoles { get; set; }
        public bool IsManualTime { get; set; }
        public bool ManualTimeRole { get; set; }
        public bool IsOfflineTracking { get; set; }
        public bool OfflineOpen { get; set; }
        public bool IsMouse { get; set; }
        public bool MouseRoles { get; set; }
        public bool DisableUrls { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append("IsTracking = " + IsTracking);
            stringBuilder.Append("IsScreenshot = " + IsScreenshot);
            stringBuilder.Append("IsDelete = " + IsDelete);
            stringBuilder.Append("DeleteRoles = " + DeleteRoles);
            stringBuilder.Append("IsRecord = " + IsRecord);
            stringBuilder.Append("RecordRoles = " + RecordRoles);
            stringBuilder.Append("IsIdealTime = " + IsIdealTime);
            stringBuilder.Append("IdealTimeRoles = " + IdealTimeRoles);
            stringBuilder.Append("IsManualTime = " + IsManualTime);
            stringBuilder.Append("ManualTimeRole = " + ManualTimeRole);
            stringBuilder.Append("IsOfflineTracking = " + IsOfflineTracking);
            stringBuilder.Append("OfflineOpen = " + OfflineOpen);
            stringBuilder.Append("IsMouse = " + IsMouse);
            stringBuilder.Append("MouseRoles = " + MouseRoles);
            stringBuilder.Append("DisableUrls = " + DisableUrls);
            return stringBuilder.ToString();
        }
    }
}
