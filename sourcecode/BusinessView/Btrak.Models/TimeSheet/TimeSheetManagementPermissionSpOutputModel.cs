using System;
using System.Text;

namespace Btrak.Models.TimeSheet
{
    public class TimeSheetManagementPermissionSpOutputModel
    {
        public Guid? UserId { get; set; }
        public Guid? PermissionId { get; set; }
        public DateTime? Date { get; set; }
        public TimeSpan? Duration { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool IsMorning { get; set; }
        public bool IsDeleted { get; set; }
        public decimal? DurationInMinutes { get; set; }
        public decimal? Hours { get; set; }
        public String FullName { get; set; }
        public Guid? ReasonId { get; set; }
        public Guid? PermissionReasonId { get; set; }
        public string ReasonName { get; set; }
        public string PermissionReason { get; set; }
        public int? TotalCount { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public string ProfileImage { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", PermissionId = " + PermissionId);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", Duration = " + Duration);
            stringBuilder.Append(", IsMorning = " + IsMorning);
            stringBuilder.Append(", IsDeleted = " + IsDeleted);
            stringBuilder.Append(", PermissionReasonId = " + PermissionReasonId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", DurationInMinutes = " + DurationInMinutes);
            stringBuilder.Append(", Hours = " + Hours);
            stringBuilder.Append(", FullName = " + FullName);
            stringBuilder.Append(", ReasonId = " + ReasonId);
            stringBuilder.Append(", PermissionReasonId = " + PermissionReasonId);
            stringBuilder.Append(", ReasonName = " + ReasonName);
            stringBuilder.Append(", PermissionReason = " + PermissionReason);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
