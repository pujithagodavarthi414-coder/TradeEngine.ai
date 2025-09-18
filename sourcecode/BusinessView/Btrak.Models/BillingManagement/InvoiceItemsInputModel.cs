using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceItemsInputModel : InputModelBase
    {
        public InvoiceItemsInputModel() : base(InputTypeGuidConstants.InvoiceItemsInputCommandTypeGuid)
        {
        }

        public Guid? InvoiceItemId { get; set; }
        public Guid? InvoiceId { get; set; }
        public string ItemName { get; set; }
        public string ItemDescription { get; set; }
        public decimal Price { get; set; }
        public decimal Quantity { get; set; }
        public decimal Total { get; set; }
        public bool IsArchived { get; set; }
        public int Order { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceItemId" + InvoiceItemId);
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("ItemName" + ItemName);
            stringBuilder.Append("ItemDescription" + ItemDescription);
            stringBuilder.Append("Price" + Price);
            stringBuilder.Append("Quantity" + Quantity);
            stringBuilder.Append("Total" + Total);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("Order" + Order);
            return base.ToString();
        }
    }
}
