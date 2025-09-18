using Btrak.Models.WorkFlow;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models;

namespace Btrak.Services.WorkFlow
{
    public interface IWorkFlowEligibleStatusTransitionService
    {
        Guid? UpsertWorkFlowEligibleStatusTransition(WorkFlowEligibleStatusTransitionUpsertInputModel workflowEligibleStatusTransitionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<WorkFlowEligibleStatusTransitionApiReturnModel> GetWorkFlowEligibleStatusTransitions(WorkFlowEligibleStatusTransitionInputModel workFlowEligibleStatusTransitionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        WorkFlowEligibleStatusTransitionApiReturnModel GetWorkFlowEligibleStatusTransitionById(Guid? workFlowStatusTransitionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
