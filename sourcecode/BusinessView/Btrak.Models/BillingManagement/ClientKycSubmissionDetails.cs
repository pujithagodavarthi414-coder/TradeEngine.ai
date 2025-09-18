using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class ClientKycSubmissionDetails
    {
        public Guid? ClientId { get; set; }
        public Guid CompanyId { get; set; }
        public Guid UserId { get; set; }
        public string FormData { get; set; }
        public string FormJson { get; set; }
        public string FullName { get; set; }
        public byte[] TimeStamp { get; set; }
    }
}
