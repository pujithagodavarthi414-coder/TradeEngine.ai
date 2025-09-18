using Btrak.Models;
using Btrak.Models.WorkflowManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.AutomatedWorkflowmanagement
{
    public interface IAutomatedWorkflowmanagementServices
    {
        List<WorkFlowTriggerModel> GetTriggers(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<WorkFlowTriggerModel> GetWorkFlowTriggers(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        IList<WorkFlowTriggerModel> GetWorkflowsForTriggers(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertWorkflowTrigger(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertDefaultWorkFlow(DefaultWorkflowModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertGenericStatus(GenericStatusModel workFlowStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GenericStatusModel> GetGenericStatus(GenericStatusModel workFlowStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        WorkFlowTriggerModel GetWorkflowBasedOnWorkflowId(Guid? workFlowId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void StartWorkflowProcessInstance(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DefaultWorkflowModel> GetDefaultWorkFlows(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<WorkFlowTriggerModel> GetWorkFlowTriggers(WorkFlowTriggerModel workFlowTriggerModel, Guid? CompanyId, Guid UserId, List<ValidationMessage> validationMessages);
        void TriggerReceiveTask(string messageName, dynamic processVariables, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string instanceId);
    }
}
