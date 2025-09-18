using System;
using BTrak.Common;

namespace Btrak.Models.TimeSheet
{
    public class TimeSheetPermissionsModel : SearchCriteriaInputModelBase
    {
        public TimeSheetPermissionsModel() : base(InputTypeGuidConstants.TimeSheetPermissionCommandTypeGuid)
        {
        }
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
        public string ProfileImage { get; set; }
    }
}
