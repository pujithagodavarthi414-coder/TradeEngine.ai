using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.TradeManagement
{
    public class ContractTemplateModel
    {
        public Guid? ContractTemplateId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid ContractTypeId { get; set; }
        public Guid TermsAndConditionId { get; set; }   
        public string ContractTemplateName { get; set; }
        public string ContractTemplateFormJson { get; set; }
        public string FinalContractTemplateFormJson { get; set; }
        public string FormBgColor { get; set; }
        public string FormKeys { get; set; }
        public DateTime InActiveDateTime { get; set; }    
        public DateTime? CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public bool IsArchived { get; set; }
        public int TotalCount { get; set; }
        public object Fields { get; set; }
        public byte[] TimeStamp { get; set; }
        public string TemplateIds { get; set; }
    }

    public class FinalTemplateModel
    {
        public string ContractTemplateJson { get; set; }
        public Guid ContractTypeId { get; set; }
        public Guid TermsAndConditionId { get; set; }
        public Guid? ContractTemplateId { get; set; }

    }
}
