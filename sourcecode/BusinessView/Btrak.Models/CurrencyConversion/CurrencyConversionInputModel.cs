using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CurrencyConversion
{
    public class CurrencyConversionInputModel : InputModelBase
    {
        public CurrencyConversionInputModel() : base(InputTypeGuidConstants.CurrencyConversionInputCommandTypeGuid)
        {
        }
        public Guid? CurrencyConversionId { get; set; }
        public Guid? FromCurrency { get; set; }
        public Guid? ToCurrency { get; set; }
        public DateTime? EffectiveFrom { get; set; }
        public int? CurrencyRate { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" CurrencyConversionId = " + CurrencyConversionId);
            stringBuilder.Append(", FromCurrency = " + FromCurrency);
            stringBuilder.Append(", ToCurrency = " + ToCurrency);
            stringBuilder.Append(", EffectiveFrom = " + EffectiveFrom);
            stringBuilder.Append(", CurrencyRate = " + CurrencyRate);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
