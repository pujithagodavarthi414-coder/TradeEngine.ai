using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Chat;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Currency;
using Btrak.Models.CurrencyConversion;
using Btrak.Models.Employee;
using Btrak.Models.HrDashboard;
using Btrak.Models.HrManagement;
using Btrak.Models.MasterData;
using Btrak.Models.Notification;
using Btrak.Models.PayGradeRates;
using Btrak.Models.PaymentMethod;
using Btrak.Models.RateType;
using Btrak.Models.StatusReportingConfiguration;
using Btrak.Models.SystemManagement;
using Btrak.Models.User;
using Btrak.Services.Audit;
using Btrak.Services.Chat;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.Employee;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.HRManagementValidationHelpers;
using Btrak.Services.Notification;
using Btrak.Services.PubNub;
using BTrak.Common;
using BTrak.Common.Constants;
using BusinessView.Common;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using Hangfire;
using Microsoft.Office.Interop.Word;
using Newtonsoft.Json;
using Omu.ValueInjecter;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Cell = DocumentFormat.OpenXml.Spreadsheet.Cell;
using JsonDeserialiseData = BTrak.Common.JsonDeserialiseData;
using Row = DocumentFormat.OpenXml.Spreadsheet.Row;

namespace Btrak.Services.HrManagement
{
    public class HrManagementService : IHrManagementService
    {
        private readonly ShiftTimingRepository _shiftTimingRepository;
        private readonly EmployeeRepository _employeeRepository;
        private readonly EmployeeShiftRepository _employeeShiftRepository;
        private readonly CurrencyRepository _currencyRepository;
        private readonly CurrencyConversionRepository _currencyConversionRepository;
        private readonly ContractTypeRepository _contractTypeRepository;
        private readonly DepartmentRepository _departmentRepository;
        private readonly EmployeeLanguageRepository _employeeLanguageRepository;
        private readonly PaymentRepository _paymentRepository;
        private readonly DesignationRepository _designationRepository;
        private readonly PayGradeRepository _payGradeRepository;
        private readonly PayGradeRateRepository _payGradeRateRepository;
        private readonly BreakTypeRepository _breakTypeRepository;
        private readonly RateTypeRepository _rateTypeRepository;
        private readonly EmployeeEmergencyContactRepository _employeeEmergencyContactRepository;
        private readonly EmploymentContractRepository _employmentContractRepository;
        private readonly EmployeeJobRepository _employeeJobRepository;
        private readonly EmployeeImmigrationRepository _employeeImmigrationRepository;
        private readonly EmployeeSalaryRepository _employeeSalaryRepository;
        private readonly EmployeeReportToRepository _employeeReportToRepository;
        private readonly EmployeeWorkExperienceRepository _employeeWorkExperienceRepository;
        private readonly EmployeeEducationRepository _employeeEducationRepository;
        private readonly EmployeeSkillRepository _employeeSkillRepository;
        private readonly EmployeeMembershipRepository _employeeMembershipRepository;
        private readonly EmployeeLicenceRepository _employeeLicenceRepository;
        private readonly EmployeeContactDetailRepository _employeeContactDetailRepository;
        private readonly RelationshipRepository _relationshipRepository;
        private readonly BankDetailRepository _bankDetailRepository;
        private readonly IAuditService _auditService;
        private readonly StatusReportingRepository _statusReportingRepository;
        private readonly WebHookRepository _webhookRepository;
        private readonly HtmlTemplateRepository _htmlTemplateRepository;
        private readonly RatesheetRepository _ratesheetRepository;
        private readonly IPubNubService _pubNubService;
        private readonly INotificationService _notificationService;
        private readonly UserRepository _userRepository;
        private readonly GoalRepository _goalRepository;
        private readonly HrDashboardRepository _hrDashboardRepository;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly PayRollRepository _payRollRepository;
        private readonly IEmailService _emailService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly ClientRepository _clientRepository = new ClientRepository();


        public HrManagementService(ShiftTimingRepository shiftTimingRepository, EmployeeShiftRepository employeeShiftRepository, ContractTypeRepository contractTypeRepository,
            DepartmentRepository departmentRepository, EmployeeLanguageRepository employeeLanguageRepository, EmployeeImmigrationRepository employeeImmigrationRepository,
            EmploymentContractRepository employmentContractRepository, HtmlTemplateRepository htmlTemplateRepository, EmployeeRepository employeeRepository, IAuditService auditService, CurrencyRepository currencyRepository,
            CurrencyConversionRepository currencyConversionRepository, EmployeeSalaryRepository employeeSalaryRepository, EmployeeSkillRepository employeeSkillRepository,
            EmployeeEducationRepository employeeEducationRepository, EmployeeWorkExperienceRepository employeeWorkExperienceRepository,
            EmployeeReportToRepository employeeReportToRepository, PaymentRepository paymentRepository, EmployeeJobRepository employeeJobRepository,
            EmployeeEmergencyContactRepository employeeEmergencyContactRepository, PayGradeRateRepository payGradeRateRepository, DesignationRepository designationRepository,
            PayGradeRepository payGradeRepository, BreakTypeRepository breakTypeRepository, RateTypeRepository rateTypeRepository,
            EmployeeMembershipRepository employeeMembershipRepository, EmployeeLicenceRepository employeeLicenceRepository, INotificationService notificationService,
            EmployeeContactDetailRepository employeeContactDetailRepository, BankDetailRepository bankDetailRepository, RelationshipRepository relationshipRepository,
            StatusReportingRepository statusReportingRepository, RatesheetRepository ratesheetRepository, MasterDataManagementRepository masterDataManagementRepository,
            IEmployeeService employeeService, UserRepository userRepository, ChatService chatService, GoalRepository goalRepository, HrDashboardRepository hrDashboardRepository,
            IPubNubService pubNubService, WebHookRepository webhookRepository, PayRollRepository payRollRepository, IEmailService emailService, ICompanyStructureService companyStructureService)
        {
            _shiftTimingRepository = shiftTimingRepository;
            _employeeRepository = employeeRepository;
            _employeeShiftRepository = employeeShiftRepository;
            _contractTypeRepository = contractTypeRepository;
            _departmentRepository = departmentRepository;
            _employmentContractRepository = employmentContractRepository;
            _employeeEducationRepository = employeeEducationRepository;
            _employeeSkillRepository = employeeSkillRepository;
            _employeeLanguageRepository = employeeLanguageRepository;
            _paymentRepository = paymentRepository;
            _webhookRepository = webhookRepository;
            _htmlTemplateRepository = htmlTemplateRepository;
            _employeeImmigrationRepository = employeeImmigrationRepository;
            _employeeSalaryRepository = employeeSalaryRepository;
            _employeeReportToRepository = employeeReportToRepository;
            _employeeWorkExperienceRepository = employeeWorkExperienceRepository;
            _currencyRepository = currencyRepository;
            _employeeJobRepository = employeeJobRepository;
            _currencyConversionRepository = currencyConversionRepository;
            _designationRepository = designationRepository;
            _payGradeRepository = payGradeRepository;
            _breakTypeRepository = breakTypeRepository;
            _rateTypeRepository = rateTypeRepository;
            _payGradeRateRepository = payGradeRateRepository;
            _employeeEmergencyContactRepository = employeeEmergencyContactRepository;
            _employeeMembershipRepository = employeeMembershipRepository;
            _employeeLicenceRepository = employeeLicenceRepository;
            _employeeContactDetailRepository = employeeContactDetailRepository;
            _bankDetailRepository = bankDetailRepository;
            _auditService = auditService;
            _relationshipRepository = relationshipRepository;
            _statusReportingRepository = statusReportingRepository;
            _ratesheetRepository = ratesheetRepository;
            _pubNubService = pubNubService;
            _notificationService = notificationService;
            _userRepository = userRepository;
            _goalRepository = goalRepository;
            _hrDashboardRepository = hrDashboardRepository;
            _masterDataManagementRepository = masterDataManagementRepository;
            _payRollRepository = payRollRepository;
            _emailService = emailService;
            _companyStructureService = companyStructureService;
        }

