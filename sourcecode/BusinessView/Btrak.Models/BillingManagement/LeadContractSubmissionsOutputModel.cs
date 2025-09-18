using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class LeadContractSubmissionsOutputModel
    {
        public Guid? Id { get; set; }
        public string UniqueLeadId { get; set; }
        public string UniqueScoId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? ContractId { get; set; }
        public Guid? SalesPersonId { get; set; }
        public DateTime LeadDate { get; set; }
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
        public bool IsSCOActive { get; set; }
        public Guid? StatusId { get; set; }
        public DateTime? ShipmentMonth { get; set; }
        public Guid? CountryOriginId { get; set; }
        public string TermsOfDelivery { get; set; }
        public string CustomPoint { get; set; }
        public bool IsScoAccepted { get; set; }
        public string SalesPersonName { get; set; }
        public string ProductName { get; set; }
        public string GradeName { get; set; }
        public string StatusName { get; set; }
        public string CountryName { get; set; }
        public string ContractNumber { get; set; }
        public string PortName { get; set; }
        public string PaymentTermName { get; set; }
        public string BuyerName { get; set; }
        public string GstNumber { get; set; }
        public int ContractQuantity { get; set; }
        public int RemaningQuantity { get; set; }
        public decimal RateOrTon { get; set; }
        public decimal PaidInvoiceAmount { get; set; }
        public decimal TotalInvoiceAmount { get; set; }
        public Guid? BuyerId { get; set; }
        public DateTime ContractDateFrom { get; set; }
        public DateTime ContractDateTo { get; set; }
        public string ScoDate { get; set; }
        public DateTime ScoCreatedDateTime { get; set; }
        public string ShipToAddress { get; set; }
        public string BuyerEmail { get; set; }
        public string MobileNo { get; set; }
        public string CountryCode { get; set; }
        public string StatusColor { get; set; }
        public string InvoiceNumber { get; set; }
        public bool IsArchived { get; set; }
        public bool KycCompleted { get; set; }
        public int AvailableCreditLimit { get; set; }
        public byte[] TimeStamp { get; set; }
        public string FinalVehicleNumberOfTransporter { get; set; }
        public string FinalMobileNumberOfTruckDriver { get; set; }
        public Guid? FinalPortId { get; set; }
        public int FinalDrums { get; set; }
        public string FinalBLNumber { get; set; }
        public decimal FinalQuantityInMT { get; set; }
        public decimal FinalNetWeightApprox { get; set; }
        public string WeighingSlipNumber { get; set; }
        public string WeighingSlipDate { get; set; }
        public string WeighingSlipPhoto { get; set; }
        public string UploadedOther { get; set; }
        public string WhEmployeeName { get; set; }
        public DateTime? WhUpdatedDateTime { get; set; }
        public Guid? WhUpdatedUserId { get; set; }
        public Guid? CompanyId { get; set; }
        public string PerformaInvoiceNumber { get; set; }
        public string DeliveryNote { get; set; }
        public string SuppliersRef { get; set; }
        public string FinalPortName { get; set; }
        public string ScoPdf { get; set; }
        public string PerformaPdf { get; set; }
        public int TotalCount { get; set; }

    }
}
