using System;
using static BTrak.Common.Enumerators;

namespace Btrak.Models.ActTracker
{
    public class ActivityTrackerConfigModel
    {
        public int ScreenShotFrequency { get; set; }
        public int ScreenShotMultiplier { get; set; }
        public bool IsScreenShot { get; set; }
        public bool IsKeyBoardTracking { get; set; }
        public bool IsMouseTracking { get; set; }
        public bool IsTrack { get; set; }
        public bool TrackApps { get; set; }
        public bool DisableUrls { get; set; }
        public bool CanInsert { get; set; }
        public string ActivityToken { get; set; }
        public DateTime LastHeartBeatTime { get; set; }
        public bool ConsiderPunchCard { get; set; }
        public bool TrackOnlyTime { get; set; }
        public string IpAddress { get; set; }
        public int OffSet { get; set; }
        public string TimeZone { get; set; }
        public bool OfflineTracking { get; set; }
        public bool IsBasicTracking { get; set; }
        public bool IsActiveShift { get; set; }
        public ModeType ModeTypeEnum { get; set; }
        public Guid? ActiveUserId { get; set; }
        public string TimeZoneName { get; set; }
        public string TimeZoneAbbrevation { get; set; }
        public string DeviceId { get; set; }
        public bool CompanyInActive { get; set; }
        public bool RandomScreenshot { get; set; }
        public bool IsTimesheetActive { get; set; }
        public int AllowedIdleTime { get; set; }
    }
}