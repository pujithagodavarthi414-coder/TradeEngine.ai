using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class PurchaseShipmentExecutionBLSearchOutputModel
    {

		public string BLNumber { get; set; }
		public DateTime? BLDate { get; set; }
		public decimal BLQuantity { get; set; }
		public Guid? ChaId { get; set; }
		public Guid? ConsignerId { get; set; }
		public Guid? ConsigneeId { get; set; }
		public string NotifyParty { get; set; }
		public string PackingDetails { get; set; }
		public bool? IsDocumentsSent { get; set; }
		public DateTime? SentDate { get; set; }
		public DateTime? DraftEntryDate { get; set; }
		public string DraftBLNumber { get; set; }
		public string DraftBLDescription { get; set; }
		public string DraftBasicCustomsDuty { get; set; }
		public decimal DraftSWC { get; set; }
		public decimal DraftIGST { get; set; }
		public decimal DraftEduCess { get; set; }
		public decimal DraftOthers { get; set; }
		public DateTime? ConfoEntryDate { get; set; }
		public string ConfoBLNumber { get; set; }
		public string ConfoBLDescription { get; set; }
		public string ConfoBasicCustomsDuty { get; set; }
		public decimal ConfoSWC { get; set; }
		public decimal ConfoIGST { get; set; }
		public decimal ConfoEduCess { get; set; }
		public decimal ConfoOthers { get; set; }
		public bool? IsConfirmedBill { get; set; }
		public string Receipts { get; set; }
		public string InitialDocumentsDescriptionXml { get; set; }
		public List<InitialDocumentsDescription> InitialDocumentsDescriptions { get; set; }
		public string FinalDocumentsDescriptionXml { get; set; }
		public List<InitialDocumentsDescription> FinalDocumentsDescriptions { get; set; }
		public DateTime? ConfirmationDate { get; set; }
		public bool ConfoIsPaymentDone { get; set; }
		public DateTime? ConfoPaymentDate { get; set; }
		public bool IsArchived { get; set; }
		public Guid? ShipmentBLId { get; set; }
		public Guid? PurchaseShipmentBlId { get; set; }
		public Guid? PurchaseShipmentId { get; set; }

		public string Consignee { get; set; }
		public string Consigner { get; set; }
		public int TotalCount { get; set; }

		public string ShipmentNumber { get; set; }
		public string VoyageNumber { get; set; }
		public string VesselName { get; set; }
		public string Product { get; set; }
		public string Grade { get; set; }
		public string LoadName { get; set; }
		public string DischargeName { get; set; }
		public decimal Price { get; set; }
		public DateTime? ETADate { get; set; }
		public byte[] TimeStamp { get; set; }
		public string FooterMailAddress { get; set; }
	}
}
