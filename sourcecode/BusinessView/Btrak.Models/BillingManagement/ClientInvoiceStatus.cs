using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class ClientInvoiceStatus
    {
        public Guid? InvoiceStatusId { get; set; }
        public string InvoiceStatusName { get; set; }
        public string StatusName { get; set; }
        public string InvoiceStatusColor { get; set; }
        public DateTime InActiveDateTime { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
