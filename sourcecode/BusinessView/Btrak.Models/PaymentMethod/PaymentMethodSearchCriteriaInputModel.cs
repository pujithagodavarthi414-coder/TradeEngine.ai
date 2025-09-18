using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.PaymentMethod
{
    public class PaymentMethodSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public PaymentMethodSearchCriteriaInputModel() : base(InputTypeGuidConstants.SearchPaymentMethod)
        {
        }
        public Guid? PaymentMethodId { get; set; }
        public string PaymentMethodNameSearchText { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PaymentMethodId = " + PaymentMethodId);
            stringBuilder.Append(", PaymentMethodNameSearchText = " + PaymentMethodNameSearchText);
            return stringBuilder.ToString();
        }
    }
}
