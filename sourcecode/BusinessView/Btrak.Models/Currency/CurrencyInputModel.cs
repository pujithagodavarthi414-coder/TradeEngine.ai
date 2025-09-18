using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Currency
{
    public class CurrencyInputModel : InputModelBase
    {
        public CurrencyInputModel() : base(InputTypeGuidConstants.CurrencyInputCommandTypeGuid)
        {
        }
        public Guid? CurrencyId { get; set; }
        public string CurrencyName { get; set; }
        public string CurrencyCode { get; set; }
        public string CurrencySymbol { get; set; }
        public bool? IsArchived { get; set; }
      
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" CurrencyId = " + CurrencyId);
            stringBuilder.Append(", CurrencyName = " + CurrencyName);
            stringBuilder.Append(", CurrencyCode = " + CurrencyCode);
            stringBuilder.Append(", CurrencySymbol = " + CurrencySymbol);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
