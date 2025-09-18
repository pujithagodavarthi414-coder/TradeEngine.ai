using System;
using System.Text;

namespace Btrak.Models.PaymentMethod
{
    public class PaymentMethodOutputModel
    {
        public Guid? PaymentMethodId { get; set; }
        public Guid? CompanyId { get; set; }
        public string PaymentMethodName { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PaymentMethodId = " + PaymentMethodId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", PaymentMethodName = " + PaymentMethodName);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
