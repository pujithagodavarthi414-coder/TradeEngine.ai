using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class ClientTypeOutputModel
    {
        public Guid ClientTypeId { get; set; }
        public string ClientTypeName { get; set; }
        public string RoleIds { get; set; }
        public string RoleNames { get; set; }
        public int Order { get; set; }
        public byte[] TimeStamp { get; set; }

    }
}
