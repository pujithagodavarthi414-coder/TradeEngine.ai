using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Models.BillingManagement
{
    public class ClientTypeUpsertInputModel : InputModelBase
    {
        public ClientTypeUpsertInputModel() : base(InputTypeGuidConstants.ClientTypeInputCommandTypeGuid)
        {
        }
        public Guid? ClientTypeId { get; set; }
        public string RoleIds { get; set; }
        public string ClientTypeName { get; set; }
        public bool? IsArchived { get; set; }
        public List<Guid?> clientTypeIds { get; set; }
        public string clientTypeIdsXml { get; set; }
    }
}
