using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceItemsOutputModel
    {
        public Guid? InvoiceItemId { get; set; }
        public Guid? InvoiceId { get; set; }
        public string ItemName { get; set; }
        public string ItemDescription { get; set; }
        public double Price { get; set; }
        public double Quantity { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceItemId" + InvoiceItemId);
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("ItemName" + ItemName);
            stringBuilder.Append("ItemDescription" + ItemDescription);
            stringBuilder.Append("Price" + Price);
            stringBuilder.Append("Quantity" + Quantity);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}
