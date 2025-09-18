
using System;

namespace Btrak.Models
{
    public class PaymentAndInvoiceOutputModel
    {
        public string InvoiceId { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string Details { get; set; }
        public string Product { get; set; }
        public decimal Amount { get; set; }
        public string Status { get; set; }
        public string InvoiceNumber { get; set; }
        public string PdfUrl { get; set; }
        public decimal AmountDue { get; set; }
    }
}
