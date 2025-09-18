using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class SendSCOAcceptanceMailInputModel
    {
        public Guid LeadId { get; set; }
        public string Email { get; set; }
        public string MobileNo { get; set; }
        public string UserName { get; set; }
        public Guid? UserId { get; set; }
    }
}
