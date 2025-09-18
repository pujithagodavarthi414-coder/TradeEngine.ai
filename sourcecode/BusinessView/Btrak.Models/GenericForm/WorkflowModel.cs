using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class WorkflowModel : InputModelBase
    {
        public WorkflowModel() : base(InputTypeGuidConstants.GenericFormUpsertInputCommandTypeGuid)
        {
        }

        public Guid? Id { get; set; }
        public Guid? GenericFormKeyId { get; set; }
        public Guid? FormTypeId { get; set; }
        public Guid? DataSourceId { get; set; }
        public object FormData { get; set; }
        public string formtypeName { get; set; }
        public string FormName { get; set; }
        public Guid? WorkflowTypeId { get; set; }
        public string WorkflowName { get; set; }
        public bool IsStatus { get; set; }
        public string Description { get; set; }
        public string Action { get; set; }
        public string DataJson { get; set; }
        public bool? IsArchived { get; set; }
        public string[] FieldNames { get; set; }
        public string CronRadio { get; set; }
        public string dateofexecution { get; set; }
        public string TriggerMonth { get; set; }
        public string TriggerDay { get; set; }
        public string TriggerStartList { get; set; }
        public string TriggerStartDays { get; set; }
        public string TriggerEndList { get; set; }
        public string TriggerEndDays { get; set; }
        public string CronExpression { get; set; }
        public string Timeofexecution { get; set; }
        public string Executionoccurrence { get; set; }
        public string Timezone { get; set; }
        public string Xml { get; set; }
        public Guid[] FieldName { get; set; }
        public string WorkflowTrigger { get; set; }
        public string WorkflowItems { get; set; }
        public string WorkflowItemsByOrder { get; set; }
        public string CriterialSteps { get; set; }
        public Guid? CompanyModuleId { get; set; }
        public string ActivityName { get; set; }
        public string Inputs { get; set; }
        public string ErrorCode { get; set; }
        public string ErrorMessage { get; set; }
        public List<Object> Tasks { get; set; }
        public string FieldUniqueId { get; set; }
        public string DateFieldName { get; set; }
        public int? OffsetMinutes { get; set; }
        public Guid? WorkflowId { get; set; }
        public int? SelectedTab { get; set; }
        public string FormIds { get; set; }
        public string DataSetIds { get; set; }
    }

    public class WorkflowOutputModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public bool? IsArchived { get; set; }
        public string Name { get; set; }
        public WorkflowModel DataJson { get; set; }
        public Guid? CompanyModuleId { get; set; }
        public Guid? FormTypeId { get; set; }
        public string WorkflowName { get; set; }
        public string FormName { get; set; }
        public string Description { get; set; }
        public WorkflowModel WorkflowObject {get;set;}
    }
}
