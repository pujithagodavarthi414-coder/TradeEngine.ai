using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class ClientCreditsLedgerSearchInputModel : SearchCriteriaInputModelBase
    {
        public ClientCreditsLedgerSearchInputModel() : base(InputTypeGuidConstants.ClientCreditsSearchInputCommandTypeGuid)
        {
        }
        public Guid ClientId { get; set; }
    }
}
