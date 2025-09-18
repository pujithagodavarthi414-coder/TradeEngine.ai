using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class ShipToAddressUpsertInputModel:InputModelBase
    {
        public ShipToAddressUpsertInputModel() : base(InputTypeGuidConstants.ShipToAddressInputCommandTypeGuid)
        {
        }
        public Guid? AddressId { get; set; }
        public Guid? ClientId { get; set; }
        public string AddressName { get; set; }
        public string Description { get; set; }
        public string Comments { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsShiptoAddress { get; set; }
        public bool? IsVerified { get; set; }
    }
}
