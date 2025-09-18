using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class PurchaseShipmentExecutionSearchInputModel : SearchCriteriaInputModelBase
    {
        public PurchaseShipmentExecutionSearchInputModel() : base(InputTypeGuidConstants.PurchaseShipmentExecutionInputCommandTypeGuid)
        {
        }

        public Guid? PurchaseShipmentId { get; set; }
        public Guid? PurchaseShipmentBLId { get; set; }
    }
}
