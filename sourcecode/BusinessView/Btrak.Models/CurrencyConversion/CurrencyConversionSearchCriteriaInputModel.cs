using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CurrencyConversion
{
    public class CurrencyConversionSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public CurrencyConversionSearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchCurrencyConversion)
        {
        }
        public Guid? FromCurrency { get; set; }
        public Guid? ToCurrency { get; set; }
        public DateTime? EffectiveFrom { get; set; }
        public int? CurrencyRate { get; set; }
        public Guid? CurrencyConversionId { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FromCurrency = " + FromCurrency);
            stringBuilder.Append(", ToCurrency = " + ToCurrency);
            stringBuilder.Append(", EffectiveFrom = " + EffectiveFrom);
            stringBuilder.Append(", CurrencyRate = " + CurrencyRate);
            stringBuilder.Append(", CurrencyConversionId = " + CurrencyConversionId);
            return stringBuilder.ToString();
        }
    }
}
