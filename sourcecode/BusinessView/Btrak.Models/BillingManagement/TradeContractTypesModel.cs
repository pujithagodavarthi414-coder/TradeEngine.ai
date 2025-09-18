using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class TradeContractTypesModel
    {
        public Guid? ContractTypeId { get; set; }
        public string ContractTypeName { get; set; }
        public string FormJson { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public string CreatedBy { get; set; }
    }
}
