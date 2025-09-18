using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Crm.Call
{
    public class OutgoingCallerIdModel
    {
        public string Uri { get; set; }
        public string AccountSid { get; set; }
        public string FriendlyName { get; set; }
        public DateTime? DateUpdated { get; set; }
        public DateTime? DateCreated { get; set; }
        public string Sid { get; set; }
        public string PhoneNumber { get; set; }
    }
}
