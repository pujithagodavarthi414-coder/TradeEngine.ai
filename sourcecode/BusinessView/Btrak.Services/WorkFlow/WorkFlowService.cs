using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.WorkFlow;
using Btrak.Models.GenericForm;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Services.Helpers.WorkFlow;

namespace Btrak.Services.WorkFlow
{
    public class WorkFlowService : IWorkFlowService
    {
        private readonly WorkFlowRepository _workFlowRepository;
        private readonly IAuditService _auditService;

        public WorkFlowService(WorkFlowRepository workFlowRepository, IAuditService auditService)
        {
            _workFlowRepository = workFlowRepository;
            _auditService = auditService;
        }

        public Guid? UpsertWorkFlow(string workFlowName, Guid? workFlowId, bool isArchive, byte[] timeStamp, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            workFlowName = workFlowName?.Trim();

            var workFlowUpsertInputModel = new WorkFlowUpsertInputModel
            {
                IsArchived = isArchive,
                WorkFlowId = workFlowId,
                WorkFlowName = workFlowName,
                TimeStamp = timeStamp
            };

            LoggingManager.Debug(workFlowUpsertInputModel.ToString());

            if (!WorkFlowValidations.ValidateUpsertWorkFlow(workFlowUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            workFlowId = _workFlowRepository.UpsertWorkFlow(workFlowUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug(workFlowId?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertWorkFlowCommandId, workFlowUpsertInputModel, loggedInContext);

            return workFlowId;
        }


        public Guid? UpdateFieldValue(FieldUpdateModel fieldUpdateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var formId = _workFlowRepository.UpdateFieldValue(fieldUpdateModel, loggedInContext, validationMessages);
            LoggingManager.Debug("formId" + formId);
            return formId;
        }


        public Guid? UpsertChecklist(CheckListModel checkListModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var formId = _workFlowRepository.UpsertChecklist(checkListModel, loggedInContext, validationMessages);
            return formId;
        }

        public List<WorkFlowApiReturnModel> GetAllWorkFlows(bool isArchive, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetAllWorkFlows." + "isArchive=" + isArchive + "Logged in User Id=" + loggedInContext.LoggedInUserId);

            var workFlowInputModel = new WorkFlowInputModel
            {
                IsArchived = isArchive,
            };

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAllWorkFlowsCommandId, workFlowInputModel, loggedInContext);

            List<WorkFlowApiReturnModel> workFlowReturnModels = _workFlowRepository.GetAllWorkFlows(workFlowInputModel, loggedInContext, validationMessages);
            
            return workFlowReturnModels;
        }

        public WorkFlowApiReturnModel GetWorkflowById(Guid? workFlowId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetWorkflowById." + "workFlowId=" + workFlowId);

            if (!WorkFlowValidations.ValidateWorkFlowById(workFlowId, loggedInContext, validationMessages))
            {
                return null;
            }

            var workFlowInputModel = new WorkFlowInputModel
            {
                WorkFlowId = workFlowId
            };

            WorkFlowApiReturnModel workFlowReturnModel = _workFlowRepository.GetAllWorkFlows(workFlowInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!WorkFlowValidations.ValidateWorkFlowFoundWithId(workFlowId, validationMessages, workFlowReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetWorkflowByIdCommandId, workFlowInputModel, loggedInContext);

            LoggingManager.Debug(workFlowReturnModel?.ToString());

            return workFlowReturnModel;
        }


    }
}
