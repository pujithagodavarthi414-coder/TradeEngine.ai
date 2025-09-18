using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceProjectsInputModel : InputModelBase
    {
        public InvoiceProjectsInputModel() : base(InputTypeGuidConstants.InvoiceProjectsInputCommandTypeGuid)
        {
        }

        public Guid? InvoiceProjectId { get; set; }
        public Guid? InvoiceId { get; set; }
        public Guid? ProjectId { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceProjectId" + InvoiceProjectId);
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("ProjectId" + ProjectId);
            stringBuilder.Append("IsArchived" + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
