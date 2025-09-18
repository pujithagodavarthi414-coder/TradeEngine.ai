using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceStatusModel
    {
        public Guid? InvoiceStatusId { get; set; }
        public string InvoiceStatusName { get; set; }
        public string InvoiceStatusColor { get; set; }
        public string SearchText { get; set; }
        public bool IsArchived { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceStatusId" + InvoiceStatusId);
            stringBuilder.Append("InvoiceStatusName" + InvoiceStatusName);
            stringBuilder.Append("InvoiceStatusColor" + InvoiceStatusColor);
            stringBuilder.Append("SearchText" + SearchText);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            return base.ToString();
        }
    }
}