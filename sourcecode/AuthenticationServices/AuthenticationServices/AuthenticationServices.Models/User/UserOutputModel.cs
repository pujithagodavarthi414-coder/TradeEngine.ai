using System;
using System.Text;

namespace AuthenticationServices.Models.User
{
    public class UserOutputModel
    {
        public Guid CompanyId { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string RoleIds { get; set; }
        public bool IsPasswordForceReset { get; set; }
        public string FullName { get; set; }
        public bool IsActive { get; set; }
        public bool IsExternal { get; set; }
        public Guid? TimeZoneId { get; set; }
        public string MobileNo { get; set; }
        public bool IsAdmin { get; set; }
        public bool IsActiveOnMobile { get; set; }
        public string ProfileImage { get; set; }
        public DateTime? LastConnection { get; set; }
        public DateTime? RegisteredDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public string RoleName { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public bool? IsDemoDataCleared { get; set; }
        public bool IsToShowDeleteIcon { get; set; }
        public Guid? Id { get; set; }
        public Guid? EmployeeId { get; set; }
        public string EmployeeNumber { get; set; }
        public string ProductivityIndex { get; set; }
        public string LeavesRemaining { get; set; }
        public string ApprovedLeaves { get; set; }
        public string TimeZoneName { get; set; }
        public Guid? UserId { get; set; }
        public string Language { get; set; }
        public string CompanyLanguage { get; set; }
        public string TimeZoneTitle { get; set; }
        public string TimeZoneAbbreviation { get; set; }
        public string CountryCode { get; set; }
        public string CountryName { get; set; }
        public string TimeZone { get; set; }
        public string TimeZoneOffset { get; set; }
        public int OffsetMinutes { get; set; }
        public Guid? DesktopId { get; set; }
        public string DesktopName { get; set; }

        public bool TrackEmployee { get; set; }
        public Guid? ActivityTrackerUserId { get; set; }
        public Guid? ActivityTrackerAppUrlTypeId { get; set; }
        public int ScreenShotFrequency { get; set; }
        public int Multiplier { get; set; }
        public bool? IsTrack { get; set; }
        public bool? IsScreenshot { get; set; }
        public bool? IsKeyboardTracking { get; set; }
        public bool? IsMouseTracking { get; set; }
        public byte[] ATUTimeStamp { get; set; }
        public bool Status { get; set; }
        public bool IsBreak { get; set; }
        public bool IsOnline { get; set; }
        public bool IsLeave { get; set; }
        public string ModuleIds { get; set; }
        public string ModuleNames { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? LastDate { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", FirstName = " + FirstName);
            stringBuilder.Append(", SurName = " + SurName);
            stringBuilder.Append(", Email = " + Email);
            stringBuilder.Append(", Password = " + Password);
            stringBuilder.Append(", RoleIds = " + RoleIds);
            stringBuilder.Append(", IsPasswordForceReset = " + IsPasswordForceReset);
            stringBuilder.Append(", IsActive = " + IsActive);
            stringBuilder.Append(", TimeZoneId = " + TimeZoneId);
            stringBuilder.Append(", MobileNo = " + MobileNo);
            stringBuilder.Append(", IsAdmin = " + IsAdmin);
            stringBuilder.Append(", IsActiveOnMobile = " + IsActiveOnMobile);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", LastConnection = " + LastConnection);
            stringBuilder.Append(", RegisteredDateTime = " + RegisteredDateTime);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", RoleName = " + RoleName);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", Id = " + Id);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeNumber = " + EmployeeNumber);
            stringBuilder.Append(", ProductivityIndex = " + ProductivityIndex);
            stringBuilder.Append(", Language = " + Language);
            stringBuilder.Append(", CompanyLanguage = " + CompanyLanguage);

            stringBuilder.Append(", TrackEmployee = " + TrackEmployee);
            stringBuilder.Append(", ActivityTrackerUserId = " + ActivityTrackerUserId);
            stringBuilder.Append(", ActivityTrackerAppUrlTypeId = " + ActivityTrackerAppUrlTypeId);
            stringBuilder.Append(", ScreenShotFrequency = " + ScreenShotFrequency);
            stringBuilder.Append(", Multiplier = " + Multiplier);
            stringBuilder.Append(", IsTrack = " + IsTrack);
            stringBuilder.Append(", IsScreenshot = " + IsScreenshot);
            stringBuilder.Append(", IsKeyboardTracking = " + IsKeyboardTracking);
            stringBuilder.Append(", IsMouseTracking = " + IsMouseTracking);
            stringBuilder.Append(", ATUTimeStamp = " + ATUTimeStamp);

            return stringBuilder.ToString();
        }
    }
}
