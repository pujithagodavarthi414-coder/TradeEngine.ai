using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class PurchaseShipmentExecutionSearchOutputModel
    {
        public Guid? PurchaseShipmentId { get; set; }
        public Guid? ContractId { get; set; }
        public string ShipmentNumber { get; set; }
        public string ContractNumber { get; set; }
        public string VoyageNumber { get; set; }
        public decimal ShipmentQuantity { get; set; }
        public decimal BLQuantity { get; set; }
        public Guid? VesselId { get; set; }
        public Guid? PortLoadId { get; set; }
        public Guid? PortDischargeId { get; set; }
        public Guid? WorkEmployeeId { get; set; }
        public DateTime? ETADate { get; set; }
        public DateTime? FillDueDate { get; set; }
        public string Product { get; set; }
        public string Grade { get; set; }
        public string StatusName { get; set; }
        public string Color { get; set; }
        public string PortDischargeName { get; set; }
        public string PortLoadName { get; set; }
        public string VesselName { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public int BlsCount { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
