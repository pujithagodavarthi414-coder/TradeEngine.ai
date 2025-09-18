using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class SCOGenerationsOutputModel : SearchItemsOutputModel
    {
        public Guid? Id { get; set; }
        public Guid? LeadSubmissionId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? CompanyId { get; set; }
        public Guid? UserId { get; set; }
        public string Comments { get; set; }
        public string MobileNumber { get; set; }
        public int CreditsAllocated { get; set; }
        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public bool? IsScoAccepted { get; set; }
        public string ContractNumber { get; set; }
        public string UniqueScoId { get; set; }
        public string UniqueLeadId { get; set; }
        public string SalesPersonName { get; set; }
        public string BuyerName { get; set; }
        public string ProductName { get; set; }
        public string GradeName { get; set; }
        public string VehicleNumberOfTransporter { get; set; }
        public string MobileNumberOfTruckDriver { get; set; }
        public string BLNumber { get; set; }
        public string PaymentTermName { get; set; }
        public string PortName { get; set; }
        public string ShipToAddress { get; set; }
        public string TermsOfDelivery { get; set; }
        public string CountryOfOrigin { get; set; }
        public string CustomPoint { get; set; }
        public string GstCode { get; set; }
        public DateTime ShipmentMonth { get; set; }
        public Guid? ProductId { get; set; }
        public Guid? GradeId { get; set; }
        public Guid? PaymentTypeId { get; set; }
        public Guid? PortId { get; set; }
        public int Drums { get; set; }
        public float RateGst { get; set; }
        public string GstNumber { get; set; }
        public float QuantityInMT { get; set; }
        public DateTime ScoDate { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string Email { get; set; }
        public float NetApprox { get; set; }
        public string InvoiceNumber { get; set; }
        public string DeliveryNote { get; set; }
        public string SuppliersRef { get; set; }
        public string AddressLine1 { get; set; }
        public string AddressLine2 { get; set; }
        public string PanNumber { get; set; }
        public string BusinessEmail { get; set; }
        public string BusinessNumber { get; set; }
        public string EximCode { get; set; }
        public string CompanyName { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
