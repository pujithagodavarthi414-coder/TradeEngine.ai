using System;
using System.Collections.Generic;
using BTrak.Common;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.WorkflowManagement;

namespace Btrak.Services.WorkflowManagemet
{
    public class WorkflowManagementService : IWorkflowManagementService
    {
        private readonly WorkflowManagementRepository _workflowManagementRepository;

        public WorkflowManagementService(WorkflowManagementRepository workflowManagementRepository)
        {
            _workflowManagementRepository = workflowManagementRepository;
        }

        public List<WorkFlowTriggerModel> GetWorkFlowTriggersByReferenceTypeId(Guid referenceTypeId, List<ValidationMessage> validationMessages)
        {
            return
                _workflowManagementRepository.GetWorkflowTriggersByReferenceTypeId(referenceTypeId, validationMessages);
        }

        public AutomatedWorkFlowModel GetWorkflowDetailsById(Guid workflowId, List<ValidationMessage> validationMessages)
        {
            return _workflowManagementRepository.GetWorkflowDetailsById(workflowId, validationMessages);
        }

        public List<AutomatedWorkFlowModel> GetWorkFlowByTriggerNameAndReferenceId(string triggerName, Guid referenceId, Guid referenceTypeId, LoggedInContext loggedInContext)
        {
            var workflowTriggers =  _workflowManagementRepository.GetWorkFlowByTriggerNameAndReferenceId(triggerName, referenceId, referenceTypeId,loggedInContext);

            return workflowTriggers;
        }
    }
}
