using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GRD
{
    public class CreditNoteSearchOutputModel
    {
        public Guid? Id { get; set; }
        public Guid SiteId { get; set; }
        public string SiteName { get; set; }
        public Guid GrdId { get; set; }
        public string GrdName { get; set; }
        public string Name { get; set; }
        public DateTime Month { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public DateTime EntryDate { get; set; }
        public string Term { get; set; }
        public string InvoiceUrl { get; set; }
        public DateTime Year { get; set; }
        public bool? IsTVAApplied { get; set; }
        public bool? IsGenerateInvoice { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
