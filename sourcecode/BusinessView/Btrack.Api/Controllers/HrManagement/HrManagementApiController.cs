using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Currency;
using Btrak.Models.CurrencyConversion;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using Btrak.Models.PayGradeRates;
using Btrak.Models.PaymentMethod;
using Btrak.Models.RateType;
using Btrak.Services.Employee;
using Btrak.Services.HrManagement;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using Btrak.Models.StatusReportingConfiguration;
using BTrak.Common;
using System.Net.Http;
using System.IO;
using OfficeOpenXml;
using System.Threading.Tasks;
using System.Net;
using Hangfire;
using System.Web.Hosting;
using DocumentFormat.OpenXml.Packaging;
using System.Net.Http.Headers;
using Btrak.Models.HrDashboard;
using Btrak.Models.User;
using Btrak.Services.CompanyStructure;
using Btrak.Models.PayRoll;
using Newtonsoft.Json;
using Btrak.Models.Branch;
using Btrak.Services.Branch;
using Btrak.Models.MasterData;
using Btrak.Services.MasterData;
using Btrak.Models.TimeZone;
using Btrak.Services.TimeZone;
using Btrak.Models.Role;
using Btrak.Services.Role;

namespace BTrak.Api.Controllers.HrManagement
{
    public class HrManagementApiController : AuthTokenApiController
    {
        private readonly IHrManagementService _hrManagementService;
        private readonly IBranchService _branchService;
        private readonly IMasterDataManagementService _masterDataManagementService;
        private readonly ITimeZoneService _timeZoneService;
        private readonly IRoleService _roleService;
        private readonly IEmployeeService _employeeService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly UserAuthTokenFactory _userAuthTokenFactory;
        public HrManagementApiController(IHrManagementService hrManagementService, IBranchService branchService, IRoleService roleService, ITimeZoneService timeZoneService, IMasterDataManagementService masterDataManagementService, IEmployeeService employeeService, ICompanyStructureService companyStructureService)
        {
            _hrManagementService = hrManagementService;
            _employeeService = employeeService;
            _companyStructureService = companyStructureService;
            _branchService = branchService;
            _timeZoneService = timeZoneService;
            _roleService = roleService;
            _masterDataManagementService = masterDataManagementService;
            _userAuthTokenFactory = new UserAuthTokenFactory();
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllEmployees)]
        public JsonResult<BtrakJsonResult> GetAllEmployees(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllEmployees", "Employee Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (employeeSearchCriteriaInputModel == null)
                {
                    employeeSearchCriteriaInputModel = new EmployeeSearchCriteriaInputModel();
                }

                List<EmployeeOutputModel> employeeModels = _employeeService.GetAllEmployees(employeeSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllEmployees", "Employee Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllEmployees", "Employee Api"));
                return Json(new BtrakJsonResult { Data = employeeModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllEmployees", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeFields)]
        public JsonResult<BtrakJsonResult> GetEmployeeFields(EmployeeFieldsModel employeeFieldsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeFields", "Employee Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (employeeFieldsModel == null)
                {
                    employeeFieldsModel = new EmployeeFieldsModel();
                }

                List<EmployeeFieldsModel> employeeFields = _employeeService.GetEmployeeFields(employeeFieldsModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeFields", "Employee Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeFields", "Employee Api"));
                return Json(new BtrakJsonResult { Data = employeeFields, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeFields", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeFields)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeFields(EmployeeFieldsModel employeeFieldsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeFields", "Employee Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (employeeFieldsModel == null)
                {
                    employeeFieldsModel = new EmployeeFieldsModel();
                }

                Guid? employeeFieldId = _employeeService.UpsertEmployeeFields(employeeFieldsModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeFields", "Employee Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeFields", "Employee Api"));
                return Json(new BtrakJsonResult { Data = employeeFieldId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeFields", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeesList)]
        public JsonResult<BtrakJsonResult> GetEmployeesList(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeesList", "Employee Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (employeeSearchCriteriaInputModel == null)
                {
                    employeeSearchCriteriaInputModel = new EmployeeSearchCriteriaInputModel();
                }

                List<EmployeeListApiOutputModel> employeeList = _employeeService.GetEmployeesList(employeeSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesList", "Employee Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesList", "Employee Api"));
                return Json(new BtrakJsonResult { Data = employeeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeesList", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeesListDropDowns)]
        public JsonResult<BtrakJsonResult> GetEmployeesListDropDowns(string keyValue)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeesList", "Employee Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                object data = null;
                if (keyValue == "Designations")
                {
                    DesignationSearchInputModel designationSearchInputModel = new DesignationSearchInputModel();
                    designationSearchInputModel.IsArchived = false;
                    data = _hrManagementService.GetDesignations(designationSearchInputModel, LoggedInContext, validationMessages);
                }
                if (keyValue == "Currencies")
                {
                    CurrencySearchCriteriaInputModel currencySearchCriteriaInputModel = new CurrencySearchCriteriaInputModel();
                    currencySearchCriteriaInputModel.IsArchived = false;
                    data = _hrManagementService.SearchCurrency(currencySearchCriteriaInputModel, LoggedInContext, validationMessages);
                }
                if (keyValue == "Branch")
                {
                    BranchSearchInputModel branchInputModel = new BranchSearchInputModel();
                    branchInputModel.IsArchived = false;
                    data = _branchService.GetAllBranches(branchInputModel, LoggedInContext, validationMessages);
                }
                if (keyValue == "EmploymentTypes")
                {
                    EmploymentStatusSearchCriteriaInputModel getEmploymentStatusSearchCriteriaInputModel = new EmploymentStatusSearchCriteriaInputModel();
                    getEmploymentStatusSearchCriteriaInputModel.IsArchived = false;
                    List<EmploymentStatusOutputModel> employmentStatusList = _masterDataManagementService.GetEmploymentStatus(getEmploymentStatusSearchCriteriaInputModel, LoggedInContext, validationMessages);
                }
                if (keyValue == "JobCategories")
                {
                    JobCategorySearchInputModel jobCategorySearchInputModel = new JobCategorySearchInputModel();
                    jobCategorySearchInputModel.IsArchived = false;
                    data = _masterDataManagementService.SearchJobCategoryDetails(jobCategorySearchInputModel, LoggedInContext, validationMessages);
                }
                if (keyValue == "Timezones")
                {
                    TimeZoneInputModel timeZoneInputModel = new TimeZoneInputModel();
                    timeZoneInputModel.IsArchived = false;
                    data = _timeZoneService.GetAllTimeZones(timeZoneInputModel, validationMessages);
                }
                if (keyValue == "Roles")
                {
                    RolesSearchCriteriaInputModel roleSearchCriteriaInputModel = new RolesSearchCriteriaInputModel();
                    roleSearchCriteriaInputModel.IsArchived = false;
                    data = _roleService.GetAllRoles(roleSearchCriteriaInputModel, LoggedInContext, validationMessages);
                }
                if (keyValue == "Departments")
                {
                    DepartmentSearchInputModel departmentSearchInputModel = new DepartmentSearchInputModel();
                    departmentSearchInputModel.IsArchived = false;
                    data = _hrManagementService.GetDepartments(departmentSearchInputModel, LoggedInContext, validationMessages);
                }
                if (keyValue == "Shifts")
                {
                    ShiftTimingsSearchInputModel shiftTimingsSearchInputModel = new ShiftTimingsSearchInputModel();
                    shiftTimingsSearchInputModel.IsArchived = false;
                    data = _hrManagementService.SearchShiftTimings(shiftTimingsSearchInputModel, LoggedInContext, validationMessages);
                }
                if (keyValue == "BusinessUnits")
                {
                    BusinessUnitDropDownModel businessUnitModel = new BusinessUnitDropDownModel();
                    businessUnitModel.IsFromHR = false;
                    data = _masterDataManagementService.GetBusinessUnitDropDown(businessUnitModel, LoggedInContext, validationMessages);
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesList", "Employee Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesList", "Employee Api"));
                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeesList", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllEmployeesDetails)]
        public JsonResult<BtrakJsonResult> GetAllEmployeesDetails(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllEmployees", "Employee Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (employeeSearchCriteriaInputModel == null)
                {
                    employeeSearchCriteriaInputModel = new EmployeeSearchCriteriaInputModel();
                }

                List<EmployeeDetailsApiOutputModel> employeeModels = _employeeService.GetAllEmployeesDetails(employeeSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllEmployees", "Employee Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllEmployees", "Employee Api"));
                return Json(new BtrakJsonResult { Data = employeeModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllEmployeesDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeById)]
        public JsonResult<BtrakJsonResult> GetEmployeeById(Guid? employeeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeById", "employeeId", employeeId, "Employee Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                EmployeeOutputModel employeeModel = _employeeService.GetEmployeeById(employeeId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeById", "Employee Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeById", "Employee Api"));
                return Json(new BtrakJsonResult { Data = employeeModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeById", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployee)]
        public JsonResult<BtrakJsonResult> UpsertEmployee(EmployeeInputModel employeeModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployee", "employeeModel", employeeModel, "Employee Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? employeeIdReturned = _employeeService.UpsertEmployee(employeeModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Employee Upsert is completed. Return Guid is " + employeeIdReturned + ", source command is " + employeeModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployee", "Employee Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployee", "Employee Api"));
                return Json(new BtrakJsonResult { Data = employeeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployee", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertShiftTiming)]
        public JsonResult<BtrakJsonResult> UpsertShiftTiming(ShiftTimingInputModel shiftTimingInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertShiftTiming", "shiftTimingInputModel", shiftTimingInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? shiftTimingIdReturned = _hrManagementService.UpsertShiftTiming(shiftTimingInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertShiftTiming", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertShiftTiming", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = shiftTimingIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertShiftTiming", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeShift)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeShift(EmployeeShiftInputModel employeeShiftInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeShift", "employeeShiftInputModel", employeeShiftInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeShiftIdReturned = _hrManagementService.UpsertEmployeeShift(employeeShiftInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeShift", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeShift", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeShiftIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeShift", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertContractType)]
        public JsonResult<BtrakJsonResult> UpsertContractType(ContractTypeUpsertInputModel contractTypeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertContractType", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? contractTypeIdReturned = _hrManagementService.UpsertContractType(contractTypeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertContractType", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertContractType", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = contractTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertContractType", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetContractTypes)]
        public JsonResult<BtrakJsonResult> GetContractTypes(ContractTypeSearchInputModel contractTypeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetContractTypes", "HrManagement Api"));

                if (contractTypeSearchInputModel == null)
                {
                    contractTypeSearchInputModel = new ContractTypeSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ContractTypeApiReturnModel> contractTypes = _hrManagementService.GetContractTypes(contractTypeSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetContractTypes", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetContractTypes", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = contractTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetContractTypes", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetContractTypeById)]
        public JsonResult<BtrakJsonResult> GetContractTypeById(ContractTypeSearchInputModel contractTypeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetContractTypeById", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                ContractTypeApiReturnModel contractTypeApiReturnModel = _hrManagementService.GetContractTypeById(contractTypeSearchInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetContractTypeById", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetContractTypeById", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = contractTypeApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetContractTypeById", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertDepartment)]
        public JsonResult<BtrakJsonResult> UpsertDepartment(DepartmentUpsertInputModel departmentUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDepartment", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? departmentIdReturned = _hrManagementService.UpsertDepartment(departmentUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDepartment", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDepartment", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = departmentIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDepartment", "HrManagementApiController ", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDepartments)]
        public JsonResult<BtrakJsonResult> GetDepartments(DepartmentSearchInputModel departmentSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDepartments", "HrManagement Api"));

                if (departmentSearchInputModel == null)
                {
                    departmentSearchInputModel = new DepartmentSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<DepartmentApiReturnModel> departments = _hrManagementService.GetDepartments(departmentSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDepartments", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDepartments", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = departments, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDepartments", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetDepartmentById)]
        public JsonResult<BtrakJsonResult> GetDepartmentById(DepartmentSearchInputModel departmentSearchInputModel)
        {
            try
            {

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDepartmentById", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                DepartmentApiReturnModel departmentApiReturnModel = _hrManagementService.GetDepartmentById(departmentSearchInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDepartmentById", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDepartmentById", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = departmentApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDepartmentById", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCurrency)]
        public JsonResult<BtrakJsonResult> UpsertCurrency(CurrencyInputModel currencyInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Currency", "currencyInputModel", currencyInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? currencyIdReturned = _hrManagementService.UpsertCurrency(currencyInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Currency", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Currency", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = currencyIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCurrency", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCurrencies)]
        public JsonResult<BtrakJsonResult> GetCurrencies(CurrencySearchCriteriaInputModel currencySearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Currencies", "currencySearchCriteriaInputModel", currencySearchCriteriaInputModel, "Hr Management Api"));
                if (currencySearchCriteriaInputModel == null)
                {
                    currencySearchCriteriaInputModel = new CurrencySearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Currency list");
                List<CurrencyOutputModel> currencyList = _hrManagementService.SearchCurrency(currencySearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Currencies", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Currencies", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = currencyList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchCurrency)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCurrencyConversion)]
        public JsonResult<BtrakJsonResult> UpsertCurrencyConversion(CurrencyConversionInputModel currencyConversionInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Currency Conversion", "currencyConversionInputModel", currencyConversionInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? currencyConversionIdReturned = _hrManagementService.UpsertCurrencyConversion(currencyConversionInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Currency Conversion", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Currency Conversion", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = currencyConversionIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCurrencyConversion", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCurrencyConversions)]
        public JsonResult<BtrakJsonResult> GetCurrencyConversions(CurrencyConversionSearchCriteriaInputModel currencyConversionSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Currency Conversions", "currencyConversionSearchCriteriaInputModel", currencyConversionSearchCriteriaInputModel, "Hr Management Api"));
                if (currencyConversionSearchCriteriaInputModel == null)
                {
                    currencyConversionSearchCriteriaInputModel = new CurrencyConversionSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Currency Conversion list");
                List<CurrencyConversionOutputModel> currencyConversionList = _hrManagementService.GetCurrencyConversions(currencyConversionSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Currency Conversions", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Currency Conversions", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = currencyConversionList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchCurrencyConversion)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPaymentMethod)]
        public JsonResult<BtrakJsonResult> UpsertPaymentMethod(PaymentMethodInputModel paymentMethodInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Payment Method", "paymentMethodInputModel", paymentMethodInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? paymentIdReturned = _hrManagementService.UpsertPaymentMethod(paymentMethodInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Payment Method", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Payment Method", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = paymentIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPaymentMethod", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPaymentMethod)]
        public JsonResult<BtrakJsonResult> GetPaymentMethod(PaymentMethodSearchCriteriaInputModel paymentMethodSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Payment Method", "paymentMethodSearchCriteriaInputModel", paymentMethodSearchCriteriaInputModel, "Hr Management Api"));
                if (paymentMethodSearchCriteriaInputModel == null)
                {
                    paymentMethodSearchCriteriaInputModel = new PaymentMethodSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Payment Method list");
                List<PaymentMethodOutputModel> paymentMethodList = _hrManagementService.GetPaymentMethod(paymentMethodSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Payment Method", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Payment Method", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = paymentMethodList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchPaymentMethod)
                });

                return null;
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertDesignation)]
        public JsonResult<BtrakJsonResult> UpsertDesignation(DesignationUpsertInputModel designationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDesignation", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? designationIdReturned = _hrManagementService.UpsertDesignation(designationUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDesignation", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDesignation", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = designationIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDesignation", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDesignations)]
        public JsonResult<BtrakJsonResult> GetDesignations(DesignationSearchInputModel designationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDesignations", "HrManagement Api"));

                if (designationSearchInputModel == null)
                {
                    designationSearchInputModel = new DesignationSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<DesignationApiReturnModel> designations = _hrManagementService.GetDesignations(designationSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDesignations", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDesignations", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = designations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDesignations", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayGrade)]
        public JsonResult<BtrakJsonResult> UpsertPayGrade(PayGradeUpsertInputModel payGradeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayGrade", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? payGradeIdReturned = _hrManagementService.UpsertPayGrade(payGradeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayGrade", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertPayGrade", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = payGradeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayGrade", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayGrades)]
        public JsonResult<BtrakJsonResult> GetPayGrades(PayGradeSearchInputModel payGradeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayGrades", "HrManagement Api"));

                if (payGradeSearchInputModel == null)
                {
                    payGradeSearchInputModel = new PayGradeSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<PayGradeApiReturnModel> payGrades = _hrManagementService.GetPayGrades(payGradeSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayGrades", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayGrades", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = payGrades, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayGrades", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertBreakType)]
        public JsonResult<BtrakJsonResult> UpsertBreakType(BreakTypeUpsertInputModel breakTypeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertBreakType", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? breakTypeIdReturned = _hrManagementService.UpsertBreakType(breakTypeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBreakType", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBreakType", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = breakTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBreakType", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetBreakTypes)]
        public JsonResult<BtrakJsonResult> GetBreakTypes(BreakTypeSearchInputModel breakTypeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBreakTypes", "HrManagement Api"));

                if (breakTypeSearchInputModel == null)
                {
                    breakTypeSearchInputModel = new BreakTypeSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<BreakTypeApiReturnModel> breakTypes = _hrManagementService.GetBreakTypes(breakTypeSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBreakTypes", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBreakTypes", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = breakTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBreakTypes", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertRateType)]
        public JsonResult<BtrakJsonResult> UpsertRateType(RateTypeInputModel rateTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Rate Type", "rateTypeInputModel", rateTypeInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? rateTypeIdReturned = _hrManagementService.UpsertRateType(rateTypeInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Rate Type", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Rate Type", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = rateTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRateType", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchRateType)]
        public JsonResult<BtrakJsonResult> SearchRateType(RateTypeSearchCriteriaInputModel rateTypeSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Rate Type", "rateTypeSearchCriteriaInputModel", rateTypeSearchCriteriaInputModel, "Hr Management Api"));
                if (rateTypeSearchCriteriaInputModel == null)
                {
                    rateTypeSearchCriteriaInputModel = new RateTypeSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Rate Type list");
                List<RateTypeOutputModel> rateTypeList = _hrManagementService.SearchRateType(rateTypeSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Rate Type", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Rate Type", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = rateTypeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchRateType)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.AssignPayGradeRates)]
        public JsonResult<BtrakJsonResult> AssignPayGradeRates(PayGradeRatesInputModel payGradeRatesInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "AssignPayGradeRates", "payGradeRatesInputModel", payGradeRatesInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? payGradeRateIdReturned = _hrManagementService.AssignPayGradeRates(payGradeRatesInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeContactDetails", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeContactDetails", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = payGradeRateIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AssignPayGradeRates", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayGradeRates)]
        public JsonResult<BtrakJsonResult> GetPayGradeRates(PayGradeRatesSearchCriteriaInputModel payGradeRatesSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Pay Grade Rates", "payGradeRatesSearchCriteriaInputModel", payGradeRatesSearchCriteriaInputModel, "Hr Management Api"));
                if (payGradeRatesSearchCriteriaInputModel == null)
                {
                    payGradeRatesSearchCriteriaInputModel = new PayGradeRatesSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Pay Grade Rate list");
                List<PayGradeRatesOutputModel> payGradeRateList = _hrManagementService.GetPayGradeRates(payGradeRatesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Pay Grade Rates", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Pay Grade Rates", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = payGradeRateList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchPayGradeRates)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeLicenceDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeLicenceDetails(EmployeeLicenceDetailsInputModel employeeLicenceDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Licence Details", "employeeLicenceDetailsInputModel", employeeLicenceDetailsInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? licenceDetailIdReturned = _hrManagementService.UpsertEmployeeLicenceDetails(employeeLicenceDetailsInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Licence Details", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Licence Details", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = licenceDetailIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeLicenceDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeePersonalDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmployeePersonalDetails(EmployeePersonalDetailsInputModel employeePersonalDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeePersonalDetails", "employeePersonalDetailsInputModel", employeePersonalDetailsInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeIdReturned = _hrManagementService.UpsertEmployeePersonalDetails(employeePersonalDetailsInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeePersonalDetails", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeePersonalDetails", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeePersonalDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeContactDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeContactDetails(EmployeeContactDetailsInputModel employeeContactDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeContactDetails", "employeeContactDetailsInputModel", employeeContactDetailsInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? contactDetailsIdReturned = _hrManagementService.UpsertEmployeeContactDetails(employeeContactDetailsInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeContactDetails", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeContactDetails", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = contactDetailsIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeContactDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeEmergencyContactDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeEmergencyContactDetails(EmployeeEmergencyContactDetailsInputModel employeeEmergencyContactDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Emergency Contact Details", "employeeEmergencyContactDetailsInputModel", employeeEmergencyContactDetailsInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeEmergencyContactIdReturned = _hrManagementService.UpsertEmployeeEmergencyContactDetails(employeeEmergencyContactDetailsInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Emergency Contact Details", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Emergency Contact Details", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeEmergencyContactIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeEmergencyContactDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmploymentContract)]
        public JsonResult<BtrakJsonResult> UpsertEmploymentContract(EmploymentContractInputModel employmentContractInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employment Contract", "employmentContractInputModel", employmentContractInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employmentContractIdReturned = _hrManagementService.UpsertEmploymentContract(employmentContractInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employment Contract", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employment Contract", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employmentContractIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmploymentContract", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeJob)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeJob(EmployeeJobInputModel employeeJobInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Job", "employeeJobInputModel", employeeJobInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeJobIdReturned = _hrManagementService.UpsertEmployeeJob(employeeJobInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Job", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Job", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeJobIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeJob", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeImmigrationDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeImmigrationDetails(Btrak.Models.Employee.EmployeeImmigrationDetailsInputModel employeeImmigrationDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Immigration Details", "employeeImmigrationDetailsInputModel", employeeImmigrationDetailsInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeImmigrationIdReturned = _hrManagementService.UpsertEmployeeImmigrationDetails(employeeImmigrationDetailsInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Immigration Details", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Immigration Details", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeImmigrationIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeImmigrationDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeSalaryDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeSalaryDetails(Btrak.Models.Employee.EmployeeSalaryDetailsInputModel employeeSalaryDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Salary Details", "employeeSalaryDetailsInputModel", employeeSalaryDetailsInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeSalaryDetailsIdReturned = _hrManagementService.UpsertEmployeeSalaryDetails(employeeSalaryDetailsInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Salary Details", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Salary Details", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeSalaryDetailsIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeSalaryDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeReportTo)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeReportTo(EmployeeReportToInputModel employeeReportToInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Report To", "employeeReportToInputModel", employeeReportToInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeReportToIdReturned = _hrManagementService.UpsertEmployeeReportTo(employeeReportToInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Report To", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Report To", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeReportToIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeReportTo", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeWorkExperience)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeWorkExperience(EmployeeWorkExperienceInputModel employeeWorkExperienceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Work Experience", "employeeWorkExperienceInputModel", employeeWorkExperienceInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeWorkExperienceIdReturned = _hrManagementService.UpsertEmployeeWorkExperience(employeeWorkExperienceInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Work Experience", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Work Experience", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeWorkExperienceIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeWorkExperience", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeEducationDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeEducationDetails(Btrak.Models.Employee.EmployeeEducationDetailsInputModel employeeEducationDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Education Details", "employeeEducationDetailsInputModel", employeeEducationDetailsInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeEducationDetailsIdReturned = _hrManagementService.UpsertEmployeeEducationDetails(employeeEducationDetailsInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Education Details", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Education Details", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeEducationDetailsIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeEducationDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeSkills)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeSkills(EmployeeSkillsInputModel employeeSkillsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Skills", "employeeSkillsInputModel", employeeSkillsInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeSkillsIdReturned = _hrManagementService.UpsertEmployeeSkills(employeeSkillsInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Skills", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Skills", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeSkillsIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeSkills", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeLanguages)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeLanguages(EmployeeLanguagesInputModel employeeLanguagesInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Languages", "employeeLanguagesInputModel", employeeLanguagesInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeLanguageIdReturned = _hrManagementService.UpsertEmployeeLanguages(employeeLanguagesInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Languages", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Languages", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeLanguageIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeLanguages", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeMemberships)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeMemberships(EmployeeMembershipUpsertInputModel employeeMembershipUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeMemberships", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? employeeIdReturned = _hrManagementService.UpsertEmployeeMemberships(employeeMembershipUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeMemberships", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeMemberships", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeMemberships", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertRelationship)]
        public JsonResult<BtrakJsonResult> UpsertRelationship(RelationshipUpsertModel relationshipUpsertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Relationship", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? relationshipIdReturned = _hrManagementService.UpsertRelationShip(relationshipUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Relationship", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Relationship", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = relationshipIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRelationship", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchRelationship)]
        public JsonResult<BtrakJsonResult> SearchRelationships(RelationShipTypeSearchCriteriaInputModel relationShipTypeSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search relationship", "relationShipTypeSearchCriteriaInputModel", relationShipTypeSearchCriteriaInputModel, "Hr Management Api"));
                if (relationShipTypeSearchCriteriaInputModel == null)
                {
                    relationShipTypeSearchCriteriaInputModel = new RelationShipTypeSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting relationships list");

                List<RelationShipTypeSearchCriteriaInputModel> rateTypeList = _hrManagementService.SearchRelationShip(relationShipTypeSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search relationship", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search relationship", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = rateTypeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchRelationship)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeBankDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeBankDetails(EmployeeBankDetailUpsertInputModel employeeBankDetailUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeBankDetails", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? employeeIdReturned = _hrManagementService.UpsertEmployeeBankDetails(employeeBankDetailUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeBankDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeBankDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeBankDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllBankDetails)]
        public JsonResult<BtrakJsonResult> GetAllBankDetails(EmployeeBankDetailSearchInputModel employeeBankDetailSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllBankDetails", "HrManagement Api"));

                if (employeeBankDetailSearchInputModel == null)
                {
                    employeeBankDetailSearchInputModel = new EmployeeBankDetailSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EmployeeBankDetailApiReturnModel> employeeBankDetails = _hrManagementService.GetAllBankDetails(employeeBankDetailSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllBankDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllBankDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeBankDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllBankDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeDetails)]
        public JsonResult<BtrakJsonResult> GetEmployeeDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeDetails", "HrManagement Api"));

                if (employeeDetailSearchCriteriaInputModel == null)
                {
                    employeeDetailSearchCriteriaInputModel = new EmployeeDetailSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                EmployeeDetailsApiReturnModel employeeDetails = _hrManagementService.GetEmployeeDetails(employeeDetailSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (employeeDetails.employeeRateTagDetails != null && employeeDetailSearchCriteriaInputModel.EmployeeDetailType == "RateTagDetails")
                {
                    foreach (var item in employeeDetails.employeeRateTagDetails)
                    {
                        if (item.RateTagDetails != null)
                        {
                            item.RateTagDetailsList = JsonConvert.DeserializeObject<List<RateTagForOutputModel>>(item.RateTagDetails);
                        }
                        else
                        {
                            item.RateTagDetailsList = new List<RateTagForOutputModel>();
                        }
                    }
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeDependentContacts)]
        public JsonResult<BtrakJsonResult> SearchEmployeeDependentContacts(EmployeeDependentContactSearchInputModel employeeDependentContactSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search relationship", "employeeDependentContactSearchInputModel", employeeDependentContactSearchInputModel, "Hr Management Api"));
                if (employeeDependentContactSearchInputModel == null)
                {
                    employeeDependentContactSearchInputModel = new EmployeeDependentContactSearchInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting employee dependent contact list");

                List<EmployeeDependentContactModel> dependentConatctsList = _hrManagementService.SearchEmployeeDependentContacts(employeeDependentContactSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search employee dependent contact list", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search employee dependent contact list", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = dependentConatctsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchEmployeeDependentContacts)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeDependentContactsById)]
        public JsonResult<BtrakJsonResult> GetEmployeeDependentContactsById(EmployeeDependentContactSearchInputModel employeeDependentContactSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search relationship", "employeeDependentContactSearchInputModel", employeeDependentContactSearchInputModel, "Hr Management Api"));
                if (employeeDependentContactSearchInputModel == null)
                {
                    employeeDependentContactSearchInputModel = new EmployeeDependentContactSearchInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting employee dependent contact list");

                EmployeeDependentContactModel dependentConatctsList = _hrManagementService.GetEmployeeDependentContactsById(employeeDependentContactSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search employee dependent contact list", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search employee dependent contact list", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = dependentConatctsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchEmployeeDependentContacts)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeLanguageDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeLanguageDetails(EmployeeLanguageDetailsInputModel getEmployeeLanguageDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeLanguageDetails", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                EmployeeLanguageDetailsApiReturnModel employeeLanguageDetailsApiReturnModel = _hrManagementService.SearchEmployeeLanguageDetails(getEmployeeLanguageDetailsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeLanguageDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeLanguageDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeLanguageDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeLanguageDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeImmigrationDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeImmigrationDetails(Btrak.Models.HrManagement.EmployeeImmigrationDetailsInputModel getEmployeeImmigrationDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeImmigrationDetails", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                EmployeeImmigrationDetailsApiReturnModel employeeImmigrationDetailsApiReturnModel = _hrManagementService.SearchEmployeeImmigrationDetails(getEmployeeImmigrationDetailsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeImmigrationDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeImmigrationDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeImmigrationDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeImmigrationDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeEducationDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeEducationDetails(Btrak.Models.HrManagement.EmployeeEducationDetailsInputModel getEmployeeEducationDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeEducationDetails", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                EmployeeEducationDetailsApiReturnModel employeeEducationDetailsApiReturnModel = _hrManagementService.SearchEmployeeEducationDetails(getEmployeeEducationDetailsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeEducationDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeEducationDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeEducationDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeEducationDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeEmergencyContactDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeEmergencyContactDetails(EmployeeEmergencyDetailsDetailsInputModel getEmployeeEmergencyDetailsDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeEmergencyContactDetails", "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                EmployeeEmergencyContactDetailsApiReturnModel employeeEmergencyContactDetailsApiReturnModel = _hrManagementService.SearchEmployeeEmergencyContactDetails(getEmployeeEmergencyDetailsDetailsInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeEmergencyContactDetails", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeEmergencyContactDetails", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeEmergencyContactDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeEmergencyContactDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchShiftTiming)]
        public JsonResult<BtrakJsonResult> GetShiftTimings(ShiftTimingsSearchInputModel shiftTimingsSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get shift timings", "ShiftTimingsSearchInputModel", shiftTimingsSearchInputModel, "Hr Management Api"));
                if (shiftTimingsSearchInputModel == null)
                {
                    shiftTimingsSearchInputModel = new ShiftTimingsSearchInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Currency list");
                List<ShiftTimingsSearchOutputModel> shiftTimingsList = _hrManagementService.SearchShiftTimings(shiftTimingsSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Shift Timings", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Shift Timings", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = shiftTimingsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetShiftTimings)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMyTeamMembersList)]
        public JsonResult<BtrakJsonResult> GetMyTeamMembersList(SearchModel searchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get MyTeamMembers List", "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<TeamMemberOutputModel> teamMembersList = _hrManagementService.GetMyTeamMembersList(searchModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get MyTeamMembers List", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get MyTeamMembers List", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = teamMembersList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMyTeamMembersList", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeReportToMembers)]
        public JsonResult<BtrakJsonResult> GetEmployeeReportToMembers(Guid? userId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeReportToMembers", "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<UserOutputModel> members = _hrManagementService.GetEmployeeReportToMembers(userId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeReportToMembers", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeReportToMembers", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = members, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeReportToMembers", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [Route(RouteConstants.GetMyEmployeeId)]
        public JsonResult<BtrakJsonResult> GetMyEmployeeId(Guid? userId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get My Employee Id", "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? myEmployeeId = _hrManagementService.GetMyEmployeeId(userId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get My Employee Id", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get My Employee Id", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = myEmployeeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMyEmployeeId", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeLicenseDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeLicenseDetails(EmployeeLicenseDetailsInputModel getEmployeeLicenseDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeLicenseById", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                EmployeeLicenceDetailsApiReturnModel employeeLicenceDetailsApiReturnModel = _hrManagementService.SearchEmployeeLicenseDetails(getEmployeeLicenseDetailsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeLicenseById", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeLicenseById", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeLicenceDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeLicenseDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeSalaryDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeSalaryDetails(Btrak.Models.HrManagement.EmployeeSalaryDetailsInputModel getEmployeeSalaryDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeEmployeeSalaryDetails", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                EmployeeSalaryDetailsApiReturnModel employeeSalaryDetailsApiReturnModel = _hrManagementService.SearchEmployeeSalaryDetails(getEmployeeSalaryDetailsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeEmployeeSalaryDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeEmployeeSalaryDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeSalaryDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeSalaryDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeSkillDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeSkillDetails(EmployeeSkillDetailsInputModel getEmployeeSkillDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeSkillDetails", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                EmployeeSkillDetailsApiReturnModel employeeSkillDetailsApiReturnModel = _hrManagementService.SearchEmployeeSkillDetails(getEmployeeSkillDetailsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeSkillDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeSkillDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeSkillDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeSkillDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeWorkExperienceDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeWorkExperienceDetails(EmployeeWorkExperienceDetailsInputModel getEmployeeWorkExperienceDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeWorkExperienceDetails", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                EmployeeWorkExperienceDetailsApiReturnModel employeeWorkExperienceDetailsApiReturnModel = _hrManagementService.SearchEmployeeWorkExperienceDetails(getEmployeeWorkExperienceDetailsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeWorkExperienceDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeWorkExperienceDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeWorkExperienceDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeWorkExperienceDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeMembershipDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeMembershipDetails(EmployeeMembershipDetailsInputModel getEmployeeMembershipDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeMembershipDetails", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                EmployeeMembershipDetailsApiReturnModel employeeMembershipDetailsApiReturnModel = _hrManagementService.SearchEmployeeMembershipDetails(getEmployeeMembershipDetailsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeMembershipDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeMembershipDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeMembershipDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeMembershipDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeReportToDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeReportToDetails(EmployeeReportToDetailsInputModel getEmployeeReportToDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeReportToDetails", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                EmployeeReportToDetailsApiReturnModel employeeReportToDetailsApiReturnModel = _hrManagementService.SearchEmployeeReportToDetails(getEmployeeReportToDetailsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeReportToDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeReportToDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeReportToDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeReportToDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeContractDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeContractDetails(EmployeeContractDetailsInputModel getEmployeeContractDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeContractDetails", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                EmploymentContractDetailsApiReturnModel employmentContractDetailsApiReturnModel = _hrManagementService.SearchEmployeeContractDetails(getEmployeeContractDetailsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeContractDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeContractDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employmentContractDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeContractDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeOverViewDetails)]
        public JsonResult<BtrakJsonResult> GetEmployeeOverViewDetails(Guid? employeeId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info("EmployeeId :- " + employeeId);

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Employee Over View Details list in Hr Management Api");

                List<EmployeeOverViewDetailsOutputModel> employeeOverViewDetailsList = _hrManagementService.GetEmployeeOverViewDetails(employeeId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee Over View Details", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee Over View Details", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = employeeOverViewDetailsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetEmployeeOverViewDetails)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetMyEmployeeDetails)]
        public JsonResult<BtrakJsonResult> GetMyEmployeeDetails(Guid employeeId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get my Employee Details", "Hr Management Api"));
                LoggingManager.Info("EmployeeId :- " + employeeId);

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting my Employee Details in Hr Management Api");

                EmployeeDetailsOutputModel employeeOverViewDetailsList = _hrManagementService.GetMyEmployeeDetails(employeeId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get my Employee Details", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get my Employee Details", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = employeeOverViewDetailsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetMyEmployeeDetails)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertShiftWeek)]
        public JsonResult<BtrakJsonResult> UpsertShiftWeek(ShiftWeekUpsertInputModel shiftWeekInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertShiftWeek", "shiftWeekInputModel", shiftWeekInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? shiftTimingIdReturned = _hrManagementService.UpsertShiftWeek(shiftWeekInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertShiftWeek", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertShiftWeek", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = shiftTimingIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertShiftWeek", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetShiftWeek)]
        public JsonResult<BtrakJsonResult> GetShiftWeek(ShiftWeekSearchInputModel shiftTimingsSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get shift week", "ShiftTimingsSearchInputModel", shiftTimingsSearchInputModel, "Hr Management Api"));
                if (shiftTimingsSearchInputModel == null)
                {
                    shiftTimingsSearchInputModel = new ShiftWeekSearchInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                List<ShiftWeekSearchOutputModel> shiftWeeksList = _hrManagementService.GetShiftWeek(shiftTimingsSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Shift week", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Shift week", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = shiftWeeksList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetShiftTimings)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetShiftTimingOptions)]
        public JsonResult<BtrakJsonResult> GetShiftTimingOptions()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetShiftTimingOptions", "StatusReporting Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<StatusReportingOptionsApiReturnModel> configurationOptions = _hrManagementService.GetShiftTimingOptions(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetShiftTimingOptions", "StatusReporting Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetShiftTimingOptions", "StatusReporting Api"));

                return Json(new BtrakJsonResult { Data = configurationOptions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetShiftTimingOptions", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertShiftException)]
        public JsonResult<BtrakJsonResult> UpsertShiftException(ShiftExceptionUpsertInputModel shiftExceptionUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertShiftException", "shiftExceptionUpsertInputModel", shiftExceptionUpsertInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? shiftExceptionIdReturned = _hrManagementService.UpsertShiftException(shiftExceptionUpsertInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertShiftException", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertShiftException", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = shiftExceptionIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertShiftException", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetShiftExcpetion)]
        public JsonResult<BtrakJsonResult> GetShiftExcpetion(ShiftExceptionSearchInputModel shiftExceptionSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get shift Excpetion", "shiftExceptionSearchInputModel", shiftExceptionSearchInputModel, "Hr Management Api"));
                if (shiftExceptionSearchInputModel == null)
                {
                    shiftExceptionSearchInputModel = new ShiftExceptionSearchInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                List<ShiftExceptionSearchOutputModel> shiftExceptionList = _hrManagementService.GetShiftException(shiftExceptionSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Shift Excpetion", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Shift Excpetion", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = shiftExceptionList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetShiftTimings)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeShift)]
        public JsonResult<BtrakJsonResult> GetEmployeeShift(EmployeeShiftSearchInputModel employeeShiftSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Employee shift ", "employeeShiftSearchInputModel", employeeShiftSearchInputModel, "Hr Management Api"));
                if (employeeShiftSearchInputModel == null)
                {
                    employeeShiftSearchInputModel = new EmployeeShiftSearchInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                List<EmployeeShiftSearchOutputModel> shiftExceptionList = _hrManagementService.GetEmployeeShift(employeeShiftSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee Shift", "Hr Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee Shift", "Hr Management Api"));
                return Json(new BtrakJsonResult { Data = shiftExceptionList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetShiftTimings)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertWebHook)]
        public JsonResult<BtrakJsonResult> UpsertWebHook(WebHookUpsertInputModel webhookUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertWebHook", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? webhookIdReturned = _hrManagementService.UpsertWebHook(webhookUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWebHook", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWebHook", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = webhookIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertWebHook", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWebHooks)]
        public JsonResult<BtrakJsonResult> GetWebHooks(WebHookSearchInputModel webhookSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWebHooks", "HrManagement Api"));

                if (webhookSearchInputModel == null)
                {
                    webhookSearchInputModel = new WebHookSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<WebHookApiReturnModel> webhooks = _hrManagementService.GetWebHooks(webhookSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWebHooks", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWebHooks", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = webhooks, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWebHooks", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetWebHookById)]
        public JsonResult<BtrakJsonResult> GetWebHookById(WebHookSearchInputModel webhookSearchInputModel)
        {
            try
            {

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWebHookById", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                WebHookApiReturnModel webhookApiReturnModel = _hrManagementService.GetWebHookById(webhookSearchInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWebHookById", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWebHookById", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = webhookApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWebHookById", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertHtmlTemplate)]
        public JsonResult<BtrakJsonResult> UpsertHtmlTemplate(HtmlTemplateUpsertInputModel htmlTemplateUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertHtmlTemplate", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? htmlTemplateIdReturned = _hrManagementService.UpsertHtmlTemplate(htmlTemplateUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertHtmlTemplate", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertHtmlTemplate", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = htmlTemplateIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertHtmlTemplate", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetHtmlTemplates)]
        public JsonResult<BtrakJsonResult> GetHtmlTemplates(HtmlTemplateSearchInputModel htmlTemplateUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHtmlTemplates", "HrManagement Api"));

                if (htmlTemplateUpsertInputModel == null)
                {
                    htmlTemplateUpsertInputModel = new HtmlTemplateSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<HtmlTemplateApiReturnModel> htmltemplates = _hrManagementService.GetHtmlTemplates(htmlTemplateUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHtmlTemplates", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHtmlTemplates", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = htmltemplates, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHtmlTemplates", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetHtmlTemplateById)]
        public JsonResult<BtrakJsonResult> GetHtmlTemplateById(HtmlTemplateSearchInputModel htmlTemplateUpsertInputModel)
        {
            try
            {

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHtmlTemplateById", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                HtmlTemplateApiReturnModel htmlTemplateApiReturnModel = _hrManagementService.GetHtmlTemplateById(htmlTemplateUpsertInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHtmlTemplateById", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHtmlTemplateById", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = htmlTemplateApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHtmlTemplateById", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertEmployeeRatesheetDetails)]
        public JsonResult<BtrakJsonResult> InsertEmployeeRatesheetDetails(EmployeeRateSheetDetailsAddInputModel employeeRateSheetDetailsAddInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Ratesheet Details", "employeeRateSheetDetailsAddInputModel", employeeRateSheetDetailsAddInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeRatesheetDetailsIdReturned = _hrManagementService.InsertEmployeeRatesheetDetails(employeeRateSheetDetailsAddInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Ratesheet Details", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Ratesheet Details", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeRatesheetDetailsIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertEmployeeRatesheetDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateEmployeeRatesheetDetails)]
        public JsonResult<BtrakJsonResult> UpdateEmployeeRatesheetDetails(EmployeeRatesheetDetailsEditInputModel employeeRateSheetDetailsAddInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Ratesheet Details", "employeeRateSheetDetailsAddInputModel", employeeRateSheetDetailsAddInputModel, "HrManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? employeeRatesheetDetailsIdReturned = _hrManagementService.UpdateEmployeeRatesheetDetails(employeeRateSheetDetailsAddInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Ratesheet Details", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employee Ratesheet Details", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = employeeRatesheetDetailsIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateEmployeeRatesheetDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchEmployeeRateSheetDetails)]
        public JsonResult<BtrakJsonResult> SearchEmployeeRateSheetDetails(EmployeeRateSheetDetailsInputModel employeeRateSheetDetailsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeRateSheetDetailsInputModel", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                EmployeeRateSheetDetailsApiReturnModel employeeRateSheetDetailsApiReturnModel = _hrManagementService.SearchEmployeeRateSheetDetails(employeeRateSheetDetailsInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeEmployeeRateSheetDetails", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "EmployeeEmployeeRateSheetDetails", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeRateSheetDetailsApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeRateSheetDetails", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.EmployeeUpload)]
        public JsonResult<BtrakJsonResult> EmployeeUpload(List<EmployeePersonalDetailsInputModel> employeePersonalDetailsInputModelList)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeUpload", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                BackgroundJob.Enqueue(() => _hrManagementService.EmployeeUpload(employeePersonalDetailsInputModelList, LoggedInContext, validationMessages));
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeePersonalDetails", "HrManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Employee Upload", "HrManagement Api"));
                return Json(new BtrakJsonResult { Data = true, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "EmployeeUpload", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeUploadTemplate)]
        public async Task<HttpResponseMessage> GetEmployeeUploadTemplate()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeUploadTemplate", "HrManagement Api"));

                var path = GenerateEmployeeTemplate(LoggedInContext);

                var result = File.ReadAllBytes(path);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeUploadTemplate", "HrManagement Api"));

                return await TaskWrapper.ExecuteFunctionOnBackgroundThread(() =>
                {
                    var response = Request.CreateResponse(HttpStatusCode.OK);
                    response.Content = new ByteArrayContent(result);
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/xlsx");
                    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("inline")
                    {
                        FileName = "EmployeeUploadTemplate.xlsx"
                    };
                    return response;
                });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeUploadTemplate", "HrManagementApiController ", exception.Message), exception);

                return null;
            }
        }

        public string GenerateEmployeeTemplate(LoggedInContext loggedInContext)
        {
            var details = _companyStructureService.GetCompanyDetails(loggedInContext, new List<ValidationMessage>());
            var path = "";
            if (details.IndustryId.ToString().ToLower() == "7499f5e3-0ef2-4044-b840-2411b68302f9")
            {
                path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/EmployeeExampleWithoutPayrollDetails.xlsx");
            }
            else
            {
                path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/EmployeeExample.xlsx");
            }
            using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(path, true))
            {
                WorkbookPart workbookPart = spreadSheet.WorkbookPart;
                spreadSheet.WorkbookPart.Workbook.Save();
                spreadSheet.Close();
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenerateEmployeeTemplate", "HrManagementApi"));
            return path;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertBadge)]
        public JsonResult<BtrakJsonResult> UpsertBadge(BadgeModel badgeModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertBadge", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? badgeId = _hrManagementService.UpsertBadge(badgeModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBadge", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBadge", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = badgeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBadge", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetBadges)]
        public JsonResult<BtrakJsonResult> GetBadges(BadgeModel badgeModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBadges", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                List<BadgeModel> badges = _hrManagementService.GetBadges(badgeModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBadges", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBadges", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = badges, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBadges", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.AssignBadgeToEmployee)]
        public JsonResult<BtrakJsonResult> AssignBadgeToEmployee(EmployeeBadgeModel badgeModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AssignBadgeToEmployee", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? badgeId = _hrManagementService.AssignBadgeToEmployee(badgeModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AssignBadgeToEmployee", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AssignBadgeToEmployee", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = badgeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AssignBadgeToEmployee", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetBadgesAssignedToEmployee)]
        public JsonResult<BtrakJsonResult> GetBadgesAssignedToEmployee(EmployeeBadgeModel badgeModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBadgesAssignedToEmployee", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                List<EmployeeBadgeModel> badges = _hrManagementService.GetBadgesAssignedToEmployee(badgeModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBadgesAssignedToEmployee", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBadgesAssignedToEmployee", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = badges, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBadgesAssignedToEmployee", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAnnouncement)]
        public JsonResult<BtrakJsonResult> UpsertAnnouncement(AnnouncementModel announcementModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAnnouncement", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? announcementId = _hrManagementService.UpsertAnnouncement(announcementModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAnnouncement", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAnnouncement", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = announcementId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAnnouncement", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAnnouncements)]
        public JsonResult<BtrakJsonResult> GetAnnouncements(AnnouncementModel announcementModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAnnouncements", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                List<AnnouncementModel> announcements = _hrManagementService.GetAnnouncements(announcementModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAnnouncements", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAnnouncements", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = announcements, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAnnouncements", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertGrade)]
        public JsonResult<BtrakJsonResult> UpsertGrade(GradeInputModel gradeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGrade", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? gradeId = _hrManagementService.UpsertGrade(gradeInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertGrade", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertGrade", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = gradeId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGrade", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetGrades)]
        public JsonResult<BtrakJsonResult> GetGrades(GetGradesInputModel getGradesInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGrades", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                List<GetGradesOutputModel> grades = _hrManagementService.GetGrades(getGradesInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGrades", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGrades", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = grades, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGrades", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeGrade)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeGrade(EmployeeGradeInputModel employeeGradeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeGrade", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? employeeGrade = _hrManagementService.UpsertEmployeeGrade(employeeGradeInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeGrade", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeGrade", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeGrade, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeGrade", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeGrades)]
        public JsonResult<BtrakJsonResult> GetEmployeeGrades(EmployeeGradeSearchInputModel employeeGradeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeGrades", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                List<EmployeeGradeApiOutputModel> employeeGrades = _hrManagementService.GetEmployeeGrades(employeeGradeSearchInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeGrades", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeGrades", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeGrades, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeGrades", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertReminder)]
        public JsonResult<BtrakJsonResult> UpsertReminder(ReminderModel reminderModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertReminder", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? reminderId = _hrManagementService.UpsertReminder(reminderModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertReminder", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertReminder", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = reminderId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertReminder", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetReminders)]
        public JsonResult<BtrakJsonResult> GetReminders(ReminderModel reminderModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetReminders", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                List<ReminderModel> reminders = _hrManagementService.GetReminders(reminderModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetReminders", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetReminders", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = reminders, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetReminders", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeDetailsHistory)]
        public JsonResult<BtrakJsonResult> GetEmployeeDetailsHistory(EmployeeDetailsHistoryApiInputModel employeeDetailsHistoryApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeDetailsHistory", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                List<EmployeeDetailsHistoryApiReturnModel> employeeDetailsHistory = _hrManagementService.GetEmployeeDetailsHistory(employeeDetailsHistoryApiInputModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeDetailsHistory", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeDetailsHistory", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = employeeDetailsHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeDetailsHistory", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDocumentTemplates)]
        public JsonResult<BtrakJsonResult> GetDocumentTemplates(DocumentTemplateModel documentTemplateModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDocumentTemplates", "HrManagement Api"));

                if (documentTemplateModel == null)
                {
                    documentTemplateModel = new DocumentTemplateModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<DocumentTemplateModel> htmltemplates = _hrManagementService.GetDocumentTemplates(documentTemplateModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDocumentTemplates", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDocumentTemplates", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = htmltemplates, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDocumentTemplates", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertDocumentTemplate)]
        public JsonResult<BtrakJsonResult> UpsertDocumentTemplate(DocumentTemplateModel documentTemplateModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDocumentTemplate", "HrManagement Api"));

                if (documentTemplateModel == null)
                {
                    documentTemplateModel = new DocumentTemplateModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? htmltemplates = _hrManagementService.UpsertDocumentTemplate(documentTemplateModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDocumentTemplate", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDocumentTemplate", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = htmltemplates, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDocumentTemplate", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GenerateTemplateReport)]
        public JsonResult<BtrakJsonResult> GenerateReportForanEmployee(DocumentTemplateModel documentTemplateModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenerateReportForanEmployee", "HrManagement Api"));

                if (documentTemplateModel == null)
                {
                    documentTemplateModel = new DocumentTemplateModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                EmployeeReportDetailsModel htmltemplates = _hrManagementService.GenerateReportForanEmployee(documentTemplateModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GenerateReportForanEmployee", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GenerateReportForanEmployee", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = htmltemplates, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenerateReportForanEmployee", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateUnreadAnnouncements)]
        public JsonResult<BtrakSlackJsonResult> UpdateUnreadAnnouncements(AnnouncementReadInputModel announcementReadInputModel)
        {
            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateUnreadAnnouncements", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                bool result = _hrManagementService.UpdateUnreadAnnouncements(announcementReadInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateUnreadAnnouncements", "HrManagement Api"));
                    return Json(new BtrakSlackJsonResult { Success = true, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateUnreadAnnouncements", "HrManagement Api"));
                return Json(new BtrakSlackJsonResult { Success = true, Data = result }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateUnreadAnnouncements", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakSlackJsonResult { Success = false, Result = exception.Message }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUnreadAnnouncements)]
        public JsonResult<BtrakJsonResult> GetUnreadAnnouncements(AnnouncementModel announcementModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUnreadAnnouncements", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                List<AnnouncementModel> announcements = _hrManagementService.GetUnreadAnnouncements(announcementModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUnreadAnnouncements", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUnreadAnnouncements", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = announcements, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUnreadAnnouncements", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetReadAndUnReadUsersOfAnnouncement)]
        public JsonResult<BtrakJsonResult> GetReadAndUnReadUsersOfAnnouncement(Guid? AnnouncementId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetReadAndUnReadUsersOfAnnouncement", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                List<ReadAndUnReadUsersOfAnnouncementApiReturnModel> announcements = _hrManagementService.GetReadAndUnReadUsersOfAnnouncement(AnnouncementId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetReadAndUnReadUsersOfAnnouncement", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetReadAndUnReadUsersOfAnnouncement", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = announcements, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetReadAndUnReadUsersOfAnnouncement", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeesByRoleId)]
        public JsonResult<BtrakJsonResult> GetEmployeesByRoleId([FromBody]string roleIds)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeesByRoleId", "HrManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                List<EmployeeListApiOutputModel> announcements = _hrManagementService.GetEmployeesByRoleId(roleIds, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesByRoleId", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeesByRoleId", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = announcements, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeesByRoleId", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [AllowAnonymous]
        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetActiveUsersCount)]
        public JsonResult<BtrakJsonResult> GetActiveUsersCount()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActiveUsersCount", "HrManagementApiController"));

                BtrakJsonResult btrakJsonResult;
                var result = 0;
                var ah = Request.Headers.Authorization;
                if (ah != null && ah.Scheme.ToLower() == "bearer")
                {
                    var jwtToken = ah.Parameter;

                    var decodeJwt = jwtToken != "null" ? _userAuthTokenFactory.DecodeUserAuthToken(jwtToken) : null;
                    if (decodeJwt != null)
                    {
                        var loggedInUserId = decodeJwt.UserId;
                        result = _hrManagementService.GetActiveUsersCount(loggedInUserId, validationMessages);
                    }
                    else
                        result = _hrManagementService.GetActiveUsersCount(null, validationMessages);
                }
                else
                {
                    result = _hrManagementService.GetActiveUsersCount(null, validationMessages);
                }



                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActiveUsersCount", "HrManagementApiController"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActiveUsersCount", "HrManagementApiController"));
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActiveUsersCount", "HrManagementApiController", exception.Message), exception);
                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetIsHavingEmployeereportMembers)]
        public JsonResult<BtrakJsonResult> GetIsHavingEmployeereportMembers(EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetIsHavingEmployeereportMembers", "HrManagement Api"));
                
                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                bool output = _hrManagementService.GetIsHavingEmployeereportMembers(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIsHavingEmployeereportMembers", "HrManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIsHavingEmployeereportMembers", "HrManagement Api"));

                return Json(new BtrakJsonResult { Data = output, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIsHavingEmployeereportMembers", "HrManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
