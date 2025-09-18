using System;
using System.Text;

namespace Btrak.Models.CurrencyConversion
{
    public class CurrencyConversionOutputModel
    {
        public Guid? CurrencyConversionId { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? CurrencyFromId { get; set; }
        public Guid? CurrencyToId { get; set; }
        public int? CurrencyRate { get; set; }
        public DateTime? EffectiveDateTime { get; set; }
        public DateTime? InActiveDateTime { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" CurrencyConversionId = " + CurrencyConversionId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", CurrencyFromId = " + CurrencyFromId);
            stringBuilder.Append(", CurrencyToId = " + CurrencyToId);
            stringBuilder.Append(", CurrencyRate = " + CurrencyRate);
            stringBuilder.Append(", EffectiveDateTime = " + EffectiveDateTime);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
