using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class KycFormHistoryModel
    {
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedUser { get; set; }
        public string ClientName { get; set; }
        public string Description { get; set; }
        public bool IsArchived { get; set; }
        public Guid? ClientId { get; set; }
    }
}
