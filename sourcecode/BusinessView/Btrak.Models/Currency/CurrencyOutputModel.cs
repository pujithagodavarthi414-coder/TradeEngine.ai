using System;
using System.Text;

namespace Btrak.Models.Currency
{
    public class CurrencyOutputModel
    {
        public Guid? CurrencyId { get; set; }
        public Guid? SysCurrencyId { get; set; }
        public Guid? CompanyId { get; set; }
        public string CurrencyName { get; set; }
        public string CurrencyCode { get; set; }
        public string CurrencySymbol { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" CurrencyId = " + CurrencyId);
            stringBuilder.Append(" SysCurrencyId = " + SysCurrencyId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CurrencyName = " + CurrencyName);
            stringBuilder.Append(", CurrencyCode = " + CurrencyCode);
            stringBuilder.Append(", Symbol = " + CurrencySymbol);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
