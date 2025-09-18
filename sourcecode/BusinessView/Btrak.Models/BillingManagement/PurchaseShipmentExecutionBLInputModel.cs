using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class PurchaseShipmentExecutionBLInputModel : InputModelBase
    {
        public PurchaseShipmentExecutionBLInputModel() : base(InputTypeGuidConstants.PurchaseShipmentExecutionInputCommandTypeGuid)
        {
        }
		public string BLNumber {get; set;}
		public Guid PurchaseExecutionId { get; set;}
		public DateTime BLDate {get; set;}
		public decimal BLQuantity {get; set;}
		public Guid? ChaId {get; set;}
		public Guid? ConsignerId {get; set;}
		public Guid? ConsigneeId {get; set;}
		public string NotifyParty {get; set;}
		public string PackingDetails {get; set;}
		public bool? IsDocumentsSent {get; set;}
		public DateTime? SentDate {get; set;}
		public DateTime? DraftEntryDate {get; set;}
		public string DraftBLNumber {get; set;}
		public string DraftBLDescription {get; set;}
		public string DraftBasicCustomsDuty {get; set;}
		public decimal DraftSWC {get; set;}
		public decimal DraftIGST {get; set;}
		public decimal DraftEduCess {get; set;}
		public decimal DraftOthers {get; set;}
		public DateTime? ConfoEntryDate {get; set;}
		public string ConfoBLNumber {get; set;}
		public string ConfoBLDescription {get; set;}
		public string ConfoBasicCustomsDuty {get; set;}
		public decimal ConfoSWC {get; set;}
		public decimal ConfoIGST {get; set;}
		public decimal ConfoEduCess {get; set;}
		public decimal ConfoOthers {get; set;}
		public string IsConfirmedBill {get; set;}
		public string InitialDocumentsDescriptionsXml { get; set;}
		public string FinalDocumentsDescriptionsXml { get; set;}
		public List<InitialDocumentsDescription> InitialDocumentsDescription { get; set;}
		public List<InitialDocumentsDescription> FinalDocumentsDescription { get; set;}
		public DateTime? ConfirmationDate {get; set;}
		public bool? ConfoIsPaymentDone {get; set;}
		public DateTime? ConfoPaymentDate {get; set;}
		public bool IsArchived {get; set;}
		public bool? IsInitialDocumentsMail {get; set;}
		public Guid? ShipmentBLId {get; set;}
		public string ChaEmail {get; set;}
	}
	public class InitialDocumentsDescription
    {
		public string Description { get; set; }
		public Guid? Id { get; set; }
		public int OrderNumber { get; set; }
	}
}
