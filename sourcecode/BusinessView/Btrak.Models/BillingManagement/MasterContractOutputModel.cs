using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class MasterContractOutputModel
    {
        public Guid? ProductId { get; set; }
        public Guid? ContractFormId { get; set; }
        public Guid? CompanyId { get; set; }
        public string ContractName { get; set; }
        public string CounterParty { get; set; }
        public string ContractUniqueName { get; set; }
        public string SearchText { get; set; }
        public string Description { get; set; }
        public string Grade { get; set; }
        public string ContractNumber { get; set; }
        public string Product { get; set; }
        public Guid? GradeId { get; set; }
        public decimal RateOrTon { get; set; }
        public decimal Price { get; set; }
        public int ContractQuantity { get; set; }
        public int RemaningQuantity { get; set; }
        public int UsedQuantity { get; set; }
        public bool KYCCompleted { get; set; }
        public int AvailableCreditLimit { get; set; }
        public byte[] TimeStamp { get; set; }
        public DateTime? ContractDateFrom { get; set; }
        public DateTime? ContractDateTo { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? ContractId { get; set; }
        public Guid? BuyerId { get; set; }
        public Guid? CounterPartyId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string ContractDocument { get; set; }
        public int TotalCount { get; set; }
        public string ShipToAddress { get; set; }
        public string GstNumber { get; set; }
        public string Email { get; set; }
        public string Receipts { get; set; }


    }
}
