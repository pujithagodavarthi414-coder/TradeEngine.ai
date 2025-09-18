using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class SendInvoiceEmailModel : InputModelBase
    {
        public SendInvoiceEmailModel() : base(InputTypeGuidConstants.SendInvoiceEmailCommandTypeGuid)
        {
        }

        public Guid? InvoiceId { get; set; }
        public string BCC { get; set; }
        public string CC { get; set; }
        public List<string> SendTo { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("BCC" + BCC);
            stringBuilder.Append("CC" + CC);
            stringBuilder.Append("SendTo" + SendTo);
            return stringBuilder.ToString();
        }
    }
}
