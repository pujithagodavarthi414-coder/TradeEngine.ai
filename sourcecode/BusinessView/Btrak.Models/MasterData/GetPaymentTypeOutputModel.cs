using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class GetPaymentTypeOutputModel
    {
        public Guid? PaymentTypeId { get; set; }
        public string PaymentTypeName { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PaymentTypeId = " + PaymentTypeId);  
            stringBuilder.Append(", PaymentTypeName = " + PaymentTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}