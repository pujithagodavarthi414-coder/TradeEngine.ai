using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.Work;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Work;
using Btrak.Models.MyWork;

namespace Btrak.Services.WorkAllocationManagement
{
    public class WorkAllocationManagementService : IWorkAllocationManagementService
    {
        private readonly WorkAllocationManagementRepository _workAllocationRepository;
        private readonly IAuditService _auditService;

        public WorkAllocationManagementService(EmployeeWorkConfigurationRepository employeeWorkConfiguration, EmployeeRepository employeeRepository,
            WorkAllocationManagementRepository workAllocationRepository, IAuditService auditService)
        {
            _workAllocationRepository = workAllocationRepository;
            _auditService = auditService;
        }
        public List<WorkAllocationApiReturnModel> GetEmployeeWorkAllocation(WorkAllocationSearchCriteriaInputModel workAllocationSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to Get Work Allocation Summary Based On User." + "Logged in User Id=" + loggedInContext.LoggedInUserId);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, workAllocationSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(workAllocationSearchCriteriaInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetEmployeeWorkAllocationCommandId, workAllocationSearchCriteriaInputModel, loggedInContext);

            List<WorkAllocationApiReturnModel> workAllocationApiReturnModels = _workAllocationRepository.GetEmployeeWorkAllocation(workAllocationSearchCriteriaInputModel, loggedInContext, validationMessages);

            if (!WorkAllocationValidations.ValidateEmployeeWorkAllocation(validationMessages, workAllocationApiReturnModels))
            {
                return null;
            }

            return workAllocationApiReturnModels;
        }

        public List<WorkAllocationApiReturnModel> GetWorkAllocationByProjectId(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWorkAllocationByProjectId", "WorkAllocation Service and logged details=" + loggedInContext));

            LoggingManager.Debug(projectId.ToString());

            if (!WorkAllocationValidations.ValidateWorkAllocationByProjectId(projectId, loggedInContext, validationMessages))
            {
                return null;
            }

            var workAllocationSearchCriteriaInputModel = new WorkAllocationSearchCriteriaInputModel
            {
                ProjectId = projectId
            };

            _auditService.SaveAudit(AppCommandConstants.GetWorkAllocationByProjectIdCommandId, workAllocationSearchCriteriaInputModel, loggedInContext);

            List<WorkAllocationApiReturnModel> workAllocationApiReturnModels = _workAllocationRepository.GetEmployeeWorkAllocation(workAllocationSearchCriteriaInputModel, loggedInContext, validationMessages);

            return workAllocationApiReturnModels;
        }

        public List<UserHistoricalWorkReportSearchSpOutputModel> GetWorkAllocationDrillDownDetailsbyUserId(WorkAllocationSearchCriteriaInputModel workAllocationSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Get Work Allocation Drill Down Based On User." + "Logged in User Id=" + loggedInContext.LoggedInUserId);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, workAllocationSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(workAllocationSearchCriteriaInputModel?.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetEmployeeWorkAllocationCommandId, workAllocationSearchCriteriaInputModel, loggedInContext);

            List<UserHistoricalWorkReportSearchSpOutputModel> workAllocationApiReturnModels = _workAllocationRepository.GetDrillDownUserStoryDetailsByUserId(workAllocationSearchCriteriaInputModel, loggedInContext, validationMessages);

            return workAllocationApiReturnModels;
        }
    }
}