

using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.GenericForm
{
    public class FormWorkflowModel : InputModelBase
    {
        public FormWorkflowModel() : base(InputTypeGuidConstants.GenericFormUpsertInputCommandTypeGuid)
        {
        }

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
        public string FormIds { get; set; }
        public string FormIdsXml { get; set; }
        public  bool? IsIncludeTemplateForms { get; set; }
        public string CompanyIds { get; set; }
        public string Type { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Id = " + Id);
            stringBuilder.Append(", FormTypeId = " + FormTypeId);
            stringBuilder.Append(", FormName = " + FormName);
            stringBuilder.Append(", WorkflowTrigger  = " + WorkflowTrigger);
            stringBuilder.Append(", FormJson = " + FormJson);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", FormKeys = " + FormKeys);
            stringBuilder.Append(", IsAbleToLogin = " + IsAbleToLogin);
            stringBuilder.Append(", IsAbleToComment = " + IsAbleToComment);
            stringBuilder.Append(", IsAbleToPay = " + IsAbleToPay);
            stringBuilder.Append(", IsAbleToCall = " + IsAbleToCall);
            return stringBuilder.ToString();
        }
    }
}
