using Btrak.Models.FormDataServices;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.GenericForm
{
    public class CustomApplicationUpsertInputModel : InputModelBase
    {
        public CustomApplicationUpsertInputModel() : base(InputTypeGuidConstants.CustomApplicationUpsertInputModel)
        {
        }

        public Guid? CustomApplicationId { get; set; }
        public string CustomApplicationName { get; set; }
        public string Description { get; set; }
        public string FormId { get; set; }
        public string RoleIds { get; set; }
        public string ModuleIds { get; set; }
        public List<string> MultipleFormIds { get; set; }
        public bool? IsArchived { get; set; }
        public string SelectedKeyIds { get; set; }
        public string SelectedPrivateKeyIds { get; set; }
        public string SelectedTagKeyIds { get; set; }
        public string SelectedEnableTrendsKeys { get; set; }
        public string DomainName { get; set; }
        public string PublicMessage { get; set; }
        public bool? IsPublished { get; set; }
        public bool? IsApproveNeeded { get; set; }
        public string SelectedFormsXml { get; set; }
        public List<Guid> SelectedKeyIdsList { get; set; }
        public List<Guid> UserList { get; set; }
        public string UsersXML { get; set; }
        public List<Guid> SelectedPrivateKeyIdsList { get; set; }
        public List<Guid> SelectedTagKeyIdsList { get; set; }
        public List<Guid> SelectedEnableTrendsKeysList { get; set; }
        public List<GenericFormUpsertInputModel> SelectedForms { get; set; }
        public List<DataSourceKeysConfigurationInputModel> CustomApplicationKeys { get; set; }
        public bool? IsPdfRequired { get; set; }
        public bool? IsRedirectToEmails { get; set; }
        public string WorkflowIds { get; set; }
        public bool? AllowAnnonymous { get; set; }
        public string ToEmails { get; set; }
        public string ToRoleIds { get; set; }
        public string Message { get; set; }
        public string Subject { get; set; }
        public bool IsRecordLevelPermissionEnabled { get; set; }
        public string RecordLevelPermissionFieldName { get; set; }
        public int? ConditionalEnum { get; set; }
        public string ApproveSubject { get; set; }
        public string ApproveMessage { get; set; }
        public List<RecordLevelPermissionInputModel> Conditions { get; set; }
        public List<ScenarioModel> StagesScenarios { get; set; }
        public RecordPermissionMainModdel Filters { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CustomApplicationId = " + CustomApplicationId);
            stringBuilder.Append("ModuleIds = " + ModuleIds);
            stringBuilder.Append(", CustomApplicationName = " + CustomApplicationName);
            stringBuilder.Append(", FormId = " + FormId);
            stringBuilder.Append(", RoleIds = " + RoleIds);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", SelectedKeyIds = " + SelectedKeyIds);
            stringBuilder.Append(", SelectedPrivateKeyIds = " + SelectedPrivateKeyIds);
            stringBuilder.Append(", SelectedTagKeyIds = " + SelectedTagKeyIds);
            stringBuilder.Append(", SelectedEnableTrendsKeys = " + SelectedEnableTrendsKeys);
            stringBuilder.Append(", DomainName = " + DomainName);
            stringBuilder.Append(", PublicMessage = " + PublicMessage);
            stringBuilder.Append(", IsPublished = " + IsPublished);
            stringBuilder.Append(", IsApproveNeeded = " + IsApproveNeeded);

            return stringBuilder.ToString();
        }
    }
}
