using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GRD
{
    public class PaymentReceiptUpsertInputModel : InputModelBase
    {
        public PaymentReceiptUpsertInputModel() : base(InputTypeGuidConstants.PaymentReceiptUpsertInputModelCommandTypeGuid)
        {
		}
		public Guid? Id { get; set; }
		public DateTime EntryDate { get; set; }
		public DateTime Month { get; set; }
		public DateTime Year { get; set; }
		public string Term { get; set; }
		public Guid SiteId { get; set; }
		public Guid BankId { get; set; }
		public string BankReference { get; set; }
		public string Comments { get; set; }
		public string CreditNoteIds { get; set; }
		public string EntryFormIds { get; set; }
		public DateTime BankReceiptDate { get; set; }
		public bool IsArchived { get; set; }
		public decimal PayValue { get; set; }
	}
}
