using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class ReferenceTypeOutputModel
    {
        public Guid? ReferenceTypeId { get; set; }
        public Guid? CompanyId { get; set; }
        public bool? IsArchived { get; set; }
        public string ReferenceTypeName { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" ReferenceTypeId = " + ReferenceTypeId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ReferenceTypeName = " + ReferenceTypeName);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
