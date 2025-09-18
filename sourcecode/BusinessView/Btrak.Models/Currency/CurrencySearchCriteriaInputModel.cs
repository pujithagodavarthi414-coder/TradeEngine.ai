using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Currency
{
    public class CurrencySearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public CurrencySearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchCurrency)
        {
        }
        public Guid? CurrencyId { get; set; }
        public string CurrencyCode { get; set; }
        public string CurrencyName { get; set; }
        public string CurrencySymbol { get; set; }
        public string CurrencyNameSearchText { get; set; }
        public string Symbol { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" CurrencyId = " + CurrencyId);
            stringBuilder.Append(", CurrencyCode = " + CurrencyCode);
            stringBuilder.Append(", CurrencyName = " + CurrencyName);
            stringBuilder.Append(", Symbol = " + Symbol);
            stringBuilder.Append(", CurrencySymbol = " + CurrencySymbol);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", CurrencyNameSearchText = " + CurrencyNameSearchText);
            return stringBuilder.ToString();
        }
    }
}
