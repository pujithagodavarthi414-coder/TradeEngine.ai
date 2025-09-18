using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class ContractSubmissionDetails
    {
        public Guid? ClientId { get; set; }
        public Guid? ContractFormId { get; set; }
        public string ContractUniqueName { get; set; }
        public Guid? ContractId { get; set; }
        public string FullName { get; set; }
        public Guid? CompanyId { get; set; }
        public string SearchText { get; set; }
        public Guid? TemplateId { get; set; }
        public string FormName { get; set; }
        public string FormData { get; set; }
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
