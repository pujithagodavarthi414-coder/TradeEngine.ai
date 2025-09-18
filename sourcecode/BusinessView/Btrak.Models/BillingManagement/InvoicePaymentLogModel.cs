using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoicePaymentLogModel
    {
        public Guid? InvoiceId { get; set; }
        public Guid? InvoicePaymentLogId { get; set; }
        public Guid? PaidAccountToId { get; set; }
        public string PaidAccountToName { get; set; }
        public Guid? PaymentMethodId { get; set; }
        public string PaymentMethodName { get; set; }
        public Decimal Amount { get; set; }
        public string SearchText { get; set; }
        public string ReferenceNumber { get; set; }
        public string Notes { get; set; }
        public bool SendReceiptTo { get; set; }
        public bool IsArchived { get; set; }
        public DateTime? Date { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("InvoicePaymentLogId" + InvoicePaymentLogId);
            stringBuilder.Append("PaidAccountToId" + PaidAccountToId);
            stringBuilder.Append("PaidAccountToName" + PaidAccountToName);
            stringBuilder.Append("PaymentMethodId" + PaymentMethodId);
            stringBuilder.Append("PaymentMethodName" + PaymentMethodName);
            stringBuilder.Append("Amount" + Amount);
            stringBuilder.Append("SearchText" + SearchText);
            stringBuilder.Append("ReferenceNumber" + ReferenceNumber);
            stringBuilder.Append("Notes" + Notes);
            stringBuilder.Append("SendReceiptTo" + SendReceiptTo);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("Date" + Date);
            stringBuilder.Append("CreatedDateTime" + CreatedDateTime);
            return base.ToString();
        }
    }
}
