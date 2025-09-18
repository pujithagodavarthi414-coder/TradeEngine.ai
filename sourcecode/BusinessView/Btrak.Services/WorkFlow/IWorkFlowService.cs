using Btrak.Models;
using Btrak.Models.GenericForm;
using Btrak.Models.WorkFlow;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.WorkFlow
{
    public interface IWorkFlowService
    {
        Guid? UpsertWorkFlow(string workFlowName, Guid? workFlowId, bool isArchive,byte[] timeStamp, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<WorkFlowApiReturnModel> GetAllWorkFlows(bool isArchive, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        WorkFlowApiReturnModel GetWorkflowById(Guid? workFlowId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateFieldValue(FieldUpdateModel fieldUpdateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertChecklist(CheckListModel checkListModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
