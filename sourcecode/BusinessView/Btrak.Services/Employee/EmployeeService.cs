using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.EmployeeValidationHelpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Btrak.Models.Chat;
using Btrak.Services.PubNub;
using Newtonsoft.Json;

namespace Btrak.Services.Employee
{
    public class EmployeeService : IEmployeeService
    {
        private readonly EmployeeRepository _employeeRepository;
        private readonly IAuditService _auditService;
        private readonly IPubNubService _pubNubService;

        public EmployeeService(EmployeeRepository employeeRepository, IAuditService auditService,PubNubService pubNubService)
        {
            _employeeRepository = employeeRepository;
            _auditService = auditService;
            _pubNubService = pubNubService;
        }

        public Guid? UpsertEmployee(EmployeeInputModel employeeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployee", "employeeModel", employeeModel, "Employee Service"));

            if (!EmployeeValidationHelper.UpsertEmployeeValidation(employeeModel, loggedInContext, validationMessages))
            {
                return null;
            }

            employeeModel.EmployeeId = _employeeRepository.UpsertEmployee(employeeModel, loggedInContext, validationMessages);

            if (employeeModel.EmployeeId != null && employeeModel.EmployeeId != Guid.Empty)
            {
                var pubnubChannels = new List<string>();
                pubnubChannels.Add($"UserUpdates-{loggedInContext.CompanyGuid.ToString()}");
                _pubNubService.PublishUserUpdatesToChannel(JsonConvert.SerializeObject(new MessageDto
                {
                    RefreshUsers = true,
                    SenderUserId = loggedInContext.LoggedInUserId,
                    FromUserId = loggedInContext.LoggedInUserId
                }), pubnubChannels, loggedInContext);
            }

            LoggingManager.Debug(employeeModel.EmployeeId?.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeCommandId, employeeModel, loggedInContext);

            return employeeModel.EmployeeId;
        }

        public List<EmployeeOutputModel> GetAllEmployees(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetAllEmployees." + "Logged in User Id=" + loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, employeeSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAllEmployeesCommandId, employeeSearchCriteriaInputModel, loggedInContext);

            LoggingManager.Debug(employeeSearchCriteriaInputModel?.ToString());

            List<EmployeeOutputModel> employeeModels = _employeeRepository.GetAllEmployees(employeeSearchCriteriaInputModel, loggedInContext, validationMessages);

            Parallel.ForEach(employeeModels, employees =>
            {
                employees.RoleIds = employees.RoleId?.Trim().Split(',').ToArray();
                employees.RoleNames = employees.RoleName?.Trim().Split(',').ToArray();
            });

            return employeeModels;
        }
        public List<EmployeeFieldsModel> GetEmployeeFields(EmployeeFieldsModel employeeFieldsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetEmployeeFields." + "Logged in User Id=" + loggedInContext);

            _auditService.SaveAudit(AppCommandConstants.GetAllEmployeesCommandId, employeeFieldsModel, loggedInContext);

            LoggingManager.Debug(employeeFieldsModel?.ToString());

            List<EmployeeFieldsModel> employeeFields = _employeeRepository.GetEmployeeFields(employeeFieldsModel, loggedInContext, validationMessages);

            return employeeFields;
        }
        public Guid? UpsertEmployeeFields(EmployeeFieldsModel employeeFieldsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to UpsertEmployeeFields." + "Logged in User Id=" + loggedInContext);

            _auditService.SaveAudit(AppCommandConstants.GetAllEmployeesCommandId, employeeFieldsModel, loggedInContext);

            LoggingManager.Debug(employeeFieldsModel?.ToString());

            return _employeeRepository.UpsertEmployeeFields(employeeFieldsModel, loggedInContext, validationMessages); ;
        }

        public List<EmployeeListApiOutputModel> GetEmployeesList(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetEmployeesList." + "Logged in User Id=" + loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, employeeSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAllEmployeesCommandId, employeeSearchCriteriaInputModel, loggedInContext);

            LoggingManager.Debug(employeeSearchCriteriaInputModel?.ToString());

            List<EmployeeListApiOutputModel> employees = _employeeRepository.GetEmployeesList(employeeSearchCriteriaInputModel, loggedInContext, validationMessages);

            return employees;
        }

        public List<EmployeeDetailsApiOutputModel> GetAllEmployeesDetails(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetAllEmployees." + "Logged in User Id=" + loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, employeeSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAllEmployeesCommandId, employeeSearchCriteriaInputModel, loggedInContext);

            LoggingManager.Debug(employeeSearchCriteriaInputModel?.ToString());

            List<EmployeeDetailsApiOutputModel> employeeModels = _employeeRepository.GetAllEmployeeDetails(employeeSearchCriteriaInputModel, loggedInContext, validationMessages);

            return employeeModels;
        }

        public EmployeeOutputModel GetEmployeeById(Guid? employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetEmployeeById." + "employeeId=" + employeeId + ", loggedInContext=" + loggedInContext.LoggedInUserId);

            if (!EmployeeValidationHelper.GetEmployeeByIdValidation(employeeId, loggedInContext, validationMessages))
            {
                return null;
            }
            EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel = new EmployeeSearchCriteriaInputModel
            {
                EmployeeId = employeeId
            };
            EmployeeOutputModel employeeModel = _employeeRepository.GetAllEmployees(employeeSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();
            return employeeModel;
        }
    }
}
