using System;
using System.Text;

namespace Btrak.Models.PayRoll
{
    public class RateTagForOutputModel
    {
        public Guid RateTagForId { get; set; }
        public string RateTagForName { get; set; }
        public string RateTagForType { get; set; }
        public Guid? CompanyId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsAllowance { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", RateTagForId = " + RateTagForId);
            stringBuilder.Append(", RateTagForName = " + RateTagForName);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", IsAllowance = " + IsAllowance);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
