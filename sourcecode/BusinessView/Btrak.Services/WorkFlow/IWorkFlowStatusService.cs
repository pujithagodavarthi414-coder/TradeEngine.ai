using Btrak.Models;
using Btrak.Models.WorkFlow;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.WorkFlow
{
    public interface IWorkFlowStatusService
    {
        Guid? UpsertWorkFlowStatus(WorkFlowStatusUpsertInputModel workFlowStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<WorkFlowStatusApiReturnModel> GetAllWorkFlowStatus(bool? isArchive,Guid? workFlowId,Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        WorkFlowStatusApiReturnModel GetWorkflowStatusById(Guid? workFlowStatusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
