using Btrak.Models.GenericForm;
using BTrak.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.WorkflowManagement
{
    public class WorkFlowTriggerModel : InputModelBase
    {
        public WorkFlowTriggerModel() : base(InputTypeGuidConstants.CustomWidgetUpsertInputCommandTypeGuid)
        {
        }
      
        public Guid? WorkflowTriggerId { get; set; }
        public string TriggerName { get; set; }
        public string DataJson { get; set; }
        public Guid? TriggerId { get; set; }
        public string[] FieldNames { get; set; }
        public string WorkflowName { get; set; }
        public Guid? WorkflowId { get; set; }
        public Guid? ReferenceId { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public bool? IsArchived { get; set; }
        public string WorkflowXml { get; set; }
        public Guid? WorkFlowTypeId { get; set; }
        public Guid? FormId { get; set; }
        public dynamic Answer { get; set; }
        public Guid? AuditDefaultWorkflowId { get; set; }
        public Guid? ConductDefaultWorkflowId { get; set; }
        public Guid? QuestionDefaultWorkflowId { get; set; }
        public bool? ToSetDefaultWorkflows { get; set; }
        public string Name { get; set; }
        public bool? IsForAuditRecurringMail { get; set; }
        public bool? IsForAuditDeadLineRecurringMail { get; set; }
        public string FileIds { get; set; }
        public Guid? SyncFormId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public List<WorkflowItem> FromData { get; set; }
        public List<FieldUpdateModel> FieldUpdateModel { get; set; }
        public string FieldUniqueId { get; set; }
        public string From { get; set; }
        public string To { get; set; }
        public string Cc { get; set; }
        public string Bcc { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
        public string JsonObject { get; set; }
        public string NavigationUrl { get; set; }
        public string NotificationMessage { get; set; }

    }
    public class WorkflowItem
    {
        public string Name { get; set; }
        public int Type { get; set; }
        public Guid? SyncFormId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public string DataJsonKeys { get; set; }
        public string DataJson { get; set; }
        public string From { get; set; }
        public string ToUsersString { get; set; }
        public string CcUsersString { get; set; }
        public string BccUsersString { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
        public bool? IsFileUpload { get; set; }
        public string FileUploadKey { get; set; }
        public string NotificationType { get; set; }
        public string NotificationText { get; set; }
        public string NotifyToUsersJson { get; set; }
        // Add other properties as needed
    }
    public class FormDataModel
    {
        [JsonProperty("Created Date")]
        public string CreatedDate { get; set; }
        [JsonProperty("createdBy")]
        public string CreatedBy { get; set; }
        [JsonProperty("Created User")]
        public string CreatedUser { get; set; }
        public bool Submit { get; set; }
        public bool cancel { get; set; }
    }
}