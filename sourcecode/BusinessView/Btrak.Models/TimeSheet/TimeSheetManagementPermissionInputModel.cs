using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.TimeSheet
{
    public class TimeSheetManagementPermissionInputModel : SearchCriteriaInputModelBase
    {
        public TimeSheetManagementPermissionInputModel() : base(InputTypeGuidConstants.TimeSheetManagementPermissionInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public Guid? PermissionId { get; set; }
        public DateTime? Date { get; set; }
        public TimeSpan? Duration { get; set; }
        public bool IsMorning { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public Guid? PermissionReasonId { get; set; }
        public Guid? EntityId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", PermissionId = " + PermissionId);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", Duration = " + Duration);
            stringBuilder.Append(", IsMorning = " + IsMorning);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", IsDeleted = " + IsDeleted);
            stringBuilder.Append(", PermissionReasonId = " + PermissionReasonId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
