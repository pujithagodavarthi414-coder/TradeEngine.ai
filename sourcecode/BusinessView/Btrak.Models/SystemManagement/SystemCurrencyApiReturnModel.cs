using System;
using System.Text;

namespace Btrak.Models.SystemManagement
{
    public class SystemCurrencyApiReturnModel
    {
        public Guid? CurrencyId { get; set; }
        public string CurrencyName { get; set; }
        public string CurrencyCode { get; set; }
        public string CurrencySymbol { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CurrencyId = " + CurrencyId);
            stringBuilder.Append(", CurrencyName = " + CurrencyName);
            stringBuilder.Append(", CurrencyCode = " + CurrencyCode);
            stringBuilder.Append(", CurrencySymbol = " + CurrencySymbol);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
