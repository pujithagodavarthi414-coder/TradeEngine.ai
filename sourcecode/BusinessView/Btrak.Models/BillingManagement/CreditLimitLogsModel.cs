using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class CreditLimitLogsModel
    {
        public int OldCreditLimit { get; set; }
        public int NewCreditLimit { get; set; }
        public int OldAvailableCreditLimit { get; set; }
        public int NewAvailableCreditLimit { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedUser { get; set; }
        public string Description { get; set; }
        public string ClientName { get; set; }
        public int Amount { get; set; }
        public bool IsArchived { get; set; }
        public Guid? ClientId { get; set; }
    }
}
