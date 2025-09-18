using System;
using System.Collections.Generic;
using BTrak.Common;
using Btrak.Models.WorkflowManagement;

namespace Btrak.Services.WorkFlowTrigger
{
    public interface IWorkFlowTrigger
    {
        void InvokeTrigger(Guid referenceId, string triggerName,Guid referenceTypeId, LoggedInContext loggedInContext,
            Dictionary<string, object> resultVariables);
    }
}