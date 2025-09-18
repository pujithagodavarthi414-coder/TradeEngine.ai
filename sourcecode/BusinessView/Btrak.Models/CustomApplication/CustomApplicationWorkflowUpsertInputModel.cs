using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.CustomApplication
{
    public class CustomApplicationWorkflowUpsertInputModel : SearchCriteriaInputModelBase
    {
        public CustomApplicationWorkflowUpsertInputModel() : base(InputTypeGuidConstants.CustomApplicationSearchInputModel)
        {
        }

        public Guid? CustomApplicationWorkflowTypeId { get; set; }
        public Guid? CustomApplicationFormId { get; set; }
        public Guid? CustomApplicationWorkflowId { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public string WorkflowName { get; set; }
        public string WorkflowFileName { get; set; }
        public string CustomApplicationName { get; set; }
        public string WorkflowXml { get; set; }
        public bool? IsPublished { get; set; }
        public string RuleJson { get; set; }
        public string WorkflowTrigger { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" CustomApplicationWorkflowTypeId = " + CustomApplicationWorkflowTypeId);
            stringBuilder.Append(" CustomApplicationWorkflowId = " + CustomApplicationWorkflowId);
            stringBuilder.Append(", CustomApplicationId = " + CustomApplicationId);
            stringBuilder.Append(", WorkflowXml = " + WorkflowXml);
            stringBuilder.Append(", WorkflowName = " + WorkflowName);
            stringBuilder.Append(", WorkflowTrigger = " + WorkflowTrigger);
            stringBuilder.Append(", WorkflowFileName = " + WorkflowFileName);
            stringBuilder.Append(", CustomApplicationName = " + CustomApplicationName);
            stringBuilder.Append(", RuleJson = " + RuleJson);
            return stringBuilder.ToString();
        }
    }
}

