using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceTaxInputModel : InputModelBase
    {
        public InvoiceTaxInputModel() : base(InputTypeGuidConstants.InvoiceTaxInputCommandTypeGuid)
        {
        }

        public Guid? InvoiceTaxId { get; set; }
        public Guid? InvoiceId { get; set; }
        public double Tax { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceTaxId" + InvoiceTaxId);
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("Tax" + Tax);
            stringBuilder.Append("IsArchived" + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
