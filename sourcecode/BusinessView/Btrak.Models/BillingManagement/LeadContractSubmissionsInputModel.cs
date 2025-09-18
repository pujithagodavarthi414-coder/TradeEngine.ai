using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class LeadContractSubmissionsInputModel : InputModelBase
    {
        public LeadContractSubmissionsInputModel() : base(InputTypeGuidConstants.UpsertLeadContractSubmissionCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public Guid? SalesPersonId { get; set; }
        public DateTime LeadDate { get; set; }
        public Guid? ContractId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? ProductId { get; set; }
        public Guid? GradeId { get; set; }
        public decimal QuantityInMT { get; set; }
        public decimal RateGST { get; set; }
        public Guid? PaymentTypeId { get; set; }
        public string VehicleNumberOfTransporter { get; set; }
        public string MobileNumberOfTruckDriver { get; set; }
        public Guid? PortId { get; set; }
        public int Drums { get; set; }
        public string BLNumber { get; set; }
        public bool ExceptionApprovalRequired { get; set; }
        public int IsClosed { get; set; }
        public Guid? StatusId { get; set; }
        public DateTime? ShipmentMonth { get; set; }
        public Guid? CountryOriginId { get; set; }
        public string TermsOfDelivery { get; set; }
        public string CustomPoint { get; set; }
        public bool IsArchived { get; set; }
        public string InvoiceNumber { get; set; }
        public string DeliveryNote { get; set; }
        public string SuppliersRef { get; set; }
        public string ContractTypeId { get; set; }

    }
}
