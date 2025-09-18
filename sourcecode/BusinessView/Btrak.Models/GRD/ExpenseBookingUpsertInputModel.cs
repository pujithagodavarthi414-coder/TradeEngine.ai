using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GRD
{
    public class ExpenseBookingUpsertInputModel : InputModelBase
    {
		public ExpenseBookingUpsertInputModel() : base(InputTypeGuidConstants.ExpenseBookingUpsertInputModelCommandTypeGuid)
		{
		}
		public Guid? Id { get; set; }
		public string Type { get; set; }
		public string Term { get; set; }
		public string VendorName { get; set; }
		public string InvoiceNo { get; set; }
		public string Description { get; set; }
		public string Comments { get; set; }
		public DateTime EntryDate { get; set; }
		public DateTime Month { get; set; }
		public DateTime Year { get; set; }
		public DateTime InvoiceDate { get; set; }
		public Guid SiteId { get; set; }
		public Guid AccountId { get; set; }
		public bool IsTVAApplied { get; set; }
		public bool IsArchived { get; set; }
		public decimal InvoiceValue { get; set; }
	}
}
