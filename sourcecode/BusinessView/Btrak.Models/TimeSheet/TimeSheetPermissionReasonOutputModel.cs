using System;
using System.Text;

namespace Btrak.Models.TimeSheet
{
    public class TimeSheetPermissionReasonOutputModel
    {
        public Guid? Id { get; set; }
        public string PermissionReason { get; set; }
        public Guid CompanyId { get; set; }
        public bool? IsArchived { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public int TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Id = " + Id);
            stringBuilder.Append(", ReasonName = " + PermissionReason);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
