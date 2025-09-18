using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class FormfieldWorkFlowModel
    {
        public Guid? Id { get; set; }
        public Guid? FormTypeId { get; set; }
        public Guid? GenericFormKeyId { get; set; }
        public string FormName { get; set; }
        public string WorkflowName { get; set; }

        public string WorkflowTrigger { get; set; }
        public string FormJson { get; set; }
        public bool IsArchived { get; set; }
        public string FormKeys { get; set; }
        public bool? IsAbleToLogin { get; set; }
        public bool? IsAbleToComment { get; set; }
        public bool? IsAbleToPay { get; set; }
        public bool? IsAbleToCall { get; set; }
        public Guid[] RoleForComment { get; set; }
        public Guid[] RoleForPay { get; set; }
        public Guid[] RoleForCall { get; set; }
        public Guid? CompanyModuleId { get; set; }
        public string FormIds { get; set; }
        public string FormIdsXml { get; set; }
        public string CompanyIds { get; set; }
    }
}
