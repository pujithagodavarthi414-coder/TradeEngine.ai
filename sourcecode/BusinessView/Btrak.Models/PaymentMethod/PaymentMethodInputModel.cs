using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.PaymentMethod
{
    public class PaymentMethodInputModel : InputModelBase
    {
        public PaymentMethodInputModel() : base(InputTypeGuidConstants.PaymentMethodInputCommandTypeGuid)
        {
        }
        public Guid? PaymentMethodId { get; set; }
        public string PaymentMethodName { get; set; }
        public bool? IsArchived { get; set; }
       
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" PaymentMethodId = " + PaymentMethodId);
            stringBuilder.Append(", PaymentMethodName = " + PaymentMethodName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
