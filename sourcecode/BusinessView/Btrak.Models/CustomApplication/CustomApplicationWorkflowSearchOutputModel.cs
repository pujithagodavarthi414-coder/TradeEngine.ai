using System;

namespace Btrak.Models.CustomApplication
{
    public class CustomApplicationWorkflowSearchOutputModel
    {
        public Guid? CustomApplicationWorkflowTypeId { get; set; }
        public Guid? CustomApplicationWorkflowId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? WorkflowTypeId { get; set; }
        public string WorkflowTypeName { get; set; }
        public string WorkflowName { get; set; }
        public string WorkflowTrigger { get; set; }
        public string WorkflowXml { get; set; }
        public string RuleJson { get; set; }
        public DateTime? CreatedDateTime { get; set; }
    }
}
