using Btrak.Models.GenericForm;
using System;
using System.Collections.Generic;

namespace Btrak.Models.CustomApplication
{
    public class CustomApplicationSearchOutputModel
    {
        public Guid? CustomApplicationId { get; set; }
        public string CustomApplicationName { get; set; }
        public string Description { get; set; }
        public string Tag { get; set; }
        public Guid? FormTypeId { get; set; }
        public string FormTypeName { get; set; }
        public Guid? FormId { get; set; }
        public Guid? DataSourceId { get; set; }
        public string FormName { get; set; }
        public string FormJson { get; set; }
        public string PublicUrl { get; set; }
        public string PublicMessage { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string RoleIds { get; set; }
        public string RoleNames { get; set; }
        public string ModuleIds { get; set; }
        public string SelectedKeyIds { get; set; }
        public string SelectedPrivateKeyIds { get; set; }
        public string SelectedEnableTrendsKeys { get; set; }
        public string SelectedTagKeyIds { get; set; }
        public string UserIds { get; set; }
        public string WorkflowIds { get; set; }
        public int? VersionNumber { get; set; }
        public Guid? OriginalId { get; set; }
        public byte[] TimeStamp { get; set; }
        public DateTime? AsAtInactiveDateTime { get; set; }
        public int TotalCount { get; set; }
        public bool? IsAbleToLogin { get; set; }
        public bool? IsAbleToPay { get; set; }
        public bool? IsAbleToCall { get; set; }
        public bool? IsAbleToComment { get; set; }
        public bool? IsPublished { get; set; }
        public bool? IsApproveNeeded { get; set; }
        public bool? AllowAnnonymous { get; set; }
        public bool? IsPdfRequired { get; set; }
        public bool? IsRedirectToEmails { get; set; }
        public Guid? GenericFormId { get; set; }
        public List<GenericFormJsonModel> GenericFormIdsJson { get; set; }
        public dynamic Fields { get; set; }
        public Guid[] ViewFormRoleIds { get; set; }
        public bool? ViewForm { get; set; }
        public bool? EditForm { get; set; }
        public Guid[] EditFormRoleIds { get; set; }
        public List<UpsertDataLevelKeyConfigurationModel> CustomApplicationLevelsList { get; set; }
        public string ToEmails { get; set; }
        public string ToRoleIds { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
        public bool IsRecordLevelPermissionEnabled { get; set; }
        public string RecordLevelPermissionFieldName { get; set; }
        public int? ConditionalEnum { get; set; }
        public string ConditionsJson { get; set; }
        public string StageScenariosJson { get; set; }
        public string ApproveSubject { get; set; }
        public string ApproveMessage { get; set; }
    }

    public class GenericFormJsonModel
    {
        public Guid? GenericFormKeyId { get; set; }
        public bool? IsDefault { get; set; }
        public bool? IsPrivate { get; set; }
        public bool? IsTag { get; set; }
        public bool? IsTrendsEnable { get; set; }
    }
}
