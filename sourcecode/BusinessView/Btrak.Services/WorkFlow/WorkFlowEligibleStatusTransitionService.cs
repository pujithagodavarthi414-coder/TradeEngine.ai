using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.WorkFlow;
using Btrak.Services.Audit;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Services.Helpers.WorkFlow;

namespace Btrak.Services.WorkFlow
{
    public class WorkFlowEligibleStatusTransitionService : IWorkFlowEligibleStatusTransitionService
    {
        private readonly WorkflowEligibleStatusTransitionRepository _workflowEligibleStatusTransitionRepository;
        private readonly IAuditService _auditService;

        public WorkFlowEligibleStatusTransitionService(WorkflowEligibleStatusTransitionRepository workflowEligibleStatusTransitionRepository, IAuditService auditService)
        {
            _workflowEligibleStatusTransitionRepository = workflowEligibleStatusTransitionRepository;
            _auditService = auditService;
        }

        public Guid? UpsertWorkFlowEligibleStatusTransition(WorkFlowEligibleStatusTransitionUpsertInputModel workflowEligibleStatusTransitionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(workflowEligibleStatusTransitionModel.ToString());

            if (!WorkFlowEligibleStatusTransitionValidations.ValidateUpsertWorkFlowEligibleStatusTransition(workflowEligibleStatusTransitionModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (workflowEligibleStatusTransitionModel.IsArchived)
            {
                workflowEligibleStatusTransitionModel.WorkflowEligibleStatusTransitionId = _workflowEligibleStatusTransitionRepository.UpdateWorkFlowEligibleStatusTransitionInActive(workflowEligibleStatusTransitionModel, loggedInContext, validationMessages);

                if (workflowEligibleStatusTransitionModel.WorkflowEligibleStatusTransitionId != Guid.Empty)
                {
                    LoggingManager.Debug(workflowEligibleStatusTransitionModel.WorkflowEligibleStatusTransitionId?.ToString());

                    _auditService.SaveAudit(AppCommandConstants.UpsertWorkFlowEligibleStatusTransitionCommandId, workflowEligibleStatusTransitionModel, loggedInContext);

                    return workflowEligibleStatusTransitionModel.WorkflowEligibleStatusTransitionId;
                }

                throw new Exception(ValidationMessages.ExceptionPermissionCouldNotBeCreated);
            }

            workflowEligibleStatusTransitionModel.RoleIdXml = Utilities.ConvertIntoListXml(workflowEligibleStatusTransitionModel.RoleGuids);

            workflowEligibleStatusTransitionModel.WorkflowEligibleStatusTransitionId = _workflowEligibleStatusTransitionRepository.UpsertWorkFlowEligibleStatusTransition(workflowEligibleStatusTransitionModel, loggedInContext, validationMessages);

            LoggingManager.Debug(workflowEligibleStatusTransitionModel.WorkflowEligibleStatusTransitionId?.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertWorkFlowEligibleStatusTransitionCommandId, workflowEligibleStatusTransitionModel.WorkflowEligibleStatusTransitionId, loggedInContext);

            return workflowEligibleStatusTransitionModel.WorkflowEligibleStatusTransitionId;
        }

        public List<WorkFlowEligibleStatusTransitionApiReturnModel> GetWorkFlowEligibleStatusTransitions(WorkFlowEligibleStatusTransitionInputModel workFlowEligibleStatusTransitionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetWorkFlowEligibleStatusTransitions." + "workFlowId=" + workFlowEligibleStatusTransitionInputModel.WorkFlowId + "Logged in User Id=" + loggedInContext.LoggedInUserId);

            if (workFlowEligibleStatusTransitionInputModel.ProjectId != null)
            {
                workFlowEligibleStatusTransitionInputModel.UserId = loggedInContext.LoggedInUserId;
            }

            _auditService.SaveAudit(AppCommandConstants.GetWorkFlowEligibleStatusTransitionsCommandId, workFlowEligibleStatusTransitionInputModel, loggedInContext);

            List<WorkFlowEligibleStatusTransitionApiReturnModel> workFlowEligibleStatusTransitionReturnModels = _workflowEligibleStatusTransitionRepository.GetWorkFlowEligibleStatusTransitions(workFlowEligibleStatusTransitionInputModel, loggedInContext, validationMessages);

            return workFlowEligibleStatusTransitionReturnModels;
        }

        public WorkFlowEligibleStatusTransitionApiReturnModel GetWorkFlowEligibleStatusTransitionById(Guid? workFlowStatusTransitionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetWorkFlowEligibleStatusTransitionById." + "WorkFlowStatusTransitionId=" + workFlowStatusTransitionId + "Logged in User Id=" + loggedInContext);

            if (!WorkFlowEligibleStatusTransitionValidations.ValidateWorkFlowEligibleStatusTransitionById(workFlowStatusTransitionId, loggedInContext, validationMessages))
            {
                return null;
            }

            var workFlowEligibleStatusTransitionInputModel = new WorkFlowEligibleStatusTransitionInputModel
            {
                WorkflowEligibleStatusTransitionId = workFlowStatusTransitionId
            };

            WorkFlowEligibleStatusTransitionApiReturnModel workFlowEligibleStatusTransitionReturnModel = _workflowEligibleStatusTransitionRepository.GetWorkFlowEligibleStatusTransitions(workFlowEligibleStatusTransitionInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!WorkFlowEligibleStatusTransitionValidations.ValidateWorkFlowEligibleStatusTransitionFoundWithId(workFlowStatusTransitionId, validationMessages, workFlowEligibleStatusTransitionReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetWorkFlowEligibleStatusTransitionByIdCommandId, workFlowEligibleStatusTransitionInputModel, loggedInContext);

            LoggingManager.Debug(workFlowEligibleStatusTransitionReturnModel?.ToString());

            return workFlowEligibleStatusTransitionReturnModel;
        }
    }
}
