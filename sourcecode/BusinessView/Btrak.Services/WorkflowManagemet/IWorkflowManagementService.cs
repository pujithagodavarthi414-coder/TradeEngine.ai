using System;
using System.Collections.Generic;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.WorkflowManagement;

namespace Btrak.Services.WorkflowManagemet
{
    public interface IWorkflowManagementService
    {
        List<WorkFlowTriggerModel> GetWorkFlowTriggersByReferenceTypeId(Guid referenceTypeId, List<ValidationMessage> validationMessages);
        AutomatedWorkFlowModel GetWorkflowDetailsById(Guid workflowId, List<ValidationMessage> validationMessages);
        List<AutomatedWorkFlowModel> GetWorkFlowByTriggerNameAndReferenceId(string triggerName, Guid referenceId, Guid referenceTypeId, LoggedInContext loggedInContext);
    }
}