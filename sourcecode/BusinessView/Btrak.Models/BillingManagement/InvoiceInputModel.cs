using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceInputModel : SearchCriteriaInputModelBase
    {
        public InvoiceInputModel() : base(InputTypeGuidConstants.InvoiceInputCommandTypeGuid)
        {
        }

        public Guid? InvoiceId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? BranchId { get; set; }
        public bool? IsArchived { get; set; }
        public string SearchText { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("BranchId" + BranchId);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("SearchText" + SearchText);
            return base.ToString();
        }
    }
}
