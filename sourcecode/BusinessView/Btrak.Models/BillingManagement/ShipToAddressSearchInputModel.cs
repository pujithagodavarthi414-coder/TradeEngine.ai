using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class ShipToAddressSearchInputModel:SearchCriteriaInputModelBase
    {
        public ShipToAddressSearchInputModel() : base(InputTypeGuidConstants.ShipToAddressInputCommandTypeGuid)
        {
        }
        public Guid? AddressId { get; set; }
        public bool? IsShiptoAddress { get; set; }
        public Guid? ClientId { get; set; }
        public bool? IsVerified { get; set; }
    }
}
