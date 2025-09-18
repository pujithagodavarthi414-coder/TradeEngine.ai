using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TimeSheet
{
    public class TimeSheetPermissionReasonInputModel : InputModelBase
    {
        public TimeSheetPermissionReasonInputModel() : base(InputTypeGuidConstants.TimeSheetInputCommandTypeGuid)
        {
        }
        public Guid? PermissionReasonId { get; set; }
        public string PermissionReason { get; set; }
        public bool? IsArchived { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", PermissionReasonId = " + PermissionReasonId);
            stringBuilder.Append(", PermissionReason = " + PermissionReason);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
