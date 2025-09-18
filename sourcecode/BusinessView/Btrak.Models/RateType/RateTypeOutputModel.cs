using System;
using System.Text;

namespace Btrak.Models.RateType
{
    public class RateTypeOutputModel
    {
        public Guid? RateTypeId { get; set; }
        public string TypeName { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public bool? IsArchived { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" RateTypeId = " + RateTypeId);
            stringBuilder.Append(", Type = " + TypeName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
