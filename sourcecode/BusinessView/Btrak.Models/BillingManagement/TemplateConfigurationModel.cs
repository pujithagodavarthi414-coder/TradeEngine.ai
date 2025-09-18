using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.BillingManagement
{
    public class TemplateConfigurationModel
    {
        public Guid? TemplateConfigurationId { get; set; }
        public string TemplateConfigurationName { get; set; }
        public string TemplateConfiguration { get; set; }
        public Guid LegalEntityId { get; set; }
        public Guid ClientTypeId { get; set; }
        public DateTime InActiveDateTime { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
        public string ContractTypeIds { get; set; }
    }
}
