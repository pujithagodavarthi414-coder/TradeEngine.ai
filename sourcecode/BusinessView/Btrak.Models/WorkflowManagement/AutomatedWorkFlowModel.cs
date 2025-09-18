using System;
using BTrak.Common;

namespace Btrak.Models.WorkflowManagement
{
    public class AutomatedWorkFlowModel
    {
        public Guid Id { get; set; }
        public string WorkflowName { get; set; }
        public string WorkflowXml { get; set; }
        public LoggedInContext LoggedInContext { get; set; }
    }
}