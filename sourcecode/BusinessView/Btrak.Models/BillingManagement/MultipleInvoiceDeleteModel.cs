using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class MultipleInvoiceDeleteModel : InputModelBase
    {
        public MultipleInvoiceDeleteModel() : base(InputTypeGuidConstants.MultipleInvoiceDeleteCommandTypeGuid)
        {
        }

        public List<Guid> InvoiceId { get; set; }
        public string InvoiceIdXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceIdXml" + InvoiceIdXml);
            stringBuilder.Append("InvoiceId" + InvoiceId);
            return stringBuilder.ToString();
        }
    }
}
