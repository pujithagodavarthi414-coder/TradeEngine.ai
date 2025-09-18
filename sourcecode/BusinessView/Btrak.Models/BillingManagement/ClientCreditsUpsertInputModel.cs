using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class ClientCreditsUpsertInputModel:InputModelBase
    {
        public ClientCreditsUpsertInputModel() : base(InputTypeGuidConstants.ClientCreditsInputCommandTypeGuid)
        {
        }
        public Guid LeadId { get; set; }
        public decimal PaidAmount { get; set; }
        public string InvoiceNumber { get; set; }
    }
}
