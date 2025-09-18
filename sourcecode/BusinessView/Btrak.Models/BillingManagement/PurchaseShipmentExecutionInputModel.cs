using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class PurchaseShipmentExecutionInputModel : InputModelBase
    {
        public PurchaseShipmentExecutionInputModel() : base(InputTypeGuidConstants.PurchaseShipmentExecutionInputCommandTypeGuid)
        {
        }

        public Guid? PurchaseShipmentId { get; set; }
        public Guid? ContractId { get; set; }
        public string ShipmentNumber { get; set; }
        public string VoyageNumber { get; set; }
        public decimal ShipmentQuantity { get; set; }
        public decimal BLQuantity { get; set; }
        public Guid? VesselId { get; set; }
        public Guid? PortLoadId { get; set; }
        public Guid? PortDischargeId { get; set; }
        public Guid? WorkEmployeeId { get; set; }
        public DateTime? ETADate { get; set; }
        public DateTime? FillDueDate { get; set; }
        public bool IsArchived { get; set; }
        public bool IsSendNotification { get; set; }
        public Guid? EmployeeId { get; set; }
        public string MobileNo { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeEmailId { get; set; }

    }
}