        public Guid? UpsertShiftTiming(ShiftTimingInputModel shiftTimingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered Upsert Shift Timing with shift timing Id " + shiftTimingInputModel.ShiftTimingId + ", timing=" + shiftTimingInputModel.StartTime + ", shift=" + shiftTimingInputModel.Shift + ", deadline=" + shiftTimingInputModel.EndTime + ", Logged in User Id=" + loggedInContext.LoggedInUserId);

            shiftTimingInputModel.Shift = shiftTimingInputModel.Shift?.Trim();

            if (!HrManagementValidationsHelper.UpsertShiftTimingValidation(shiftTimingInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (shiftTimingInputModel.DaysOfWeek != null)
            {
                shiftTimingInputModel.DaysOfWeekXML = Utilities.ConvertIntoListXml(shiftTimingInputModel.DaysOfWeek);
            }

            if (shiftTimingInputModel.ShiftWeekItems != null)
            {
                shiftTimingInputModel.ShiftWeekJson = JsonConvert.SerializeObject(shiftTimingInputModel.ShiftWeekItems);
            }

            if (shiftTimingInputModel.ShiftExceptionItems != null)
            {
                shiftTimingInputModel.ShiftExceptionJson = JsonConvert.SerializeObject(shiftTimingInputModel.ShiftExceptionItems);
            }

            shiftTimingInputModel.ShiftTimingId = _shiftTimingRepository.UpsertShiftTiming(shiftTimingInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Shift timing with the id " + shiftTimingInputModel.ShiftTimingId + " has been created.");
            _auditService.SaveAudit(AppCommandConstants.UpsertShiftTimingCommandId, shiftTimingInputModel, loggedInContext);
            return shiftTimingInputModel.ShiftTimingId;
        }

        public Guid? UpsertShiftWeek(ShiftWeekUpsertInputModel shiftWeekUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered Upsert Shift week with shift timing Id " + shiftWeekUpsertInputModel.ShiftTimingId + ", deadline=" + shiftWeekUpsertInputModel.DeadLine + ", Logged in User Id=" + loggedInContext.LoggedInUserId);

            if (!HrManagementValidationsHelper.UpsertShiftWeekValidation(shiftWeekUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }


            shiftWeekUpsertInputModel.ShiftWeekId = _shiftTimingRepository.UpsertShiftWeek(shiftWeekUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Shift timing with the id " + shiftWeekUpsertInputModel.ShiftWeekId + " has been created.");
            _auditService.SaveAudit(AppCommandConstants.UpsertShiftTimingCommandId, shiftWeekUpsertInputModel, loggedInContext);
            return shiftWeekUpsertInputModel.ShiftWeekId;
        }

        public Guid? UpsertEmployeeShift(EmployeeShiftInputModel employeeShiftInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered Upsert Employee Shift with employee shift Id " + employeeShiftInputModel.EmployeeShiftId + ", employee id=" + employeeShiftInputModel.EmployeeId + ", shift timing id=" + employeeShiftInputModel.ShiftTimingId + ", active from =" + employeeShiftInputModel.ActiveFrom + ", Logged in User Id=" + loggedInContext.LoggedInUserId);

            if (!HrManagementValidationsHelper.UpsertEmployeeShiftValidation(employeeShiftInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            employeeShiftInputModel.EmployeeShiftId = _employeeShiftRepository.UpsertEmployeeShift(employeeShiftInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Employee shift with the id " + employeeShiftInputModel.EmployeeShiftId + " has been created.");
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeShiftCommandId, employeeShiftInputModel, loggedInContext);
            return employeeShiftInputModel.EmployeeShiftId;
        }

        public Guid? UpsertContractType(ContractTypeUpsertInputModel contractTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertContractType", "HrManagement Service"));

            contractTypeUpsertInputModel.ContractTypeName = contractTypeUpsertInputModel.ContractTypeName?.Trim();

            LoggingManager.Debug(contractTypeUpsertInputModel.ToString());

            if (!HrManagementValidationsHelper.ValidateUpsertContractType(contractTypeUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            contractTypeUpsertInputModel.ContractTypeId = _contractTypeRepository.UpsertContractType(contractTypeUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertContractTypeCommandId, contractTypeUpsertInputModel, loggedInContext);

            LoggingManager.Debug(contractTypeUpsertInputModel.ContractTypeId?.ToString());

            return contractTypeUpsertInputModel.ContractTypeId;
        }

        public List<ContractTypeApiReturnModel> GetContractTypes(ContractTypeSearchInputModel contractTypeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetContractTypes", "HrManagement Service"));

            LoggingManager.Debug(contractTypeSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetContractTypesCommandId, contractTypeSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ContractTypeApiReturnModel> contractTypeReturnModels = _contractTypeRepository.GetContractTypes(contractTypeSearchInputModel, loggedInContext, validationMessages).ToList();

            return contractTypeReturnModels;
        }

        public List<EmployeeShiftSearchOutputModel> GetEmployeeShift(EmployeeShiftSearchInputModel employeeShiftSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeShift", "HrManagement Service"));

            LoggingManager.Debug(employeeShiftSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetContractTypesCommandId, employeeShiftSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<EmployeeShiftSearchOutputModel> employeeShift = _employeeShiftRepository.GetEmployeeShift(employeeShiftSearchInputModel, loggedInContext, validationMessages);

            //if (employeeShift != null)
            //{
            //    ShiftWeekSearchInputModel shiftWeekSearchInputModel = new ShiftWeekSearchInputModel()
            //    {
            //        ShiftTimingId = employeeShift.ShiftTimingId
            //    };
            //    ShiftExceptionSearchInputModel shiftExceptionSearchInputModel = new ShiftExceptionSearchInputModel()
            //    {
            //        ShiftTimingId = employeeShift.ShiftTimingId
            //    };
            //    employeeShift.ShiftWeek = _shiftTimingRepository.GetShiftWeek(shiftWeekSearchInputModel, loggedInContext, validationMessages).ToList();
            //    employeeShift.ShiftException = _shiftTimingRepository.GetShiftException(shiftExceptionSearchInputModel, loggedInContext, validationMessages).ToList();
            //}

            return employeeShift;
        }

        public ContractTypeApiReturnModel GetContractTypeById(ContractTypeSearchInputModel contractTypeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetContractTypeById", "contractTypeId", contractTypeSearchInputModel.ContractTypeId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateContractTypeById(contractTypeSearchInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            ContractTypeApiReturnModel contractTypeReturnModel = _contractTypeRepository.GetContractTypes(contractTypeSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!HrManagementValidationsHelper.ValidateContractTypeFoundWithId(contractTypeSearchInputModel, validationMessages, contractTypeReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetContractTypeByIdCommandId, contractTypeSearchInputModel, loggedInContext);


            LoggingManager.Debug(contractTypeReturnModel?.ToString());

            return contractTypeReturnModel;
        }

        public Guid? UpsertDepartment(DepartmentUpsertInputModel departmentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDepartment", "HrManagement Service"));

            departmentUpsertInputModel.DepartmentName = departmentUpsertInputModel.DepartmentName?.Trim();

            LoggingManager.Debug(departmentUpsertInputModel.ToString());

            if (!HrManagementValidationsHelper.ValidateUpsertDepartment(departmentUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            departmentUpsertInputModel.DepartmentId = _departmentRepository.UpsertDepartment(departmentUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertDepartmentCommandId, departmentUpsertInputModel, loggedInContext);

            LoggingManager.Debug(departmentUpsertInputModel.DepartmentId?.ToString());

            return departmentUpsertInputModel.DepartmentId;
        }

        public List<DepartmentApiReturnModel> GetDepartments(DepartmentSearchInputModel departmentSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDepartments", "HrManagement Service"));

            LoggingManager.Debug(departmentSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetDepartmentsCommandId, departmentSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<DepartmentApiReturnModel> departmentReturnModels = _departmentRepository.GetDepartments(departmentSearchInputModel, loggedInContext, validationMessages).ToList();

            return departmentReturnModels;
        }

        public DepartmentApiReturnModel GetDepartmentById(DepartmentSearchInputModel departmentSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetDepartmentById", "departmentId", departmentSearchInputModel.DepartmentId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateDepartmentById(departmentSearchInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            DepartmentApiReturnModel departmentReturnModel = _departmentRepository.GetDepartments(departmentSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!HrManagementValidationsHelper.ValidateDepartmentFoundWithId(departmentSearchInputModel, validationMessages, departmentReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetDepartmentByIdCommandId, departmentSearchInputModel, loggedInContext);

            LoggingManager.Debug(departmentReturnModel?.ToString());

            return departmentReturnModel;
        }

        public Guid? UpsertCurrency(CurrencyInputModel currencyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCurrency", "currencyInputModel", currencyInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertCurrencyValidation(currencyInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            currencyInputModel.CurrencyId = _currencyRepository.UpsertCurrency(currencyInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Currency with the id " + currencyInputModel.CurrencyId);
            _auditService.SaveAudit(AppCommandConstants.UpsertCurrencyCommandId, currencyInputModel, loggedInContext);
            return currencyInputModel.CurrencyId;
        }

        public List<CurrencyOutputModel> SearchCurrency(CurrencySearchCriteriaInputModel currencySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCurrency", "currencySearchCriteriaInputModel", currencySearchCriteriaInputModel, "Hr Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetCurrenciesCommandId, currencySearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                currencySearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Currency list ");
            List<CurrencyOutputModel> currencyList = _currencyRepository.SearchCurrency(currencySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return currencyList;
        }

        public Guid? UpsertCurrencyConversion(CurrencyConversionInputModel currencyConversionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Currency Conversion", "currencyConversionInputModel", currencyConversionInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertCurrencyConversionValidation(currencyConversionInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            currencyConversionInputModel.CurrencyConversionId = _currencyConversionRepository.UpsertCurrencyConversion(currencyConversionInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Currency Conversion with the id " + currencyConversionInputModel.CurrencyConversionId);
            _auditService.SaveAudit(AppCommandConstants.UpsertCurrencyConversionCommandId, currencyConversionInputModel, loggedInContext);
            return currencyConversionInputModel.CurrencyConversionId;
        }

        public List<CurrencyConversionOutputModel> GetCurrencyConversions(CurrencyConversionSearchCriteriaInputModel currencyConversionSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Currency Conversions", "currencyConversionSearchCriteriaInputModel", currencyConversionSearchCriteriaInputModel, "Hr Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetCurrencyConversionsCommandId, currencyConversionSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                currencyConversionSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting currency conversion list ");
            List<CurrencyConversionOutputModel> currencyConversionList = _currencyConversionRepository.GetCurrencyConversion(currencyConversionSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return currencyConversionList;
        }

        public Guid? UpsertPaymentMethod(PaymentMethodInputModel paymentMethodInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Payment Method", "paymentMethodInputModel", paymentMethodInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertPaymentMethod(paymentMethodInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            paymentMethodInputModel.PaymentMethodId = _paymentRepository.UpsertPaymentMethod(paymentMethodInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Payment with the id " + paymentMethodInputModel.PaymentMethodId);
            _auditService.SaveAudit(AppCommandConstants.UpsertPaymentMethodCommandId, paymentMethodInputModel, loggedInContext);
            return paymentMethodInputModel.PaymentMethodId;
        }

        public List<PaymentMethodOutputModel> GetPaymentMethod(PaymentMethodSearchCriteriaInputModel paymentMethodSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Payment Method", "paymentMethodSearchCriteriaInputModel", paymentMethodSearchCriteriaInputModel, "Hr Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetPaymentMethodCommandId, paymentMethodSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                paymentMethodSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting payment method list ");
            List<PaymentMethodOutputModel> paymentMethodList = _paymentRepository.GetPaymentMethod(paymentMethodSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return paymentMethodList;
        }

        public Guid? UpsertDesignation(DesignationUpsertInputModel designationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDesignation", "HrManagement Service"));

            designationUpsertInputModel.DesignationName = designationUpsertInputModel.DesignationName?.Trim();

            LoggingManager.Debug(designationUpsertInputModel.ToString());

            if (!HrManagementValidationsHelper.ValidateUpsertDesignation(designationUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            designationUpsertInputModel.DesignationId = _designationRepository.UpsertDesignation(designationUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertDesignationCommandId, designationUpsertInputModel, loggedInContext);

            LoggingManager.Debug(designationUpsertInputModel.DesignationId?.ToString());

            return designationUpsertInputModel.DesignationId;
        }

        public List<DesignationApiReturnModel> GetDesignations(DesignationSearchInputModel designationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDesignations", "HrManagement Service"));

            LoggingManager.Debug(designationSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetDesignationsCommandId, designationSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<DesignationApiReturnModel> designationSpReturnModels = _designationRepository.GetDesignations(designationSearchInputModel, loggedInContext, validationMessages).ToList();

            return designationSpReturnModels;
        }

        public Guid? UpsertPayGrade(PayGradeUpsertInputModel payGradeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayGrade", "HrManagement Service"));

            payGradeUpsertInputModel.PayGradeName = payGradeUpsertInputModel.PayGradeName?.Trim();

            LoggingManager.Debug(payGradeUpsertInputModel.ToString());

            if (!HrManagementValidationsHelper.ValidateUpsertPayGrade(payGradeUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            payGradeUpsertInputModel.PayGradeId = _payGradeRepository.UpsertPayGrade(payGradeUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertPayGradeCommandId, payGradeUpsertInputModel, loggedInContext);

            LoggingManager.Debug(payGradeUpsertInputModel.PayGradeId?.ToString());

            return payGradeUpsertInputModel.PayGradeId;
        }

        public List<PayGradeApiReturnModel> GetPayGrades(PayGradeSearchInputModel payGradeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayGrades", "HrManagement Service"));

            LoggingManager.Debug(payGradeSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetPayGradesCommandId, payGradeSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<PayGradeApiReturnModel> payGradeReturnModels = _payGradeRepository.GetPayGrades(payGradeSearchInputModel, loggedInContext, validationMessages).ToList();

            return payGradeReturnModels;
        }

        public Guid? UpsertBreakType(BreakTypeUpsertInputModel breakTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertBreakType", "HrManagement Service"));

            breakTypeUpsertInputModel.BreakTypeName = breakTypeUpsertInputModel.BreakTypeName?.Trim();

            LoggingManager.Debug(breakTypeUpsertInputModel.ToString());

            if (!HrManagementValidationsHelper.ValidateUpsertBreakType(breakTypeUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            breakTypeUpsertInputModel.BreakId = _breakTypeRepository.UpsertBreakType(breakTypeUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertBreakTypeCommandId, breakTypeUpsertInputModel, loggedInContext);

            LoggingManager.Debug(breakTypeUpsertInputModel.BreakId?.ToString());

            return breakTypeUpsertInputModel.BreakId;
        }

        public List<BreakTypeApiReturnModel> GetBreakTypes(BreakTypeSearchInputModel breakTypeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBreakTypes", "HrManagement Service"));

            LoggingManager.Debug(breakTypeSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetBreakTypesCommandId, breakTypeSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<BreakTypeSpReturnModel> breakTypeSpReturnModels = _breakTypeRepository.GetBreakTypes(breakTypeSearchInputModel, loggedInContext, validationMessages).ToList();

            List<BreakTypeApiReturnModel> breakTypeApiReturnModels = new List<BreakTypeApiReturnModel>();

            if (breakTypeSpReturnModels.Count > 0)
            {
                breakTypeApiReturnModels = breakTypeSpReturnModels.Select(ConvertToBreakTypeApiReturnModel).ToList();
            }

            return breakTypeApiReturnModels;
        }

        public Guid? UpsertRateType(RateTypeInputModel rateTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertRateType", "rateTypeInputModel", rateTypeInputModel, "Hr Management Service"));
            if (!HrManagementValidationsHelper.UpsertRateTypeValidation(rateTypeInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            rateTypeInputModel.RateTypeId = _rateTypeRepository.UpsertRateType(rateTypeInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Rate Type with the id " + rateTypeInputModel.RateTypeId);
            _auditService.SaveAudit(AppCommandConstants.UpsertRateTypeCommandId, rateTypeInputModel, loggedInContext);
            return rateTypeInputModel.RateTypeId;
        }

        public List<RateTypeOutputModel> SearchRateType(RateTypeSearchCriteriaInputModel rateTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchRateType", "rateTypeSearchCriteriaInputModel", rateTypeSearchCriteriaInputModel, "Hr Management Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchRateTypeCommandId, rateTypeSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                rateTypeSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Rate Type list ");
            List<RateTypeOutputModel> rateTypeList = _rateTypeRepository.SearchRateType(rateTypeSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return rateTypeList;
        }

        public Guid? UpsertEmployeeLicenceDetails(EmployeeLicenceDetailsInputModel employeeLicenceDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeLicenceDetails", "employeeLicenceDetailsInputModel", employeeLicenceDetailsInputModel, "Hr Management Service"));
            if (!HrManagementValidationsHelper.UpsertEmployeeLicenceDetailsValidation(employeeLicenceDetailsInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            employeeLicenceDetailsInputModel.EmployeeLicenceDetailId = _employeeRepository.UpsertEmployeeLicenceDetails(employeeLicenceDetailsInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Licence Details with the id " + employeeLicenceDetailsInputModel.EmployeeLicenceDetailId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeLicenceDetailsCommandId, employeeLicenceDetailsInputModel, loggedInContext);
            return employeeLicenceDetailsInputModel.EmployeeLicenceDetailId;
        }

        public Guid? UpsertEmployeePersonalDetails(EmployeePersonalDetailsInputModel employeePersonalDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeePersonalDetails", "employeePersonalDetailsInputModel", employeePersonalDetailsInputModel, "Hr Management Service"));
            if (!HrManagementValidationsHelper.UpsertEmployeePersonalDetailsValidation(employeePersonalDetailsInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }
            string OriginalPassword = employeePersonalDetailsInputModel.Password;
            bool isNewEmployee = employeePersonalDetailsInputModel.EmployeeId == null ? true : false;

            if (employeePersonalDetailsInputModel.EmployeeId == null)
            {
                //employeePersonalDetailsInputModel.Password = employeePersonalDetailsInputModel.FirstName + "." + employeePersonalDetailsInputModel.SurName + "!";

                employeePersonalDetailsInputModel.Password = "Test123!";

                OriginalPassword = employeePersonalDetailsInputModel.Password;

                employeePersonalDetailsInputModel.Password = Utilities.GetSaltedPassword(employeePersonalDetailsInputModel.Password);

                employeePersonalDetailsInputModel.RegisteredDateTime = DateTime.Now;
            }

            if (employeePersonalDetailsInputModel.PermittedBranches?.Count > 0 && employeePersonalDetailsInputModel.PermittedBranches != null)
            {
                employeePersonalDetailsInputModel.PermittedBranchIds = Utilities.ConvertIntoListXml(employeePersonalDetailsInputModel.PermittedBranches);
            }

            if (employeePersonalDetailsInputModel.BusinessUnitIds?.Count > 0 && employeePersonalDetailsInputModel.BusinessUnitIds != null)
            {
                employeePersonalDetailsInputModel.BusinessUnitXML = Utilities.ConvertIntoListXml(employeePersonalDetailsInputModel.BusinessUnitIds);
            }

            UserInputModel userModel = new UserInputModel();

            Guid? UserAuthenticationId = null;

            if(employeePersonalDetailsInputModel.UserId != null)
            {
                UserAuthenticationId = _clientRepository.GetUserAuthenticationIdByUserId((Guid)employeePersonalDetailsInputModel.UserId, loggedInContext, validationMessages);
            }
            
            userModel = new UserInputModel {
                UserId = UserAuthenticationId,
                UserAuthenticationId = UserAuthenticationId,
                Email = employeePersonalDetailsInputModel.Email,
                Password = OriginalPassword,
                IsArchived = (bool)(employeePersonalDetailsInputModel?.IsArchived == null? false: employeePersonalDetailsInputModel?.IsArchived),
                IsActive = (bool)(employeePersonalDetailsInputModel?.IsActive == null ? true : employeePersonalDetailsInputModel?.IsActive),
                FirstName = employeePersonalDetailsInputModel.FirstName,
                SurName = employeePersonalDetailsInputModel.SurName,
                TimeZoneId = employeePersonalDetailsInputModel.TimeZoneId,
                LastName = employeePersonalDetailsInputModel.SurName,
                RoleId = employeePersonalDetailsInputModel.RoleIds,
                MobileNo = employeePersonalDetailsInputModel.MobileNo
            };

            var result = ApiWrapper.PutentityToApi(RouteConstants.ASUpsertUser, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], userModel, loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            var id = JsonConvert.SerializeObject(responseJson.Data);
            var responseid = (id != null && id != "null") ? id : null;
            //if (responseJson.Success && responseid != null)
            //{
                var idGuid = Convert.ToString(responseJson.Data);
            if(idGuid != null && idGuid != Guid.Empty.ToString() && idGuid?.Trim() != string.Empty)
            {
                employeePersonalDetailsInputModel.UserAuthenticationId = new Guid(idGuid);
            }
            else if(UserAuthenticationId != null)
            {
                employeePersonalDetailsInputModel.UserAuthenticationId = UserAuthenticationId;
            }
                

            if (employeePersonalDetailsInputModel.UserAuthenticationId != null)
            {
                employeePersonalDetailsInputModel.EmployeeId = _employeeRepository.UpsertEmployeePersonalDetails(employeePersonalDetailsInputModel, loggedInContext, validationMessages);

                if (isNewEmployee)
                {
                    UserRegistrationDetailsModel userRegistrationDetails = new UserRegistrationDetailsModel()
                    {
                        UserName = employeePersonalDetailsInputModel.Email,
                        FirstName = employeePersonalDetailsInputModel.FirstName,
                        SurName = employeePersonalDetailsInputModel.SurName,
                        RoleIds = employeePersonalDetailsInputModel.RoleIds,
                        Password = "Test123!"
                    };

                    BackgroundJob.Enqueue(() => SendUserRegistrationMail(userRegistrationDetails, loggedInContext, validationMessages));
                }

                LoggingManager.Debug("Employee Personal Details with the id " + employeePersonalDetailsInputModel.EmployeeId);
                if (employeePersonalDetailsInputModel.EmployeeId != null && (employeePersonalDetailsInputModel.IsUpload == false || employeePersonalDetailsInputModel.IsUpload == null))
                {
                    loggedInContext.LoggedInUserId = employeePersonalDetailsInputModel.EmployeeId ?? (Guid)employeePersonalDetailsInputModel.EmployeeId;

                    var pubnubChannels = new List<string>();
                    pubnubChannels.Add($"UserUpdates-{loggedInContext.CompanyGuid.ToString()}");
                    _pubNubService.PublishUserUpdatesToChannel(JsonConvert.SerializeObject(new MessageDto
                    {
                        RefreshUsers = true,
                        SenderUserId = employeePersonalDetailsInputModel.UserId ?? Guid.Empty,
                        FromUserId = employeePersonalDetailsInputModel.UserId ?? Guid.Empty
                    }), pubnubChannels, loggedInContext);
                }

                _auditService.SaveAudit(AppCommandConstants.UpsertEmployeePersonalDetailsCommandId, employeePersonalDetailsInputModel, loggedInContext);
            }

            return employeePersonalDetailsInputModel.EmployeeId;
        }

        public bool SendUserRegistrationMail(UserRegistrationDetailsModel userRegistrationDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

            CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];

            HtmlTemplateSearchInputModel htmlTemplateSearchInputModel = new HtmlTemplateSearchInputModel()
            {
                IsArchived = false
            };

            var templates = GetHtmlTemplates(htmlTemplateSearchInputModel, loggedInContext, validationMessages);

            var roles = userRegistrationDetails.RoleIds != null ? userRegistrationDetails.RoleIds.Split(',').ToList() : new List<string>();

            var mailFound = templates.FirstOrDefault(p => p.HtmlTemplateName == "UserRegistrationNotificationTemplate").Mails != null ? templates.FirstOrDefault(p => p.HtmlTemplateName == "UserRegistrationNotificationTemplate").Mails.ToLower().Contains(userRegistrationDetails.UserName.ToLower()) : false;

            var rolesAvailable = templates.FirstOrDefault(p => p.HtmlTemplateName == "UserRegistrationNotificationTemplate") != null ? templates.FirstOrDefault(p => p.HtmlTemplateName == "UserRegistrationNotificationTemplate").Roles.Split(',').ToList() : new List<string>();

            if (mailFound || rolesAvailable.Where(b => roles.Any(a => b.ToLower().Contains(a.ToLower()))).ToList().Count > 0)
            {
                CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
                {
                    Key = "CompanySigninLogo",
                    IsArchived = false
                };

                string mainLogo = (_masterDataManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);

                var siteAddress = siteDomain + "/sessions/signin";

                var html = _goalRepository.GetHtmlTemplateByName("UserRegistrationNotificationTemplate", loggedInContext.CompanyGuid);
                //var siteAddress = ConfigurationManager.AppSettings["SiteUrl"] + "/sessions/signin";
                html = html.Replace("##UserName##", userRegistrationDetails.UserName).
                        Replace("##CompanyName##", smtpDetails.CompanyName).
                        Replace("##siteUrl##", siteAddress).
                        Replace("##Name##", userRegistrationDetails.FirstName + " " + userRegistrationDetails.SurName).
                        Replace("##Password##", userRegistrationDetails.Password).
                        Replace("##CompanyRegistrationLogo##", mainLogo);

                var toMails = new string[1];
                toMails[0] = userRegistrationDetails.UserName;
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = toMails,
                    HtmlContent = html,
                    Subject = "Snovasys Business Suite: User registration notification",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
                return true;
            }
            return true;
        }

        public Guid? UpsertEmployeeContactDetails(EmployeeContactDetailsInputModel employeeContactDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeContactDetails", "employeeContactDetailsInputModel", employeeContactDetailsInputModel, "Hr Management Service"));
            if (!HrManagementValidationsHelper.UpsertEmployeeContactDetailsValidation(employeeContactDetailsInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            employeeContactDetailsInputModel.EmployeeContactDetailId = _employeeRepository.UpsertEmployeeContactDetails(employeeContactDetailsInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee Contact Details with the id " + employeeContactDetailsInputModel.EmployeeContactDetailId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeContactDetailsCommandId, employeeContactDetailsInputModel, loggedInContext);
            return employeeContactDetailsInputModel.EmployeeContactDetailId;
        }

        public Guid? AssignPayGradeRates(PayGradeRatesInputModel payGradeRatesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "AssignPayGradeRates", "payGradeRatesInputModel", payGradeRatesInputModel, "Hr Management Service"));

            if (!HrManagementValidationsHelper.AssignPayGradeRatesValidation(payGradeRatesInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            string xmlOfPayGradeRate = Utilities.ConvertIntoListXml(payGradeRatesInputModel.PayGradeRateModel);

            payGradeRatesInputModel.PayGradeId = _payGradeRateRepository.AssignPayGradeRates(payGradeRatesInputModel, xmlOfPayGradeRate, loggedInContext, validationMessages);
            LoggingManager.Debug("Pay Grade Rates with the id " + payGradeRatesInputModel.PayGradeId);
            _auditService.SaveAudit(AppCommandConstants.AssignPayGradeRatesCommandId, payGradeRatesInputModel, loggedInContext);
            return payGradeRatesInputModel.PayGradeId;
        }

        public List<PayGradeRatesOutputModel> GetPayGradeRates(PayGradeRatesSearchCriteriaInputModel payGradeRatesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPayGradeRates", "payGradeRatesSearchCriteriaInputModel", payGradeRatesSearchCriteriaInputModel, "Hr Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetPayGradeRatesCommandId, payGradeRatesSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                payGradeRatesSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting PayGrade Rate list ");
            List<PayGradeRatesOutputModel> payGradeList = _payGradeRateRepository.GetPayGradeRates(payGradeRatesSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return payGradeList;
        }

        public Guid? UpsertEmployeeEmergencyContactDetails(EmployeeEmergencyContactDetailsInputModel employeeEmergencyContactDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeEmergencyContactDetails", "employeeEmergencyContactDetailsInputModel", employeeEmergencyContactDetailsInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertEmployeeEmergencyContactDetailsValidation(employeeEmergencyContactDetailsInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            employeeEmergencyContactDetailsInputModel.EmergencyContactId = _employeeEmergencyContactRepository.UpsertEmployeeEmergencyContact(employeeEmergencyContactDetailsInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee Emergency Contact with the id " + employeeEmergencyContactDetailsInputModel.EmergencyContactId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeEmergencyContactDetailsCommandId, employeeEmergencyContactDetailsInputModel, loggedInContext);
            return employeeEmergencyContactDetailsInputModel.EmergencyContactId;
        }

        public Guid? UpsertEmploymentContract(EmploymentContractInputModel employmentContractInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmploymentContract", "employmentContractInputModel", employmentContractInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertEmploymentContractValidation(employmentContractInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            employmentContractInputModel.EmploymentContractId = _employmentContractRepository.UpsertEmploymentContract(employmentContractInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employment Contract with the id " + employmentContractInputModel.EmploymentContractId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmploymentContractCommandId, employmentContractInputModel, loggedInContext);
            return employmentContractInputModel.EmploymentContractId;
        }

        public Guid? UpsertEmployeeJob(EmployeeJobInputModel employeeJobInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeJob", "employeeJobInputModel", employeeJobInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertEmployeeJobValidation(employeeJobInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            employeeJobInputModel.EmployeeJobDetailId = _employeeJobRepository.UpsertEmployeeJob(employeeJobInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee Job with the id " + employeeJobInputModel.EmployeeJobDetailId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeJobCommandId, employeeJobInputModel, loggedInContext);
            return employeeJobInputModel.EmployeeJobDetailId;
        }

        public Guid? UpsertEmployeeImmigrationDetails(Models.Employee.EmployeeImmigrationDetailsInputModel employeeImmigrationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeImmigrationDetails", "employeeImmigrationDetailsInputModel", employeeImmigrationDetailsInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertEmployeeImmigrationDetailsValidation(employeeImmigrationDetailsInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            employeeImmigrationDetailsInputModel.EmployeeImmigrationId = _employeeImmigrationRepository.UpsertEmployeeImmigrationDetails(employeeImmigrationDetailsInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee Immigration Details with the id " + employeeImmigrationDetailsInputModel.EmployeeImmigrationId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeImmigrationDetailsCommandId, employeeImmigrationDetailsInputModel, loggedInContext);
            return employeeImmigrationDetailsInputModel.EmployeeImmigrationId;
        }

        public Guid? UpsertEmployeeSalaryDetails(Models.Employee.EmployeeSalaryDetailsInputModel employeeSalaryDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeSalaryDetails", "employeeSalaryDetailsInputModel", employeeSalaryDetailsInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertEmployeeSalaryDetailsValidation(employeeSalaryDetailsInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            employeeSalaryDetailsInputModel.EmployeeSalaryDetailId = _employeeSalaryRepository.UpsertEmployeeSalaryDetails(employeeSalaryDetailsInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee Salary Details with the id " + employeeSalaryDetailsInputModel.EmployeeSalaryDetailId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeSalaryDetailsCommandId, employeeSalaryDetailsInputModel, loggedInContext);
            return employeeSalaryDetailsInputModel.EmployeeSalaryDetailId;
        }

        public Guid? UpsertEmployeeReportTo(EmployeeReportToInputModel employeeReportToInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Report To", "employeeReportToInputModel", employeeReportToInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertEmployeeReportToValidation(employeeReportToInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            employeeReportToInputModel.EmployeeReportToId = _employeeReportToRepository.UpsertEmployeeReportTo(employeeReportToInputModel, loggedInContext, validationMessages);

            if (employeeReportToInputModel.ReportToEmployeeId != null)
            {
                if (employeeReportToInputModel.IsArchived != true)
                {
                    BackgroundJob.Enqueue(() => SendUserReportToMail(employeeReportToInputModel, loggedInContext, validationMessages));
                }
            }

            LoggingManager.Debug("Employee Report To with the id " + employeeReportToInputModel.EmployeeReportToId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeReportToCommandId, employeeReportToInputModel, loggedInContext);
            return employeeReportToInputModel.EmployeeReportToId;
        }

        public bool SendUserReportToMail(EmployeeReportToInputModel employeeReportToInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            EmployeeSearchCriteriaInputModel employeeSearchCriteriaInputModel = new EmployeeSearchCriteriaInputModel
            {
                EmployeeId = employeeReportToInputModel.ReportToEmployeeId
            };
            EmployeeOutputModel reportToEmployeeDetails = _employeeRepository.GetAllEmployees(employeeSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            employeeSearchCriteriaInputModel = new EmployeeSearchCriteriaInputModel
            {
                EmployeeId = employeeReportToInputModel.EmployeeId
            };
            EmployeeOutputModel employeeDetails = _employeeRepository.GetAllEmployees(employeeSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

            var reportFrom = employeeReportToInputModel.ReportingFrom == null ? "today" : string.Format("{0:dd MMM, yyyy}", employeeReportToInputModel.ReportingFrom);

            var html = _goalRepository.GetHtmlTemplateByName("UserReportToNotificationTemplate", loggedInContext.CompanyGuid);
            var siteAddress = ConfigurationManager.AppSettings["SiteUrl"] + "/sessions/signin";
            html = html.Replace("##ReportToName##", reportToEmployeeDetails.UserName).
                    Replace("##CompanyName##", smtpDetails.CompanyName).
                    Replace("##EmployeeName##", employeeDetails.UserName).
                    Replace("##ReportingDate##", reportFrom);

            var toMails = new string[1];
            toMails[0] = reportToEmployeeDetails.Email;
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpServer = smtpDetails?.SmtpServer,
                SmtpServerPort = smtpDetails?.SmtpServerPort,
                SmtpMail = smtpDetails?.SmtpMail,
                SmtpPassword = smtpDetails?.SmtpPassword,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Snovasys Business Suite: User assigned notification",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
            return true;
        }

        public Guid? UpsertEmployeeWorkExperience(EmployeeWorkExperienceInputModel employeeWorkExperienceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeWorkExperience", "employeeWorkExperienceInputModel", employeeWorkExperienceInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertEmployeeWorkExperienceValidation(employeeWorkExperienceInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            employeeWorkExperienceInputModel.EmployeeWorkExperienceId = _employeeWorkExperienceRepository.UpsertEmployeeWorkExperience(employeeWorkExperienceInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee Work Experience with the id " + employeeWorkExperienceInputModel.EmployeeWorkExperienceId);

            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeWorkExperienceCommandId, employeeWorkExperienceInputModel, loggedInContext);
            return employeeWorkExperienceInputModel.EmployeeWorkExperienceId;
        }

        public Guid? UpsertEmployeeEducationDetails(Models.Employee.EmployeeEducationDetailsInputModel employeeEducationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeEducationDetails", "employeeEducationDetailsInputModel", employeeEducationDetailsInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertEmployeeEducationDetails(employeeEducationDetailsInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            employeeEducationDetailsInputModel.EmployeeEducationDetailId = _employeeEducationRepository.UpsertEmployeeEducationDetails(employeeEducationDetailsInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee Education Details with the id " + employeeEducationDetailsInputModel.EmployeeEducationDetailId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeEducationDetailsCommandId, employeeEducationDetailsInputModel, loggedInContext);
            return employeeEducationDetailsInputModel.EmployeeEducationDetailId;
        }

        public Guid? UpsertEmployeeSkills(EmployeeSkillsInputModel employeeSkillsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeSkills", "employeeSkillsInputModel", employeeSkillsInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertEmployeeSkillsValidation(employeeSkillsInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            employeeSkillsInputModel.EmployeeSkillId = _employeeSkillRepository.UpsertEmployeeSkills(employeeSkillsInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee skill with the id " + employeeSkillsInputModel.EmployeeSkillId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeSkillsCommandId, employeeSkillsInputModel, loggedInContext);
            return employeeSkillsInputModel.EmployeeSkillId;
        }

        public Guid? UpsertEmployeeLanguages(EmployeeLanguagesInputModel employeeLanguagesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Employee Languages", "employeeLanguagesInputModel", employeeLanguagesInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpsertEmployeeLanguagesValidation(employeeLanguagesInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            employeeLanguagesInputModel.EmployeeLanguageId = _employeeLanguageRepository.UpsertEmployeeLanguages(employeeLanguagesInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee Language with the id " + employeeLanguagesInputModel.EmployeeLanguageId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeLanguagesCommandId, employeeLanguagesInputModel, loggedInContext);
            return employeeLanguagesInputModel.EmployeeLanguageId;
        }

        public Guid? UpsertEmployeeMemberships(EmployeeMembershipUpsertInputModel employeeMembershipUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeMemberships", "HrManagement Service"));

            LoggingManager.Debug(employeeMembershipUpsertInputModel.ToString());

            if (!HrManagementValidationsHelper.ValidateUpsertEmployeeMemberships(employeeMembershipUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            employeeMembershipUpsertInputModel.EmployeeId = _employeeMembershipRepository.UpsertEmployeeMemberships(employeeMembershipUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeMembershipsCommandId, employeeMembershipUpsertInputModel, loggedInContext);

            LoggingManager.Debug(employeeMembershipUpsertInputModel.EmployeeId?.ToString());

            return employeeMembershipUpsertInputModel.EmployeeId;
        }

        public Guid? UpsertRelationShip(RelationshipUpsertModel relationshipUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Relationships", "HrManagement Service"));

            LoggingManager.Debug(relationshipUpsertModel.ToString());

            if (!HrManagementValidationsHelper.ValidateUpsertRelationShip(relationshipUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            relationshipUpsertModel.RelationshipId = _relationshipRepository.UpsertRelstionship(relationshipUpsertModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertRelationshipCommandId, relationshipUpsertModel, loggedInContext);

            LoggingManager.Debug(relationshipUpsertModel.RelationshipId?.ToString());

            return relationshipUpsertModel.RelationshipId;
        }

        public List<RelationShipTypeSearchCriteriaInputModel> SearchRelationShip(RelationShipTypeSearchCriteriaInputModel relationShipTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search relationship", "relationShipTypeSearchCriteriaInputModel", relationShipTypeSearchCriteriaInputModel, "Hr Management Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchRelationshipCommandId, relationShipTypeSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                relationShipTypeSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting relationships list ");
            List<RelationShipTypeSearchCriteriaInputModel> relationshipsList = _relationshipRepository.SearchRealtionShip(relationShipTypeSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return relationshipsList;
        }

        public Guid? UpsertEmployeeBankDetails(EmployeeBankDetailUpsertInputModel employeeBankDetailUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeBankDetail", "HrManagement Service"));

            employeeBankDetailUpsertInputModel.IFSCCode = employeeBankDetailUpsertInputModel.IFSCCode?.Trim();
            employeeBankDetailUpsertInputModel.AccountNumber = employeeBankDetailUpsertInputModel.AccountNumber?.Trim();
            employeeBankDetailUpsertInputModel.AccountName = employeeBankDetailUpsertInputModel.AccountName?.Trim();
            employeeBankDetailUpsertInputModel.BuildingSocietyRollNumber = employeeBankDetailUpsertInputModel.BuildingSocietyRollNumber?.Trim();
            employeeBankDetailUpsertInputModel.BankName = employeeBankDetailUpsertInputModel.BankName?.Trim();
            employeeBankDetailUpsertInputModel.BranchName = employeeBankDetailUpsertInputModel.BranchName?.Trim();

            LoggingManager.Debug(employeeBankDetailUpsertInputModel.ToString());

            if (!HrManagementValidationsHelper.ValidateUpsertEmployeeBankDetail(employeeBankDetailUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            employeeBankDetailUpsertInputModel.EmployeeId = _bankDetailRepository.UpsertEmployeeBankDetails(employeeBankDetailUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeBankDetailsCommandId, employeeBankDetailUpsertInputModel, loggedInContext);

            LoggingManager.Debug(employeeBankDetailUpsertInputModel.EmployeeId?.ToString());

            return employeeBankDetailUpsertInputModel.EmployeeId;
        }

        public List<EmployeeBankDetailApiReturnModel> GetAllBankDetails(EmployeeBankDetailSearchInputModel employeeBankDetailSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeBankDetails", "HrManagement Service"));

            LoggingManager.Debug(employeeBankDetailSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAllBankDetailsCommandId, employeeBankDetailSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<EmployeeBankDetailApiReturnModel> employeeBankDetails = _bankDetailRepository.GetAllBankDetails(employeeBankDetailSearchInputModel, loggedInContext, validationMessages).ToList();
            return employeeBankDetails;
        }

        public EmployeeDetailsApiReturnModel GetEmployeeDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeDetails", "HrManagement Service"));

            LoggingManager.Debug(employeeDetailSearchCriteriaInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetEmployeeDetailsCommandId, employeeDetailSearchCriteriaInputModel, loggedInContext);

            EmployeeDetailsApiReturnModel employeeDetailsApiReturnModel = new EmployeeDetailsApiReturnModel();
            //employeeDetailSearchCriteriaInputModel.PageSize = 1000;

            string employeeDetailType = employeeDetailSearchCriteriaInputModel.EmployeeDetailType;

            switch (employeeDetailType)
            {
                case "EducationDetails":
                    employeeDetailsApiReturnModel.employeeEducationDetails = _employeeEducationRepository.GetEmployeeEducationDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "ContactDetails":
                    employeeDetailsApiReturnModel.employeeContactDetails = _employeeContactDetailRepository.GetEmployeeContactDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "EmergencyContactDetails":
                    employeeDetailsApiReturnModel.employeeEmergencyContactDetails = _employeeEmergencyContactRepository.GetEmployeeEmergencyContactDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "ImmigrationDetails":
                    employeeDetailsApiReturnModel.employeeImmigrationDetails = _employeeImmigrationRepository.GetEmployeeImmigrationDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "JobDetails":
                    employeeDetailsApiReturnModel.employeeJobDetails = _employeeJobRepository.GetEmployeeJobDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "LanguageDetails":
                    employeeDetailsApiReturnModel.employeeLanguageDetails = _employeeLanguageRepository.GetEmployeeLanguageDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "LicenceDetails":
                    employeeDetailsApiReturnModel.employeeLicenceDetails = _employeeLicenceRepository.GetEmployeeLicenceDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "ReportToDetails":
                    employeeDetailsApiReturnModel.employeeReportToDetails = _employeeReportToRepository.GetEmployeeReportToDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "SalaryDetails":
                    employeeDetailsApiReturnModel.employeeSalaryDetails = _employeeSalaryRepository.GetEmployeeSalaryDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "SkillDetails":
                    employeeDetailsApiReturnModel.employeeSkillDetails = _employeeSkillRepository.GetEmployeeSkillDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "WorkExperienceDetails":
                    employeeDetailsApiReturnModel.employeeWorkExperienceDetails = _employeeWorkExperienceRepository.GetEmployeeWorkExperienceDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "ContractDetails":
                    employeeDetailsApiReturnModel.employmentContractDetails = _employmentContractRepository.GetEmploymentContractDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "MembershipDetails":
                    employeeDetailsApiReturnModel.employeeMembershipDetails = _employeeMembershipRepository.GetEmployeeMembershipDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "PersonalDetails":
                    employeeDetailsApiReturnModel.employeePersonalDetails = _employeeRepository.GetEmployeePersonalDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "RateSheetDetails":
                    employeeDetailsApiReturnModel.employeeRateSheetDetails = _ratesheetRepository.GetEmployeeRateSheetDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                case "RateTagDetails":
                    employeeDetailsApiReturnModel.employeeRateTagDetails = _payRollRepository.GetEmployeeRateTagDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
                default:
                    employeeDetailsApiReturnModel.employeePersonalDetails = _employeeRepository.GetEmployeePersonalDetails(employeeDetailSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
                    break;
            }

            return employeeDetailsApiReturnModel;
        }

        public List<EmployeeDependentContactModel> SearchEmployeeDependentContacts(EmployeeDependentContactSearchInputModel employeeDependentContactSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search employee dependent conatcts", "employeeDependentContactSearchInputModel", employeeDependentContactSearchInputModel, "Hr Management Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeDependentContactsCommandId, employeeDependentContactSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                employeeDependentContactSearchInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting employee dependent contact list ");
            List<EmployeeDependentContactModel> relationshipsList = _relationshipRepository.SearchEmployeeDependentContacts(employeeDependentContactSearchInputModel, loggedInContext, validationMessages).ToList();
            return relationshipsList;
        }

        public EmployeeDependentContactModel GetEmployeeDependentContactsById(EmployeeDependentContactSearchInputModel employeeDependentContactSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search employee dependent conatcts", "employeeDependentContactSearchInputModel", employeeDependentContactSearchInputModel, "Hr Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetEmployeeDependentContactsByIdCommandId, employeeDependentContactSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                employeeDependentContactSearchInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting employee dependent contact list ");
            EmployeeDependentContactModel relationshipsList = _relationshipRepository.SearchEmployeeDependentContacts(employeeDependentContactSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();
            return relationshipsList;
        }

        public List<EmployeeOverViewDetailsOutputModel> GetEmployeeOverViewDetails(Guid? employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeOverViewDetails", "Hr Management Service"));
            LoggingManager.Info("EmployeeId :- " + employeeId);
            _auditService.SaveAudit(AppCommandConstants.GetEmployeeOverViewDetailsCommandId, employeeId, loggedInContext);
            if (!HrManagementValidationsHelper.ValidateGetEmployeeOverViewDetails(employeeId, loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Employee Over View Details list ");
            List<EmployeeOverViewDetailsOutputModel> employeeOverViewDetailsList = _employeeRepository.GetEmployeeOverViewDetails(employeeId, loggedInContext, validationMessages).ToList();
            return employeeOverViewDetailsList;
        }

        public EmployeeLicenceDetailsApiReturnModel SearchEmployeeLicenseDetails(EmployeeLicenseDetailsInputModel getEmployeeLicenseDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchEmployeeLicenseDetails", "EmployeeId", getEmployeeLicenseDetailsInputModel.EmployeeId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateEmployeeLicenceById(getEmployeeLicenseDetailsInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeLicenceDetailsApiReturnModel employeeLicenceDetailsApiReturnModel = _employeeLicenceRepository.SearchEmployeeLicenseDetails(getEmployeeLicenseDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();

            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeLicenseDetailsCommandId, getEmployeeLicenseDetailsInputModel, loggedInContext);

            return employeeLicenceDetailsApiReturnModel;
        }

        public EmployeeSalaryDetailsApiReturnModel SearchEmployeeSalaryDetails(Models.HrManagement.EmployeeSalaryDetailsInputModel getEmployeeSalaryDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "getEmployeeSalaryDetailsInputModel", "EmployeeId", getEmployeeSalaryDetailsInputModel.EmployeeId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateEmployeeSalaryById(getEmployeeSalaryDetailsInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeSalaryDetailsApiReturnModel employeeSalaryDetailsApiReturnModel = _employeeSalaryRepository.SearchEmployeeSalaryDetails(getEmployeeSalaryDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();

            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeSalaryDetailsCommandId, getEmployeeSalaryDetailsInputModel, loggedInContext);

            return employeeSalaryDetailsApiReturnModel;
        }

        public EmployeeSkillDetailsApiReturnModel SearchEmployeeSkillDetails(EmployeeSkillDetailsInputModel getEmployeeSkillDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "getEmployeeSkillDetailsInputModel", "EmployeeId", getEmployeeSkillDetailsInputModel.EmployeeId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateEmployeeId(getEmployeeSkillDetailsInputModel.EmployeeId, loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeSkillDetailsApiReturnModel employeeSKillDetailsApiReturnModel = _employeeSkillRepository.SearchEmployeeSkillDetails(getEmployeeSkillDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();

            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeSkillDetailsCommandId, getEmployeeSkillDetailsInputModel, loggedInContext);

            return employeeSKillDetailsApiReturnModel;
        }

        public EmployeeWorkExperienceDetailsApiReturnModel SearchEmployeeWorkExperienceDetails(EmployeeWorkExperienceDetailsInputModel getEmployeeWorkExperienceDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "getEmployeeWorkExpericenceDetailsInputModel", "EmployeeId", getEmployeeWorkExperienceDetailsInputModel.EmployeeId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateEmployeeId(getEmployeeWorkExperienceDetailsInputModel.EmployeeId, loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeWorkExperienceDetailsApiReturnModel employeeSKillDetailsApiReturnModel = _employeeWorkExperienceRepository.SearchEmployeeWorkExperienceDetails(getEmployeeWorkExperienceDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();

            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeWorkExperienceDetailsCommandId, getEmployeeWorkExperienceDetailsInputModel, loggedInContext);

            return employeeSKillDetailsApiReturnModel;
        }

        public EmployeeMembershipDetailsApiReturnModel SearchEmployeeMembershipDetails(EmployeeMembershipDetailsInputModel getEmployeeMembershipDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "getEmployeeWorkExpericenceDetailsInputModel", "EmployeeId", getEmployeeMembershipDetailsInputModel.EmployeeId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateEmployeeId(getEmployeeMembershipDetailsInputModel.EmployeeId, loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeMembershipDetailsApiReturnModel employeeMemberShipDetailsApiReturnModel = _employeeMembershipRepository.SearchEmployeeMembershipDetails(getEmployeeMembershipDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();
            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeMembershipDetailsCommandId, getEmployeeMembershipDetailsInputModel, loggedInContext);

            return employeeMemberShipDetailsApiReturnModel;
        }

        public EmployeeReportToDetailsApiReturnModel SearchEmployeeReportToDetails(EmployeeReportToDetailsInputModel getEmployeeReportToDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "getEmployeeReportToDetailsInputModel", "EmployeeId", getEmployeeReportToDetailsInputModel.EmployeeId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateEmployeeId(getEmployeeReportToDetailsInputModel.EmployeeId, loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeReportToDetailsApiReturnModel employeeReportToDetailsApiReturnModel = _employeeReportToRepository.SearchEmployeeReportToDetails(getEmployeeReportToDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();
            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeReportToDetailsCommandId, getEmployeeReportToDetailsInputModel, loggedInContext);

            return employeeReportToDetailsApiReturnModel;
        }

        public EmployeeLanguageDetailsApiReturnModel SearchEmployeeLanguageDetails(EmployeeLanguageDetailsInputModel getEmployeeLanguageDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "getEmployeeLanguageDetailsInputModel", "EmployeeId", getEmployeeLanguageDetailsInputModel.EmployeeId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateEmployeeId(getEmployeeLanguageDetailsInputModel.EmployeeId, loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeLanguageDetailsApiReturnModel employeeLanguageDetailsApiReturnModel = _employeeLanguageRepository.SearchEmployeeLanguageDetails(getEmployeeLanguageDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();
            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeLanguageDetailsCommandId, getEmployeeLanguageDetailsInputModel, loggedInContext);

            return employeeLanguageDetailsApiReturnModel;
        }

        public EmployeeImmigrationDetailsApiReturnModel SearchEmployeeImmigrationDetails(Models.HrManagement.EmployeeImmigrationDetailsInputModel getEmployeeImmigrationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "getEmployeeImmigrationDetailsInputModel", "EmployeeId", getEmployeeImmigrationDetailsInputModel.EmployeeId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateEmployeeId(getEmployeeImmigrationDetailsInputModel.EmployeeId, loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeImmigrationDetailsApiReturnModel employeeImmigrationDetailsApiReturnModel = _employeeImmigrationRepository.SearchEmployeeImmigrationDetails(getEmployeeImmigrationDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();
            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeImmigrationDetailsCommandId, getEmployeeImmigrationDetailsInputModel, loggedInContext);

            return employeeImmigrationDetailsApiReturnModel;
        }

        public EmployeeEducationDetailsApiReturnModel SearchEmployeeEducationDetails(Models.HrManagement.EmployeeEducationDetailsInputModel getEmployeeEducationDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeEducationDetailsInputModel", "EmployeeId", getEmployeeEducationDetailsInputModel.EmployeeId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateEmployeeId(getEmployeeEducationDetailsInputModel.EmployeeId, loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeEducationDetailsApiReturnModel employeeEducationDetailsApiReturnModel = _employeeEducationRepository.SearchEmployeeEducationDetails(getEmployeeEducationDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();
            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeEducationDetailsCommandId, getEmployeeEducationDetailsInputModel, loggedInContext);

            return employeeEducationDetailsApiReturnModel;
        }

        public EmployeeEmergencyContactDetailsApiReturnModel SearchEmployeeEmergencyContactDetails(EmployeeEmergencyDetailsDetailsInputModel getEmployeeEmergencyDetailsDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeEmergencyDetailsDetailsInputModel", "EmployeeId", getEmployeeEmergencyDetailsDetailsInputModel.EmployeeId, "HrManagement Service"));
            if (!HrManagementValidationsHelper.ValidateEmployeeId(getEmployeeEmergencyDetailsDetailsInputModel.EmployeeId, loggedInContext, validationMessages))
            {
                return null;
            }
            EmployeeEmergencyContactDetailsApiReturnModel employeeEmergencyContactDetailsApiReturnModel = _employeeEmergencyContactRepository.SearchEmployeeEmergencyContactDetails(getEmployeeEmergencyDetailsDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();
            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeEmergencyContactDetailsCommandId, getEmployeeEmergencyDetailsDetailsInputModel, loggedInContext);
            return employeeEmergencyContactDetailsApiReturnModel;
        }

        public EmploymentContractDetailsApiReturnModel SearchEmployeeContractDetails(EmployeeContractDetailsInputModel getEmployeeContractDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "getEmployeeContractDetailsInputModel", "EmployeeId", getEmployeeContractDetailsInputModel.EmployeeId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateEmployeeId(getEmployeeContractDetailsInputModel.EmployeeId, loggedInContext, validationMessages))
            {
                return null;
            }

            EmploymentContractDetailsApiReturnModel employmentContractDetailsApiReturnModel = _employmentContractRepository.SearchEmploymentContractDetails(getEmployeeContractDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();

            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeContractDetailsCommandId, getEmployeeContractDetailsInputModel, loggedInContext);

            return employmentContractDetailsApiReturnModel;
        }

        public List<ShiftTimingsSearchOutputModel> SearchShiftTimings(ShiftTimingsSearchInputModel shiftTimingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchShiftTimings", "shiftTimingsSearchInputModel", shiftTimingsSearchInputModel, "Hr Management Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchShiftTimingCommandId, shiftTimingsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                shiftTimingsSearchInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting shift timing list ");
            List<ShiftTimingsSearchOutputModel> shiftTimingsList = _shiftTimingRepository.SearchShiftTimings(shiftTimingsSearchInputModel, loggedInContext, validationMessages).ToList();
            return shiftTimingsList;
        }

        public List<ShiftWeekSearchOutputModel> GetShiftWeek(ShiftWeekSearchInputModel shiftWeekSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchShiftWeek", "shiftWeekSearchInputModel", shiftWeekSearchInputModel, "Hr Management Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchShiftTimingCommandId, shiftWeekSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                shiftWeekSearchInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting shiftWeek list  ");
            List<ShiftWeekSearchOutputModel> shiftWeekList = _shiftTimingRepository.GetShiftWeek(shiftWeekSearchInputModel, loggedInContext, validationMessages).ToList();
            return shiftWeekList;
        }

        public Guid? UpsertWebHook(WebHookUpsertInputModel webhookUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertWebHook", "HrManagement Service"));

            webhookUpsertInputModel.WebHookName = webhookUpsertInputModel.WebHookName?.Trim();

            LoggingManager.Debug(webhookUpsertInputModel.ToString());

            if (!HrManagementValidationsHelper.ValidateUpsertWebHook(webhookUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            webhookUpsertInputModel.WebHookId = _webhookRepository.UpsertWebHook(webhookUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertWebHookCommandId, webhookUpsertInputModel, loggedInContext);

            LoggingManager.Debug(webhookUpsertInputModel.WebHookId?.ToString());

            return webhookUpsertInputModel.WebHookId;
        }

        public List<WebHookApiReturnModel> GetWebHooks(WebHookSearchInputModel webhookSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWebHooks", "HrManagement Service"));

            _auditService.SaveAudit(AppCommandConstants.GetWebHookCommandId, webhookSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _webhookRepository.GetWebHooks(webhookSearchInputModel, loggedInContext, validationMessages).ToList();
        }

        public WebHookApiReturnModel GetWebHookById(WebHookSearchInputModel webhookSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWebHookById", "webhookId", webhookSearchInputModel.WebHookId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateWebHookById(webhookSearchInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            WebHookApiReturnModel webhookReturnModel = _webhookRepository.GetWebHooks(webhookSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!HrManagementValidationsHelper.ValidateWebHookFoundWithId(webhookSearchInputModel, validationMessages, webhookReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetWebHookByIdCommandId, webhookSearchInputModel, loggedInContext);

            LoggingManager.Debug(webhookReturnModel?.ToString());

            return webhookReturnModel;
        }

        public Guid? UpsertHtmlTemplate(HtmlTemplateUpsertInputModel htmlTemplateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertHtmlTemplate", "HrManagement Service"));

            htmlTemplateUpsertInputModel.HtmlTemplateName = htmlTemplateUpsertInputModel.HtmlTemplateName?.Trim();

            LoggingManager.Debug(htmlTemplateUpsertInputModel.ToString());

            if (!HrManagementValidationsHelper.ValidateUpsertHtmlTemplate(htmlTemplateUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (htmlTemplateUpsertInputModel.IsMailBased == true && htmlTemplateUpsertInputModel.MailUrls.Count > 0)
            {
                htmlTemplateUpsertInputModel.Mails = String.Join(",", htmlTemplateUpsertInputModel.MailUrls);
            }
            if (htmlTemplateUpsertInputModel.IsRoleBased == true && htmlTemplateUpsertInputModel.SelectedRoleIds.Count > 0)
            {
                htmlTemplateUpsertInputModel.Roles = String.Join(",", htmlTemplateUpsertInputModel.SelectedRoleIds);
            }

            htmlTemplateUpsertInputModel.HtmlTemplateId = _htmlTemplateRepository.UpsertHtmlTemplate(htmlTemplateUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertWebHookCommandId, htmlTemplateUpsertInputModel, loggedInContext);

            LoggingManager.Debug(htmlTemplateUpsertInputModel.HtmlTemplateId?.ToString());

            return htmlTemplateUpsertInputModel.HtmlTemplateId;
        }

        public List<HtmlTemplateApiReturnModel> GetHtmlTemplates(HtmlTemplateSearchInputModel htmlTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHtmlTemplates", "HrManagement Service"));

            LoggingManager.Debug(htmlTemplateSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetWebHookCommandId, htmlTemplateSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<HtmlTemplateApiReturnModel> htmlTemplateReturnModels = _htmlTemplateRepository.GetHtmlTemplates(htmlTemplateSearchInputModel, loggedInContext, validationMessages).ToList();

            if (htmlTemplateReturnModels.Count > 0)
            {
                Parallel.ForEach(htmlTemplateReturnModels, template =>
                {
                    template.SelectedRoleIds = (template.IsRoleBased == true && template.Roles.Length > 0) ? template.Roles.Split(',').Select(p => new Guid(p)).ToList() : new List<Guid>();
                    template.MailUrls = (template.IsMailBased == true && template.Mails.Length > 0) ? template.Mails.Split(',').ToList() : new List<string>();
                });
            }

            return htmlTemplateReturnModels;
        }

        public HtmlTemplateApiReturnModel GetHtmlTemplateById(HtmlTemplateSearchInputModel htmlTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetHtmlTemplateById", "htmlTemplateId", htmlTemplateSearchInputModel.HtmlTemplateId, "HrManagement Service"));


            if (!HrManagementValidationsHelper.ValidateHtmlTemplateById(htmlTemplateSearchInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            HtmlTemplateApiReturnModel htmlTemplateReturnModel = _htmlTemplateRepository.GetHtmlTemplates(htmlTemplateSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!HrManagementValidationsHelper.ValidateHtmlTemplateFoundWithId(htmlTemplateSearchInputModel, validationMessages, htmlTemplateReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetWebHookByIdCommandId, htmlTemplateSearchInputModel, loggedInContext);

            LoggingManager.Debug(htmlTemplateReturnModel?.ToString());

            return htmlTemplateReturnModel;
        }

        public List<StatusReportingOptionsApiReturnModel> GetShiftTimingOptions(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatusConfigurationOptions", "Status Reporting Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<StatusReportingOptionsApiReturnModel> options = _statusReportingRepository.GetStatusConfigurationOptions(loggedInContext, validationMessages);
            var shiftOptions = from option in options where option.SortOrder < 8 select option;
            options = new List<StatusReportingOptionsApiReturnModel>();
            foreach (var shiftOption in shiftOptions)
            {
                StatusReportingOptionsApiReturnModel statusReportingOptionsApiReturnModel = new StatusReportingOptionsApiReturnModel
                {
                    Id = shiftOption.Id,
                    DisplayName = shiftOption.DisplayName,
                    CompanyId = shiftOption.CompanyId,
                    CreatedByUserId = shiftOption.CreatedByUserId,
                    CreatedDateTime = shiftOption.CreatedDateTime,
                    IsArchived = shiftOption.IsArchived,
                    OptionName = shiftOption.OptionName,
                    SortOrder = shiftOption.SortOrder,
                    TimeStamp = shiftOption.TimeStamp,
                    TotalCount = shiftOption.TotalCount,
                    UpdatedByUserId = shiftOption.UpdatedByUserId,
                    UpdatedDateTime = shiftOption.UpdatedDateTime
                };
                options.Add(statusReportingOptionsApiReturnModel);
            }
            return options;
        }

        private BreakTypeApiReturnModel ConvertToBreakTypeApiReturnModel(BreakTypeSpReturnModel breakTypeSpReturnModel)
        {
            BreakTypeApiReturnModel breakTypeApiReturnModel = new BreakTypeApiReturnModel();

            breakTypeApiReturnModel.InjectFrom<NullableInjection>(breakTypeSpReturnModel);

            breakTypeApiReturnModel.CreatedOn = breakTypeSpReturnModel.CreatedDateTime.ToString("dd-MM-yyyy");
            breakTypeApiReturnModel.InActiveOn = breakTypeSpReturnModel.InActiveDateTime?.ToString("dd-MM-yyyy");

            return breakTypeApiReturnModel;
        }

        public List<TeamMemberOutputModel> GetMyTeamMembersList(SearchModel searchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMyTeamMembersList", "Hr Management Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext,
                validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting My TeamMembers List ");
            List<TeamMemberOutputModel> teamMembersList = _employeeRepository.GetMyTeamMembersList(searchModel, loggedInContext, validationMessages).ToList();
            return teamMembersList;
        }

        public List<UserOutputModel> GetEmployeeReportToMembers(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeReportToMembers", "Hr Management Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext,
                validationMessages))
            {
                return null;
            }

            return _employeeRepository.GetEmployeeReportToMembers(userId, loggedInContext, validationMessages).ToList();
        }

        public Guid? GetMyEmployeeId(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get my employee id", "Hr Management Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext,
                validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting My Employee id ");
            List<EmployeeOverViewDetailsOutputModel> employeeOverViewDetailsOutputModelsList = _employeeRepository.GetMyEmployeeId(userId, loggedInContext, validationMessages).ToList();

            if (employeeOverViewDetailsOutputModelsList.Count > 0)
            {
                return employeeOverViewDetailsOutputModelsList[0].EmployeeId;
            }
            return null;
        }

        public Guid? UpsertShiftException(ShiftExceptionUpsertInputModel shiftExceptionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered Upsert Shift exception with shift timing Id " + shiftExceptionUpsertInputModel.ShiftTimingId + ", deadline=" + shiftExceptionUpsertInputModel.DeadLine + ", Logged in User Id=" + loggedInContext.LoggedInUserId);

            if (!HrManagementValidationsHelper.UpsertShiftExceptionsException(shiftExceptionUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            shiftExceptionUpsertInputModel.ShiftExceptionId = _shiftTimingRepository.UpsertShiftException(shiftExceptionUpsertInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Shift Exception with the id " + shiftExceptionUpsertInputModel.ShiftExceptionId + " has been created.");
            _auditService.SaveAudit(AppCommandConstants.UpsertShiftTimingCommandId, shiftExceptionUpsertInputModel, loggedInContext);
            return shiftExceptionUpsertInputModel.ShiftExceptionId;
        }

        public List<ShiftExceptionSearchOutputModel> GetShiftException(ShiftExceptionSearchInputModel shiftExceptionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchShiftWeek", "shiftExceptionSearchInputModel", shiftExceptionSearchInputModel, "Hr Management Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchShiftTimingCommandId, shiftExceptionSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                shiftExceptionSearchInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting shiftException List");

            List<ShiftExceptionSearchOutputModel> shiftExceptionList = _shiftTimingRepository.GetShiftException(shiftExceptionSearchInputModel, loggedInContext, validationMessages).ToList();

            return shiftExceptionList;
        }

        public EmployeeDetailsOutputModel GetMyEmployeeDetails(Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeOverViewDetails", "Hr Management Service"));
            LoggingManager.Info("EmployeeId :- " + employeeId);
            _auditService.SaveAudit(AppCommandConstants.GetEmployeeOverViewDetailsCommandId, employeeId, loggedInContext);
            if (!HrManagementValidationsHelper.ValidateGetEmployeeOverViewDetails(employeeId, loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting my Employee Details list ");

            EmployeeDetailsOutputModel employeeDetailsOutputModel = _employeeRepository.GetMyEmployeeDetalis(employeeId, loggedInContext, validationMessages);
            if (employeeDetailsOutputModel != null)
            {
                return employeeDetailsOutputModel;
            }
            return null;
        }

        public Guid? InsertEmployeeRatesheetDetails(EmployeeRateSheetDetailsAddInputModel employeeRateSheetDetailsAddInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeSalaryDetails", "employeeRateSheetDetailsAddInputModel", employeeRateSheetDetailsAddInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.InsertEmployeeRatesheetDetailsValidation(employeeRateSheetDetailsAddInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }
            employeeRateSheetDetailsAddInputModel.EmployeeRatesheetDetailsString = JsonConvert.SerializeObject(employeeRateSheetDetailsAddInputModel.RateSheetDetails);
            Guid? employeeRatesheetId = _ratesheetRepository.InsertRatesheetDetails(employeeRateSheetDetailsAddInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee Salary Details with the id " + employeeRatesheetId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeSalaryDetailsCommandId, employeeRateSheetDetailsAddInputModel, loggedInContext);
            return employeeRatesheetId;
        }

        public Guid? UpdateEmployeeRatesheetDetails(EmployeeRatesheetDetailsEditInputModel employeeRatesheetDetailsEditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeSalaryDetails", "employeeRateSheetDetailsAddInputModel", employeeRatesheetDetailsEditInputModel, "HrManagement Service"));
            if (!HrManagementValidationsHelper.UpdateEmployeeRatesheetDetailsValidation(employeeRatesheetDetailsEditInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            Guid? employeeRatesheetId = _ratesheetRepository.UpdateRatesheetDetails(employeeRatesheetDetailsEditInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee Salary Details with the id " + employeeRatesheetId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeSalaryDetailsCommandId, employeeRatesheetDetailsEditInputModel, loggedInContext);
            return employeeRatesheetId;
        }

        public EmployeeRateSheetDetailsApiReturnModel SearchEmployeeRateSheetDetails(EmployeeRateSheetDetailsInputModel getEmployeeRateSheetDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "getEmployeeRateSheetDetailsInputModel", "EmployeeId", getEmployeeRateSheetDetailsInputModel.EmployeeId, "HrManagement Service"));

            if (!HrManagementValidationsHelper.ValidateEmployeeRatesheetById(getEmployeeRateSheetDetailsInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeRateSheetDetailsApiReturnModel employeeRateSheetDetailsApiReturnModel = _ratesheetRepository.GetEmployeeRateSheetDetailsById(getEmployeeRateSheetDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();

            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeRateSheetDetailsCommandId, getEmployeeRateSheetDetailsInputModel, loggedInContext);
            return employeeRateSheetDetailsApiReturnModel;
        }

        public Guid? UpsertBadge(BadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "getEmployeeRateSheetDetailsInputModel", "BadgeModel", badgeModel, "HrManagement Service"));

            if (!HrManagementValidationsHelper.ValidateBadgeInputs(badgeModel, loggedInContext, validationMessages))
            {
                return null;
            }

            return _employeeRepository.UpsertBadge(badgeModel, loggedInContext, validationMessages);
        }

        public List<BadgeModel> GetBadges(BadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "badgeModel", "BadgeModel", badgeModel, "HrManagement Service"));

            return _employeeRepository.GetBadges(badgeModel, loggedInContext, validationMessages);
        }

        public Guid? AssignBadgeToEmployee(EmployeeBadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "EmployeeBadgeModel", "employeeBadgeModel", badgeModel, "HrManagement Service"));

            if (!HrManagementValidationsHelper.ValidateEmployeeBadgeInputs(badgeModel, loggedInContext, validationMessages))
            {
                return null;
            }

            badgeModel.AssignedToXml = Utilities.ConvertIntoListXml(badgeModel.AssignedTo);

            return _employeeRepository.AssignBadgeToEmployee(badgeModel, loggedInContext, validationMessages);
        }

        public List<EmployeeBadgeModel> GetBadgesAssignedToEmployee(EmployeeBadgeModel badgeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "badgeModel", "BadgeModel", badgeModel, "HrManagement Service"));

            var badges = _employeeRepository.GetBadgesAssignedToEmployee(badgeModel, loggedInContext, validationMessages);

            if (badgeModel.IsForOverView)
            {
                Parallel.ForEach(badges, badge =>
                {
                    badge.BadgeDetails = Utilities.GetObjectFromXml<BadgeDetailsModel>(badge.BadgeDetailsXml, "BadgeModel");
                });
            }

            return badges;
        }

        public Guid? UpsertAnnouncement(AnnouncementModel announcementModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "upsertAnnouncement", "AnnouncementModel", announcementModel, "HrManagement Service"));

            if (!HrManagementValidationsHelper.ValidateAnnouncementInputs(announcementModel, loggedInContext, validationMessages))
            {
                return null;
            }

            var announcementId = _employeeRepository.UpsertAnnouncement(announcementModel, loggedInContext, validationMessages);

            if (announcementId != null && announcementModel.IsArchived == false)
            {
                AnnouncementModel announcementSearchModel = new AnnouncementModel()
                {
                    AnnouncementId = announcementId
                };
                var announcements = _employeeRepository.GetAnnouncements(announcementSearchModel, loggedInContext, validationMessages);

                if (validationMessages.Count == 0 && announcements.Count > 0)
                {
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        var userIds = announcements.FirstOrDefault()?.AnnouncedTo.Split(',').ToList();
                        if (userIds != null && userIds.Count > 0)
                        {
                            foreach (var userId in userIds.Where(p => p.ToLower() != loggedInContext.LoggedInUserId.ToString().ToLower()).ToList())
                            {
                                _notificationService.SendNotification(new AnnouncementNotificationModel(
                                    string.Format(NotificationSummaryConstants.AnnouncementReceived, announcements[0].AnnouncedBy),
                                    loggedInContext.LoggedInUserId,
                                    new Guid(userId),
                                    announcements[0].AnnouncementId,
                                    announcements[0].Announcement,
                                    announcements[0].AnnouncedBy,
                                    announcements[0].AnnouncedOn,
                                    announcements[0].AnnouncedById,
                                    announcements[0].AnnouncedByUserImage
                                ), loggedInContext, new Guid(userId));
                            }
                        }

                    });
                }
            }
            return announcementId;
        }

        public List<AnnouncementModel> GetAnnouncements(AnnouncementModel announcementModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAnnouncements", "AnnouncementModel", announcementModel, "HrManagement Service"));

            return _employeeRepository.GetAnnouncements(announcementModel, loggedInContext, validationMessages);
        }

        public Guid? UpsertReminder(ReminderModel reminder, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertReminder", "ReminderModel", reminder, "HrManagement Service"));

            if (!HrManagementValidationsHelper.ValidateReminderInputs(reminder, loggedInContext, validationMessages))
            {
                return null;
            }

            return _hrDashboardRepository.UpsertReminder(reminder, loggedInContext, validationMessages);
        }

        public List<ReminderModel> GetReminders(ReminderModel reminder, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetReminders", "ReminderModel", reminder, "HrManagement Service"));

            return _hrDashboardRepository.GetRemindersBasedOnReference(reminder, loggedInContext, validationMessages);
        }

        public List<EmployeeDetailsHistoryApiReturnModel> GetEmployeeDetailsHistory(EmployeeDetailsHistoryApiInputModel employeeDetailsHistoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeDetailsHistory", "EmployeeDetailsHistoryApiInputModel", employeeDetailsHistoryApiInputModel, "HrManagement Service"));

            return _employeeRepository.GetEmployeeDetailsHistory(employeeDetailsHistoryApiInputModel, loggedInContext, validationMessages);
        }

        public void EmployeeUpload(List<EmployeePersonalDetailsInputModel> employeePersonalDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "EmployeeUpload", "HrManagement Service"));

            if (employeePersonalDetailsInputModel.Count > 0)
            {
                employeePersonalDetailsInputModel.ForEach(employeeModel =>
                {
                    List<ValidationMessage> validations = new List<ValidationMessage>();
                    UpsertEmployeePersonalDetails(employeeModel, loggedInContext, validations);
                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                    }
                });
            }
        }

        public Guid? UpsertGrade(GradeInputModel gradeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertGrade", "PayRoll Service"));

            LoggingManager.Debug(gradeInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? result = _employeeRepository.UpsertGrade(gradeInputModel, loggedInContext, validationMessages);
            return result;
        }

        public List<GetGradesOutputModel> GetGrades(GetGradesInputModel getGradesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGrades", "PayRoll Service"));

            LoggingManager.Debug(getGradesInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<GetGradesOutputModel> result = _employeeRepository.GetGrades(getGradesInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }
        public Guid? UpsertEmployeeGrade(EmployeeGradeInputModel employeeGradeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeGrade", "PayRoll Service"));

            LoggingManager.Debug(employeeGradeInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? result = _employeeRepository.UpsertEmployeeGrade(employeeGradeInputModel, loggedInContext, validationMessages);
            return result;
        }
        public List<EmployeeGradeApiOutputModel> GetEmployeeGrades(EmployeeGradeSearchInputModel employeeGradeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeGrades", "PayRoll Service"));

            LoggingManager.Debug(employeeGradeSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<EmployeeGradeApiOutputModel> result = _employeeRepository.GetEmployeeGrades(employeeGradeSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public void CheckDailyReminders()
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckDailyReminders", "HrDashboard Service"));

            List<ReminderDetailsModel> reminders = _hrDashboardRepository.GetTodaysReminders();

            LoggingManager.Info("Got " + reminders.Count + " on " + DateTime.Now.ToString());

            foreach (var reminder in reminders)
            {
                LoggedInContext loggedinUser = new LoggedInContext()
                {
                    LoggedInUserId = reminder.CreatedByUserId.Value,
                    CompanyGuid = reminder.CompanyId.Value,
                    CurrentUrl = reminder.SiteAddress
                };

                var reminderMessage = string.Empty;
                var reminderfailureMessage = string.Empty;

                if (reminder.ReferenceTypeId.Value == AppConstants.ImmigrationReferenceTypeId)
                {
                    reminderMessage = "You have set a reminder agianst Immigrations details of " + reminder.OfUserName + ".";
                    reminderfailureMessage = reminder.CreatedByUserName + " have set a reminder agianst Immigrations details of " + reminder.OfUserName + ".";
                }
                else if (reminder.ReferenceTypeId.Value == AppConstants.LicenceReferenceTypeId)
                {
                    reminderMessage = "You have set a reminder agianst Licence details of " + reminder.OfUserName + ".";
                    reminderfailureMessage = reminder.CreatedByUserName + " have set a reminder agianst Licence details of " + reminder.OfUserName + ".";
                }
                else if (reminder.ReferenceTypeId.Value == AppConstants.MembershipReferenceTypeId)
                {
                    reminderMessage = "You have set a reminder agianst Membership details of " + reminder.OfUserName + ".";
                    reminderfailureMessage = reminder.CreatedByUserName + " have set a reminder agianst Membership details of " + reminder.OfUserName + ".";
                }
                else if (reminder.ReferenceTypeId.Value == AppConstants.ContractReferenceTypeId)
                {
                    reminderMessage = "You have set a reminder agianst Contract details of " + reminder.OfUserName + ".";
                    reminderfailureMessage = reminder.CreatedByUserName + " have set a reminder agianst Contract details of " + reminder.OfUserName + ".";
                }

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedinUser, validationMessages, null);

                if (reminder.NotificationType == (int)Enumerators.NotificationType.Email)
                {
                    LoggingManager.Info("started creating a email to " + reminder.CreatedByEmail + " on " + DateTime.Now.ToString());

                    string additionalInfo = string.IsNullOrEmpty(reminder.AdditionalInfo) ? null :
                        "<b>Additional info:</b> " + reminder.AdditionalInfo + "<br/><br/>";

                    var html = _goalRepository.GetHtmlTemplateByName("UserReminderTemplate", loggedinUser.CompanyGuid);
                    html = html.Replace("##Name##", reminder.CreatedByUserName).
                            Replace("##reminderMessage##", reminderMessage).
                            Replace("##additionalInfo##", additionalInfo).
                            Replace("##CompanyName##", smtpDetails.CompanyName);

                    var toMails = new string[1];
                    toMails[0] = reminder.CreatedByEmail;
                    try
                    {
                        LoggingManager.Info("sending a email to " + reminder.CreatedByEmail + " on " + DateTime.Now.ToString());
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = toMails,
                            HtmlContent = html,
                            Subject = "Snovasys Business Suite: User reminder",
                            CCMails = null,
                            BCCMails = null,
                            MailAttachments = null,
                            IsPdf = null
                        };
                        _emailService.SendMail(loggedinUser, emailModel);
                        LoggingManager.Info("email successfully sent to " + reminder.CreatedByEmail + " on " + DateTime.Now.ToString());
                        reminder.Status = "Success";
                    }
                    catch (Exception ex)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckDailyReminders", "HrManagementService ", ex.Message), ex);

                        reminder.Status = "Failed";
                    }
                }
                else if (reminder.NotificationType == (int)Enumerators.NotificationType.PushNotification)
                {
                    try
                    {
                        LoggingManager.Info("sending a push notification to " + reminder.CreatedByUserName + " on " + DateTime.Now.ToString());
                        _notificationService.SendNotification(new ReminderNoticationModel(
                                        reminderMessage,
                                        reminder.NotifiedBy.Value,
                                        reminder.CreatedByUserId.Value,
                                        reminder.ReminderId
                                        ), loggedinUser, reminder.CreatedByUserId.Value);
                        LoggingManager.Info("push notification successfully sent to " + reminder.CreatedByUserName + " on " + DateTime.Now.ToString());
                        reminder.Status = "Success";
                    }
                    catch (Exception ex)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckDailyReminders", "HrManagementService ", ex.Message), ex);
                        reminder.Status = "Failed";
                    }
                }
                if (reminder.Status == "Failed")
                {
                    LoggingManager.Info("reminder with id " + reminder.ReminderId + " failed and notifying admin mail on " + DateTime.Now.ToString());

                    var additionalInfo = "<b>Reminder failure info:</b> You got this mail as reminder created by " + reminder.CreatedByUserName + " is failed due to some technical isues<br/><br/>";

                    var html = _goalRepository.GetHtmlTemplateByName("UserReminderTemplate", loggedinUser.CompanyGuid);
                    html = html.Replace("##Name##", "").
                            Replace("##reminderMessage##", reminderfailureMessage).
                            Replace("##additionalInfo##", additionalInfo).
                            Replace("##CompanyName##", smtpDetails.CompanyName);

                    CompanySettingsSearchInputModel companySettingsSearchInputModel = new CompanySettingsSearchInputModel()
                    {
                        IsArchived = false,
                        Key = "AdminMails"
                    };
                    var companyadminMail = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedinUser, validationMessages)?.FirstOrDefault()?.Value?.Split(',')?.FirstOrDefault();

                    try
                    {
                        LoggingManager.Info("sending a email to " + companyadminMail + " on " + DateTime.Now.ToString());
                        var toMails = new string[1];
                        toMails[0] = companyadminMail;
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = toMails,
                            HtmlContent = html,
                            Subject = "Snovasys Business Suite: User reminder failure notification",
                            CCMails = null,
                            BCCMails = null,
                            MailAttachments = null,
                            IsPdf = null
                        };
                        _emailService.SendMail(loggedinUser, emailModel);
                        reminder.Status = "Sent to admin";
                    }
                    catch (Exception ex)
                    {
                        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckDailyReminders", "HrManagementService ", ex.Message), ex);
                        reminder.Status = "Failed";
                    }

                }
                _hrDashboardRepository.UpdateReminderStatus(reminder);

            }
        }

        public List<EmployeeImportApiModel> ImportEmployees(SpreadsheetDocument spreadSheetDocument, string fileName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            Sheet sheet = spreadSheetDocument.WorkbookPart.Workbook.GetFirstChild<Sheets>().Elements<Sheet>().FirstOrDefault();
            List<EmployeeImportApiModel> employeeImportApiModels = new List<EmployeeImportApiModel>();
            string sheetId = sheet.Id.Value;
            WorksheetPart worksheetPart = (WorksheetPart)spreadSheetDocument.WorkbookPart.GetPartById(sheetId);
            Worksheet workSheet = worksheetPart.Worksheet;
            SheetData sheetData = workSheet.GetFirstChild<SheetData>();
            IEnumerable<Row> rows = sheetData.Descendants<Row>();

            var sheetHeaders = new List<string>();

            for (int i = 0; i < rows.First().Descendants<Cell>().Count(); i++)
            {
                var header = GetCellValue(spreadSheetDocument, rows.First().Descendants<Cell>().ElementAt(i));

                sheetHeaders.Add(header);
            }

            for (int i = 1; i < rows.Count(); i++)
            {
                var row = rows.ElementAt(i);

                var keyValuePairs = new List<EmployeeImportApiModel.EmployeeExcelPair>();

                for (int j = 0; j < row.Descendants<Cell>().Count(); j++)
                {
                    EmployeeImportApiModel.EmployeeExcelPair tempRow = new EmployeeImportApiModel.EmployeeExcelPair
                    {
                        Key = sheetHeaders[i].ToLower(),
                        Value = GetCellValue(spreadSheetDocument, row.Descendants<Cell>().ElementAt(i))
                    };

                    keyValuePairs.Add(tempRow);
                }

                EmployeeImportApiModel employeeImportApiModel = new EmployeeImportApiModel
                {
                    EmployeeNumber = keyValuePairs.Where(x => x.Key.Equals("employee number"))?.FirstOrDefault()?.Value,
                    FirstName = keyValuePairs.Where(x => x.Key.Equals("first name"))?.FirstOrDefault()?.Value,
                    LastName = keyValuePairs.Where(x => x.Key.Equals("last name"))?.FirstOrDefault()?.Value,
                    EmailId = keyValuePairs.Where(x => x.Key.Equals("email id"))?.FirstOrDefault()?.Value,
                    MobileNumber = keyValuePairs.Where(x => x.Key.Equals("mobile number"))?.FirstOrDefault()?.Value,
                    Role = keyValuePairs.Where(x => x.Key.Equals("role"))?.FirstOrDefault()?.Value,
                    Designation = keyValuePairs.Where(x => x.Key.Equals("designation"))?.FirstOrDefault()?.Value,
                    EmploymentType = keyValuePairs.Where(x => x.Key.Equals("employment type"))?.FirstOrDefault()?.Value,
                    BranchJoining = keyValuePairs.Where(x => x.Key.Equals("branch joining"))?.FirstOrDefault()?.Value,
                    Date = keyValuePairs.Where(x => x.Key.Equals("date"))?.FirstOrDefault()?.Value,
                    Timezone = keyValuePairs.Where(x => x.Key.Equals("timezone"))?.FirstOrDefault()?.Value,
                    CTCPayroll = keyValuePairs.Where(x => x.Key.Equals("ctc payroll"))?.FirstOrDefault()?.Value,
                    Template = keyValuePairs.Where(x => x.Key.Equals("template"))?.FirstOrDefault()?.Value
                };
                employeeImportApiModels.Add(employeeImportApiModel);
            }

            return employeeImportApiModels;
        }

        private static string GetCellValue(SpreadsheetDocument document, DocumentFormat.OpenXml.Spreadsheet.Cell cell)
        {
            SharedStringTablePart stringTablePart = document.WorkbookPart.SharedStringTablePart;
            string value = cell.CellValue?.InnerXml;

            if (cell.DataType != null && cell.DataType.Value == CellValues.SharedString)
            {
                return stringTablePart.SharedStringTable.ChildElements[Int32.Parse(value)].InnerText;
            }
            else
            {
                return value;
            }
        }

        public List<DocumentTemplateModel> GetDocumentTemplates(DocumentTemplateModel documentTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDocumentTemplates", "HrManagement Service"));

            _auditService.SaveAudit(AppCommandConstants.GetWebHookCommandId, documentTemplateModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<DocumentTemplateModel> htmlTemplateReturnModels = _htmlTemplateRepository.GetDocumentTemplates(documentTemplateModel, loggedInContext, validationMessages).ToList();

            return htmlTemplateReturnModels;
        }

        public Guid? UpsertDocumentTemplate(DocumentTemplateModel documentTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDocumentTemplate", "HrManagement Service"));

            _auditService.SaveAudit(AppCommandConstants.GetWebHookCommandId, documentTemplateModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? htmlTemplateReturnModels = _htmlTemplateRepository.UpsertDocumentTemplate(documentTemplateModel, loggedInContext, validationMessages);

            return htmlTemplateReturnModels;
        }

        public EmployeeReportDetailsModel GenerateReportForanEmployee(DocumentTemplateModel documentTemplateModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenerateReportForanEmployee", "HrManagement Service"));

            _auditService.SaveAudit(AppCommandConstants.GetWebHookCommandId, documentTemplateModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeReportDetailsModel htmlTemplateReturnModels = _htmlTemplateRepository.GenerateReportForanEmployee(documentTemplateModel, loggedInContext, validationMessages);

            generateReport(documentTemplateModel.TemplatePath, documentTemplateModel.TemplateName, htmlTemplateReturnModels);

            return htmlTemplateReturnModels;
        }

        public void generateReport(string filePath, string fileName, EmployeeReportDetailsModel htmlTemplateReturnModels)
        {
            Object oMissing = System.Reflection.Missing.Value;
            Object oTemplatePath = filePath;
            Application wordApp = new Application();
            Document wordDoc = new Document();
            wordDoc = wordApp.Documents.Add(ref oTemplatePath, ref oMissing, ref oMissing, ref oMissing);


            foreach (Microsoft.Office.Interop.Word.Field myMergeField in wordDoc.Fields)
            {
                Range rngFieldCode = myMergeField.Code;

                String fieldText = rngFieldCode.Text;

                if (fieldText.StartsWith(" MERGEFIELD"))
                {
                    Int32 endMerge = fieldText.IndexOf("\\");
                    Int32 fieldNameLength = fieldText.Length - endMerge;
                    String fieldName = fieldText.Substring(11, endMerge - 11);

                    fieldName = fieldName.Trim();

                    if (fieldName == "NameOfTheCandidate")
                    {
                        myMergeField.Select();
                        wordApp.Selection.TypeText("Mounika");
                    }
                }
            }
            var name = fileName + htmlTemplateReturnModels.EmployeeId;
            wordDoc.SaveAs(name);
            wordApp.Application.Quit();
        }

        public bool UpdateUnreadAnnouncements(AnnouncementReadInputModel announcementReadInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateMessageReadReceipt", "HrManagementService"));

            if (announcementReadInputModel != null)
            {
                var result = _employeeRepository.UpdateUnreadAnnouncements(announcementReadInputModel, loggedInContext, validationMessages);

                return result;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateMessageReadReceipt", "HrManagementService"));

            return false;
        }

        public List<AnnouncementModel> GetUnreadAnnouncements(AnnouncementModel announcementModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUnreadAnnouncements", "AnnouncementModel", announcementModel, "HrManagement Service"));

            return _employeeRepository.GetUnreadAnnouncements(announcementModel, loggedInContext, validationMessages);
        }
        public List<ReadAndUnReadUsersOfAnnouncementApiReturnModel> GetReadAndUnReadUsersOfAnnouncement(Guid? AnnouncementId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetReadAndUnReadUsersOfAnnouncement", "AnnouncementId", AnnouncementId, "HrManagement Service"));

            return _employeeRepository.GetReadAndUnReadUsersOfAnnouncement(AnnouncementId, loggedInContext, validationMessages);
        }

        public List<EmployeeListApiOutputModel> GetEmployeesByRoleId(string roleIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeesByRoleId", "AnnouncementId", roleIds, "HrManagement Service"));
            string roleIdsXml = null;
            if (roleIds != null && !string.IsNullOrEmpty(roleIds))
            {
                string[] roles = roleIds.Split(new[] { ',' });

                List<Guid> allRoleIds = roles.Select(Guid.Parse).ToList();
                roleIdsXml = Utilities.ConvertIntoListXml(allRoleIds.ToList());
            }

            var result = _employeeRepository.GetEmployeesByRoleId(roleIdsXml, loggedInContext, validationMessages);
            if (result.Count > 0)
            {
                var returnValue = from r in result group r by r.UserId;

                List<EmployeeListApiOutputModel> returnResult = new List<EmployeeListApiOutputModel>();
                var i = 0;
                foreach (var res in returnValue)
                {
                    EmployeeListApiOutputModel employe = new EmployeeListApiOutputModel()
                    {
                        FullName = string.Empty,
                        RoleId = new Guid?(),
                        UserId = new Guid?(),
                        RoleName = string.Empty,
                        ProfileImage = string.Empty
                        //RoleIds = string.Empty
                    };
                    foreach (var ren in res)
                    {
                        if (!employe.UserId.ToString().Equals(ren.UserId.ToString()))
                        {
                            employe.UserId = ren.UserId;
                            //employe.RoleId = ren.RoleId;
                            employe.FullName = ren.FullName;
                            employe.RoleId = ren.RoleId;
                            employe.RoleName = ren.RoleName.ToString();
                            employe.ProfileImage = ren.ProfileImage;
                        }
                        else
                        {
                            //employe.RoleId = employe.RoleId + "," + ren.RoleId.ToString();
                            employe.RoleName = employe.RoleName + "," + ren.RoleName.ToString();
                        }
                    }
                    returnResult.Add(employe);
                }
                return returnResult;
            }
            return null;
        }

        public int GetActiveUsersCount(Guid? loggedInUserId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActiveUsersCount", "HrManagement Service"));
            var url = HttpContext.Current.Request.Url.Authority;

            var splits = url.Split('.');
            return _employeeRepository.GetActiveUsersCount(splits[0], loggedInUserId, validationMessages);
        }

        public bool GetIsHavingEmployeereportMembers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            //LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateMessageReadReceipt", "HrManagementService"));
            bool output = _employeeRepository.GetIsHavingEmployeereportMembers(loggedInContext, validationMessages);

            return output;
        }

    }
}