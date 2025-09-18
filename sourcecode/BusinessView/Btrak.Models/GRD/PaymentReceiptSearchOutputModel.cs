using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GRD
{
    public class PaymentReceiptSearchOutputModel
	{
		public Guid? Id { get; set; }
		public DateTime EntryDate { get; set; }
		public DateTime Month { get; set; }
		public DateTime Year { get; set; }
		public string Term { get; set; }
		public Guid SiteId { get; set; }
		public Guid BankId { get; set; }
		public string BankReference { get; set; }
		public string SiteName { get; set; }
		public string BankAccountName { get; set; }
		public string CreditNoteNames { get; set; }
		public string EntryFormNames { get; set; }
		public string CreditNoteIds { get; set; }
		public string EntryFormIds { get; set; }
		public string Comments { get; set; }
		public DateTime BankReceiptDate { get; set; }
		public decimal PayValue { get; set; }
		public byte[] TimeStamp { get; set; }
	}
}
