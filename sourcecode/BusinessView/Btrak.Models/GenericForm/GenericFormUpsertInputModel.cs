using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.GenericForm
{
    public class GenericFormUpsertInputModel : InputModelBase
    {
        public GenericFormUpsertInputModel() : base(InputTypeGuidConstants.GenericFormUpsertInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public Guid? FormTypeId { get; set; }
        public Guid? DataSourceId { get; set; }
        public string FormName { get; set; }
        public string WorkflowTrigger { get; set; }
        public object FormJson { get; set; }
        public string FormBgColor { get;set; }
        public bool IsArchived { get; set; }
        public string FormKeys { get; set; }
        public bool? IsAbleToLogin { get; set; }
        public bool? AllowAnnonymous { get; set; }
        public bool? IsAbleToComment { get; set; }
        public bool? IsAbleToPay { get; set; }
        public bool? IsAbleToCall { get; set; }
        public Guid[] RoleForComment { get; set; }
        public Guid[] RoleForPay { get; set; }
        public Guid[] RoleForCall { get; set; }
        public Guid? CompanyModuleId { get; set; }
        public Guid[] ViewFormRoleIds { get; set; }
        public Guid[] EditFormRoleIds { get; set; }
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
