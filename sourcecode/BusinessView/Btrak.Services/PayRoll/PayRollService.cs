using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.PayRoll;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.PayRollHelper;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web.Configuration;
using System.Web.Hosting;
using System.Xml;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models.Employee;
using Btrak.Models.GenericForm;
using Btrak.Models.MasterData;
using Btrak.Models.User;
using Btrak.Models.WorkflowManagement;
using Btrak.Services.AutomatedWorkflowmanagement;
using Btrak.Services.Communication;
using Btrak.Services.CustomApplication;
using Btrak.Services.FileUploadDownload;
using CamundaClient;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using Hangfire;
using System.Net.Mail;
using System.Text.RegularExpressions;
using Btrak.Models.TestRail;
using TheArtOfDev.HtmlRenderer.PdfSharp;
using Btrak.Models.CompanyStructure;
using Btrak.Services.CompanyStructure;
using Btrak.Models.SystemManagement;
using Btrak.Services.Chromium;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Btrak.Services.Email;
using Btrak.Services.User;
using Btrak.Services.Notification;
using Btrak.Models.Notification;
using BTrak.Common.Constants;

namespace Btrak.Services.PayRoll
{
    public class PayRollService : IPayRollService
    {
        private readonly PayRollRepository _payRollRepository;
        private readonly MasterDataManagementRepository _masterManagementRepository;
        private readonly IAuditService _auditService;
        private readonly IAutomatedWorkflowmanagementServices _automatedWorkflowmanagementServices;
        private readonly ICustomApplicationService _customApplicationService;
        private readonly IFileStoreService _fileStoreService;
        private readonly GoalRepository _goalrepository;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly UserRepository _userRepository;
        private readonly IChromiumService _chromiumService;
        private readonly IEmailService _emailService;
        private readonly IUserService _userService;
        private readonly INotificationService _notificationService;

        static HexBinaryValue border = "000000";
        static HexBinaryValue insideBorder = "000000";

        public PayRollService(PayRollRepository payRollComponentRepository, ICompanyStructureService companyStructureService, IAuditService auditService, MasterDataManagementRepository masterManagementRepository, IAutomatedWorkflowmanagementServices automatedWorkflowmanagementServices, ICustomApplicationService customApplicationService, IFileStoreService fileStoreService, GoalRepository goalrepository,
            UserRepository userRepository, IChromiumService chromiumService, IEmailService emailService, IUserService userService, INotificationService notificationService)
        {
            _chromiumService = chromiumService;
            _payRollRepository = payRollComponentRepository;
            _auditService = auditService;
            _masterManagementRepository = masterManagementRepository;
            _automatedWorkflowmanagementServices = automatedWorkflowmanagementServices;
            _customApplicationService = customApplicationService;
            _fileStoreService = fileStoreService;
            _goalrepository = goalrepository;
            _companyStructureService = companyStructureService;
            _userRepository = userRepository;
            _emailService = emailService;
            _userService = userService;
            _notificationService = notificationService;
        }

        public Guid? UpsertPayRollComponent(PayRollComponentUpsertInputModel payRollComponentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(payRollComponentUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertPayRollComponentCommandId, payRollComponentUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertPayRollComponentValidation(payRollComponentUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            payRollComponentUpsertInputModel.PayRollComponentId = _payRollRepository.UpsertPayRollComponent(payRollComponentUpsertInputModel, loggedInContext, validationMessages);
            return payRollComponentUpsertInputModel.PayRollComponentId;
        }

        public List<PayRollComponentSearchOutputModel> GetPayRollComponents(PayRollComponentSearchInputModel payRollComponentSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollComponents", "PayRoll Service"));
            LoggingManager.Debug(payRollComponentSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollComponentsCommandId, payRollComponentSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<PayRollComponentSearchOutputModel> payRollComponent = _payRollRepository.GetPayRollComponents(payRollComponentSearchInputModel, loggedInContext, validationMessages).ToList();
            return payRollComponent;
        }

        public PayRollTemplateUpsertInputModel UpsertPayRollTemplate(PayRollTemplateUpsertInputModel payRollTemplateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(payRollTemplateUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertPayRollTemplateCommandId, payRollTemplateUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertPayRollTemplateValidation(payRollTemplateUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            var result = _payRollRepository.UpsertPayRollTemplate(payRollTemplateUpsertInputModel, loggedInContext, validationMessages);

            //if (result != null)
            //{
            //    RunSchedulingJobs(payRollTemplateUpsertInputModel, loggedInContext, validationMessages, result.JobId);
            //}

            return result;
        }

        public List<PayRollTemplateSearchOutputModel> GetPayRollTemplates(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollTemplates", "PayRoll Service"));
            LoggingManager.Debug(payRollTemplateSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollTemplatesCommandId, payRollTemplateSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<PayRollTemplateSearchOutputModel> payRollTemplate = _payRollRepository.GetPayRollTemplates(payRollTemplateSearchInputModel, loggedInContext, validationMessages).ToList();
            return payRollTemplate;
        }

        public List<ComponentSearchOutPutModel> GetComponents(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetComponents", "PayRoll Service"));
            LoggingManager.Debug(payRollTemplateSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollTemplatesCommandId, payRollTemplateSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ComponentSearchOutPutModel> components = _payRollRepository.GetComponents(payRollTemplateSearchInputModel, loggedInContext, validationMessages).ToList();
            return components;
        }

        public Guid? UpsertPayRollTemplateConfiguration(PayRollTemplateConfigurationUpsertInputModel payRollTemplateConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollTemplateConfiguration", "PayRoll Service"));
            LoggingManager.Debug(payRollTemplateConfigurationUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertPayRollTemplateConfigurationCommandId, payRollTemplateConfigurationUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertPayRollTemplateConfigurationValidation(payRollTemplateConfigurationUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if (payRollTemplateConfigurationUpsertInputModel.PayRollComponentIds != null)
            {
                payRollTemplateConfigurationUpsertInputModel.PayRollComponentXml = Utilities.ConvertIntoListXml(payRollTemplateConfigurationUpsertInputModel.PayRollComponentIds);
            }

            payRollTemplateConfigurationUpsertInputModel.PayRollTemplateConfigurationId = _payRollRepository.UpsertPayRollTemplateConfiguration(payRollTemplateConfigurationUpsertInputModel, loggedInContext, validationMessages);
            return payRollTemplateConfigurationUpsertInputModel.PayRollTemplateConfigurationId;
        }

        public List<PayRollTemplateConfigurationSearchOutputModel> GetPayRollTemplateConfigurations(PayRollTemplateConfigurationSearchInputModel payRollTemplateConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollTemplateConfigurations", "PayRoll Service"));
            LoggingManager.Debug(payRollTemplateConfigurationSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollTemplateConfigurationsCommandId, payRollTemplateConfigurationSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<PayRollTemplateConfigurationSearchOutputModel> payRollTemplateConfiguration = _payRollRepository.GetPayRollTemplateConfigurations(payRollTemplateConfigurationSearchInputModel, loggedInContext, validationMessages).ToList();
            return payRollTemplateConfiguration;
        }

        public List<ResignationstausSearchOutputModel> GetResignationStatus(ResignationStatusSearchInputModel resignationStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetResignationStatus", "PayRollComponent Service"));
            LoggingManager.Debug(resignationStatusSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetResignationStatusCommandId, resignationStatusSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ResignationstausSearchOutputModel> resignationStatus = _payRollRepository.GetResignationStatus(resignationStatusSearchInputModel, loggedInContext, validationMessages).ToList();
            return resignationStatus;
        }

        public Guid? UpsertResignationStatus(ResignationStatusSearchInputModel resignationStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRollComponent Service"));
            LoggingManager.Debug(resignationStatusSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertResignationStatusCommandId, resignationStatusSearchInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertResignationValidation(resignationStatusSearchInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            resignationStatusSearchInputModel.ResignationStatusId = _payRollRepository.UpsertResignationStatus(resignationStatusSearchInputModel, loggedInContext, validationMessages);
            return resignationStatusSearchInputModel.ResignationStatusId;
        }

        public List<EmployeeBonus> GetEmployeesBonusDetails(Guid? employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeBonusList", "PayRollTemplate Service"));

            List<EmployeeBonus> employeesBonusDetails = _payRollRepository.GetEmployeesBonusDetails(employeeId, loggedInContext, validationMessages).ToList();
            employeesBonusDetails.ForEach(employee => { employee.EmployeeIds.Add(employee.EmployeeId); });

            return employeesBonusDetails;
        }

        public Guid? UpsertEmployeeBonusDetails(EmployeeBonus employeeBonus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRollTemplate Service"));

            LoggingManager.Debug(employeeBonus.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertPayRollTemplateCommandId, employeeBonus, loggedInContext);

            var result = _payRollRepository.UpsertEmployeeBonusDetails(employeeBonus, loggedInContext, validationMessages);

            return result;
        }

        public List<EmployeeOutputModel> GetEmployees(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployees", "PayRollTemplate Service"));
            List<EmployeeOutputModel> employeesBonusDetails = _payRollRepository.GetEmployees(loggedInContext, validationMessages).ToList();
            return employeesBonusDetails;
        }

        public Guid? UpsertPayRollRoleConfiguration(PayRollRoleConfigurationUpsertInputModel payRollRoleConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(payRollRoleConfigurationUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertPayRollRoleConfigurationCommandId, payRollRoleConfigurationUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertPayRollRoleConfigurationValidation(payRollRoleConfigurationUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            payRollRoleConfigurationUpsertInputModel.PayRollRoleConfigurationId = _payRollRepository.UpsertPayRollRoleConfiguration(payRollRoleConfigurationUpsertInputModel, loggedInContext, validationMessages);
            return payRollRoleConfigurationUpsertInputModel.PayRollRoleConfigurationId;
        }
        public List<PayRollRoleConfigurationSearchOutputModel> GetPayRollRoleConfigurations(PayRollRoleConfigurationSearchInputModel payRollRoleConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollRoleConfigurations", "PayRoll Service"));
            LoggingManager.Debug(payRollRoleConfigurationSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollRoleConfigurationsCommandId, payRollRoleConfigurationSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<PayRollRoleConfigurationSearchOutputModel> payRollRoleConfiguration = _payRollRepository.GetPayRollRoleConfigurations(payRollRoleConfigurationSearchInputModel, loggedInContext, validationMessages).ToList();
            return payRollRoleConfiguration;
        }

        public Guid? UpsertPayRollBranchConfiguration(PayRollBranchConfigurationUpsertInputModel payRollBranchConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(payRollBranchConfigurationUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertPayRollBranchConfigurationCommandId, payRollBranchConfigurationUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertPayRollBranchConfigurationValidation(payRollBranchConfigurationUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            payRollBranchConfigurationUpsertInputModel.PayRollBranchConfigurationId = _payRollRepository.UpsertPayRollBranchConfiguration(payRollBranchConfigurationUpsertInputModel, loggedInContext, validationMessages);
            return payRollBranchConfigurationUpsertInputModel.PayRollBranchConfigurationId;
        }
        public List<PayRollBranchConfigurationSearchOutputModel> GetPayRollBranchConfigurations(PayRollBranchConfigurationSearchInputModel payRollBranchConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollBranchConfigurations", "PayRoll Service"));
            LoggingManager.Debug(payRollBranchConfigurationSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollBranchConfigurationsCommandId, payRollBranchConfigurationSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<PayRollBranchConfigurationSearchOutputModel> payRollBranchConfiguration = _payRollRepository.GetPayRollBranchConfigurations(payRollBranchConfigurationSearchInputModel, loggedInContext, validationMessages).ToList();
            return payRollBranchConfiguration;
        }
        public Guid? UpsertPayRollGenderConfiguration(PayRollGenderConfigurationUpsertInputModel payRollGenderConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(payRollGenderConfigurationUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertPayRollGenderConfigurationCommandId, payRollGenderConfigurationUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertPayRollGenderConfigurationValidation(payRollGenderConfigurationUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            payRollGenderConfigurationUpsertInputModel.PayRollGenderConfigurationId = _payRollRepository.UpsertPayRollGenderConfiguration(payRollGenderConfigurationUpsertInputModel, loggedInContext, validationMessages);
            return payRollGenderConfigurationUpsertInputModel.PayRollGenderConfigurationId;
        }
        public List<PayRollGenderConfigurationSearchOutputModel> GetPayRollGenderConfigurations(PayRollGenderConfigurationSearchInputModel payRollGenderConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollGenderConfigurations", "PayRoll Service"));
            LoggingManager.Debug(payRollGenderConfigurationSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollGenderConfigurationsCommandId, payRollGenderConfigurationSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<PayRollGenderConfigurationSearchOutputModel> payRollGenderConfiguration = _payRollRepository.GetPayRollGenderConfigurations(payRollGenderConfigurationSearchInputModel, loggedInContext, validationMessages).ToList();
            return payRollGenderConfiguration;
        }

        public Guid? UpsertPayRollMaritalStatusConfiguration(PayRollMaritalStatusConfigurationUpsertInputModel payRollMaritalStatusConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(payRollMaritalStatusConfigurationUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertPayRollMaritalStatusConfigurationCommandId, payRollMaritalStatusConfigurationUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertPayRollMaritalStatusConfigurationValidation(payRollMaritalStatusConfigurationUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            payRollMaritalStatusConfigurationUpsertInputModel.PayRollMaritalStatusConfigurationId = _payRollRepository.UpsertPayRollMaritalStatusConfiguration(payRollMaritalStatusConfigurationUpsertInputModel, loggedInContext, validationMessages);
            return payRollMaritalStatusConfigurationUpsertInputModel.PayRollMaritalStatusConfigurationId;
        }
        public List<PayRollMaritalStatusConfigurationSearchOutputModel> GetPayRollMaritalStatusConfigurations(PayRollMaritalStatusConfigurationSearchInputModel payRollMaritalStatusConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollMaritalStatusConfigurations", "PayRoll Service"));
            LoggingManager.Debug(payRollMaritalStatusConfigurationSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollMaritalStatusConfigurationsCommandId, payRollMaritalStatusConfigurationSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<PayRollMaritalStatusConfigurationSearchOutputModel> payRollMaritalStatusConfiguration = _payRollRepository.GetPayRollMaritalStatusConfigurations(payRollMaritalStatusConfigurationSearchInputModel, loggedInContext, validationMessages).ToList();
            return payRollMaritalStatusConfiguration;
        }


        public List<PayRollTemplatesForEmployee> GetEmployeesPayTemplates(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeBonusList", "PayRollTemplate Service"));

            List<PayRollTemplatesForEmployee> employeesBonusDetails = _payRollRepository.GetEmployeesPayTemplates(loggedInContext, validationMessages).ToList();

            return employeesBonusDetails;
        }

        public List<EmployeePayRollConfiguration> GetEmployeePayrollConfiguration(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeBonusList", "PayRollTemplate Service"));

            List<EmployeePayRollConfiguration> employeesPayrollDetails = _payRollRepository.GetEmployeePayrollConfiguration(loggedInContext, validationMessages).ToList();

            return employeesPayrollDetails;
        }

        public Guid? UpsertEmployeePayrollConfiguration(EmployeePayRollConfiguration employeePayRollConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeBonusList", "PayRollTemplate Service"));

            var result = _payRollRepository.UpsertEmployeePayrollConfiguration(employeePayRollConfiguration, loggedInContext, validationMessages);

            return result;
        }
        public List<EmployeeResignationSearchOutputModel> GetEmployeesResignation(EmployeeResignationSearchInputModel employeeResignationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetResignationStatus", "PayRollComponent Service"));
            LoggingManager.Debug(employeeResignationSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetEmployeeResignationCommandId, employeeResignationSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<EmployeeResignationSearchOutputModel> resignationStatus = _payRollRepository.GetEmployeeResignation(employeeResignationSearchInputModel, loggedInContext, validationMessages).ToList();
            return resignationStatus;
        }

        public Guid? UpsertEmployeeResignation(EmployeeResignationSearchInputModel employeeResignationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRollComponent Service"));
            LoggingManager.Debug(employeeResignationSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeResignationCommandId, employeeResignationSearchInputModel, loggedInContext);
            List<EmployeeResigantionOutputModel> employeeResigantionOutputModel = _payRollRepository.UpsertEmployeeResignation(employeeResignationSearchInputModel, loggedInContext, validationMessages);
            foreach(var employeeResigantion in employeeResigantionOutputModel)
            {

                if (employeeResigantion.ReportingToId != null && (employeeResignationSearchInputModel.IsArchived == false || employeeResignationSearchInputModel.IsArchived == null) && employeeResigantion.ReportingToId != loggedInContext.LoggedInUserId)
                {
                    _notificationService.SendNotification((new NotificationModelForResignation(
                                                            string.Format(NotificationSummaryConstants.ResignationNotification,
                                                                employeeResigantion.AppliedUserName))), loggedInContext, employeeResigantion.ReportingToId);
                }
                else if (employeeResignationSearchInputModel.IsApproved == true && (employeeResignationSearchInputModel.IsArchived == false || employeeResignationSearchInputModel.IsArchived == null))
                {
                    _notificationService.SendNotification((new NotificationModelForResignationApproval(
                                                            string.Format(NotificationSummaryConstants.ResignationApprovalNotification, Convert.ToDateTime(employeeResignationSearchInputModel.ResignationDate.ToString()).ToString("dd-MMM-yyyy").ToString(),
                                                                employeeResigantion.ApprovedOrRejectedUserName))), loggedInContext, employeeResigantion.AppliedUserId);
                }
                else if (employeeResignationSearchInputModel.IsApproved == false && (employeeResignationSearchInputModel.IsArchived == false || employeeResignationSearchInputModel.IsArchived == null))
                {
                    _notificationService.SendNotification((new NotificationModelForResignationRejection(
                                                            string.Format(NotificationSummaryConstants.ResignationRejectionNotification, Convert.ToDateTime(employeeResignationSearchInputModel.ResignationDate.ToString()).ToString("dd-MMM-yyyy").ToString(),
                                                                employeeResigantion.ApprovedOrRejectedUserName))), loggedInContext, employeeResigantion.AppliedUserId);
                }
            }

            //deactivating the user(TimeZone of the user and at the 12:00 AM on the last day +1) when approved
            if (employeeResignationSearchInputModel.LastDate != null && employeeResignationSearchInputModel.IsApproved == true)
            {
                //if  lastdate is less than current date
                if (Convert.ToDateTime(employeeResignationSearchInputModel.LastDate) < DateTime.Now.Date)
                {
                    _userRepository.UpdateResignedUserStatus(loggedInContext, employeeResignationSearchInputModel.EmployeeId);
                }
                else
                {
                    DateTime exeDate = Convert.ToDateTime(employeeResignationSearchInputModel.LastDate);
                    TimeSpan ts = new TimeSpan(00, 00, 0);
                    exeDate = exeDate + ts;
                    int ustTime = -270;
                    int offSetMin = _userRepository.GetOffsetMinutes(employeeResignationSearchInputModel.EmployeeId);
                    if (offSetMin != 0)
                        exeDate = exeDate.AddDays(1).AddMinutes(ustTime).AddMinutes(offSetMin);
                    else
                        exeDate = exeDate.AddDays(1);
                    //exeDate = DateTime.Now.AddMinutes(2);
                    BackgroundJob.Schedule(() => _userRepository.UpdateResignedUserStatus(loggedInContext, employeeResignationSearchInputModel.EmployeeId), exeDate);
                }
            }
            return employeeResigantionOutputModel[0].EmployeeResignationId;

        }

        public List<PayRollStatus> GetPayrollStatusList(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayrollStatusList", "PayRollTemplate Service"));

            List<PayRollStatus> result = _payRollRepository.GetPayrollStatusList(null, loggedInContext, validationMessages).ToList();

            return result;
        }

        public Guid? UpsertPayrollStatus(PayRollStatus payRollStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeePayrollConfiguration", "PayRollTemplate Service"));

            var result = _payRollRepository.UpsertPayrollStatus(payRollStatus, loggedInContext, validationMessages);

            return result;
        }

        public Guid? UpsertTaxAllowance(TaxAllowanceUpsertInputModel taxAllowanceUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(taxAllowanceUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertTaxAllowanceCommandId, taxAllowanceUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertTaxAllowanceValidation(taxAllowanceUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            taxAllowanceUpsertInputModel.TaxAllowanceId = _payRollRepository.UpsertTaxAllowance(taxAllowanceUpsertInputModel, loggedInContext, validationMessages);
            return taxAllowanceUpsertInputModel.TaxAllowanceId;
        }
        public List<TaxAllowanceSearchOutputModel> GetTaxAllowances(TaxAllowanceSearchInputModel taxAllowanceSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTaxAllowances", "PayRoll Service"));
            LoggingManager.Debug(taxAllowanceSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetTaxAllowancesCommandId, taxAllowanceSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<TaxAllowanceSearchOutputModel> taxAllowance = _payRollRepository.GetTaxAllowances(taxAllowanceSearchInputModel, loggedInContext, validationMessages).ToList();
            return taxAllowance;
        }

        public List<TaxAllowanceTypeModel> GetTaxAllowanceTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTaxAllowanceTypes", "PayRoll Service"));
            LoggingManager.Debug(payRollTemplateSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollTemplatesCommandId, payRollTemplateSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<TaxAllowanceTypeModel> taxallowancetypes = _payRollRepository.GetTaxAllowanceTypes(payRollTemplateSearchInputModel, loggedInContext, validationMessages).ToList();
            return taxallowancetypes;
        }

        public List<PayrollRun> GetPayrollRunList(bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayrollRunList", "PayRollTemplate Service"));

            List<PayrollRun> payrollRunList = _payRollRepository.GetPayrollRunList(isArchived, loggedInContext, validationMessages).ToList();

            if (payrollRunList != null)
            {
                foreach (var item in payrollRunList)
                {
                    if (item.EmployeesList != null)
                    {
                        item.PayRollRunEmployees = JsonConvert.DeserializeObject<List<EmployeeListModel>>(item.EmployeesList);
                    }
                    else
                    {
                        item.PayRollRunEmployees = new List<EmployeeListModel>();
                    }
                }
            }

            //var workflowModel = new WorkFlowTriggerModel
            //{
            //    TriggerId =new Guid("4F2597FB-D583-49E2-A13A-809BC0F52420")
            //};

            //var workflowTrigger = _automatedWorkflowmanagementServices.GetWorkFlowTriggers(workflowModel, loggedInContext, validationMessages).FirstOrDefault();

            //if (workflowTrigger != null)
            //{
            //    try
            //    {
            //        XmlDocument document = new XmlDocument();

            //        document.LoadXml(workflowTrigger.WorkflowXml);

            //        XmlAttributeCollection xmlAttributeCollection = document.GetElementsByTagName("bpmn:definitions")[0]?.ChildNodes[0]
            //            ?.Attributes;

            //        if (xmlAttributeCollection != null)
            //        {
            //            var workflowName = xmlAttributeCollection?["id"]?.InnerText.Trim();
            //            List<UserTasksModel> userTasks =
            //                _customApplicationService.GetHumanTaskList(workflowName, loggedInContext, validationMessages);

            //            payrollRunList.ForEach(payrollRun =>
            //            {
            //                payrollRun.UserTasks = userTasks.Where(x =>
            //                        x.ProcessInstanceId == payrollRun.WorkflowProcessInstanceId.ToString())
            //                    .FirstOrDefault();
            //            });
            //        }
            //    }
            //    catch (Exception ex)
            //    {
            //        LoggingManager.Error(ValidationMessages.ExceptionUpsertEmployeeResignation, ex);
            //    }
            //}

            return payrollRunList;
        }

        public List<PayrollRunEmployee> GetPayrollRunemployeeList(Guid payrollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayrollRunList", "PayRollTemplate Service"));

            List<PayrollRunEmployee> result = _payRollRepository.GetPayrollRunEmployeeList(payrollRunId, loggedInContext, validationMessages).ToList();

            return result;
        }

        public List<EmployeePayslip> GetPaySlipDetails(Guid payrollRunId, Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayrollRunList", "PayRollTemplate Service"));

            List<EmployeePayslip> result = _payRollRepository.GetPaySlipDetails(payrollRunId, employeeId, loggedInContext, validationMessages).ToList();

            return result;
        }


        public void SendEmailWithPayslip(Guid payrollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var payrollRunEmployees = GetPayrollRunemployeeList(payrollRunId, loggedInContext, validationMessages).Where(x => x.IsHold != true).ToList();
            var employeesList = _payRollRepository.GetEmployeesListByIds(payrollRunEmployees.Where(x => x.IsHold != true).Select(x => x.EmployeeId ?? Guid.NewGuid()).ToList(), loggedInContext, validationMessages);

            var payrolldetails = payrollRunEmployees.FirstOrDefault();

            PdfGenerationOutputModel exceldata = GetExcelDataOfEmployees(loggedInContext, payrollRunEmployees);

            BackgroundJob.Enqueue(() => SendPayRollPaidAlertEmailsToAdmins(loggedInContext, exceldata, payrolldetails, validationMessages));

            foreach (var payrollRunEmployee in payrollRunEmployees.Where(x => x.IsHold != true).ToList())
            {
                try
                {
                    var employeeDetails = employeesList.FirstOrDefault(x => x.EmployeeId == payrollRunEmployee.EmployeeId);
                    var allEmployeesPayslips = GetPaySlipDetails(payrollRunEmployee.PayrollRunId ?? Guid.NewGuid(), payrollRunEmployee.EmployeeId ?? Guid.NewGuid(), loggedInContext, validationMessages);

                    if (allEmployeesPayslips.Any())
                    {
                        var payslipDetails = allEmployeesPayslips.First();
                        PdfGenerationOutputModel pdfData = CreatePdfOfPayslip(allEmployeesPayslips, loggedInContext);

                        BackgroundJob.Enqueue(() => SendPaySlipToEmployee(loggedInContext, employeeDetails, pdfData,
                        payslipDetails, validationMessages));

                        payrollRunEmployee.IsPayslipReleased = true;

                        UpdatePayrollRunEmployeeStatus(payrollRunEmployee, loggedInContext, validationMessages);

                    }
                }
                catch (Exception ex)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendEmailWithPayslip", "PayRollService ", ex.Message), ex);

                }

            }





        }

        public PdfGenerationOutputModel GetExcelDataOfEmployees(LoggedInContext loggedInContext, List<PayrollRunEmployee> payrollRunEmployees)
        {
            var path = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates/PayRollEmailExcelTemplate.xlsx");

            var path1 = HostingEnvironment.MapPath(@"~/Resources/ExcelTemplates");
            var guid = Guid.NewGuid();
            if (path1 != null)
            {
                var pdfOutputModel = new PdfGenerationOutputModel();
                var destinationPath = Path.Combine(path1, guid.ToString());
                string docName = Path.Combine(destinationPath, "PayRollEmailExcelTemplate.xlsx");
                if (!Directory.Exists(destinationPath))
                {
                    Directory.CreateDirectory(destinationPath);

                    if (path != null) System.IO.File.Copy(path, docName, true);

                    LoggingManager.Info("Created a directory to save temp file");
                }


                using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                {

                    uint rowIndex = 1;


                    foreach (var payroll in payrollRunEmployees)
                    {

                        AddUpdateCellValue(spreadSheet, "PayRollEmailEmployeesList", rowIndex, "A", payroll.EmployeeName);
                        AddUpdateCellValue(spreadSheet, "PayRollEmailEmployeesList", rowIndex, "B", payroll.ModifiedPreviousMonthPaidAmount);
                        AddUpdateCellValue(spreadSheet, "PayRollEmailEmployeesList", rowIndex, "C", payroll.ModifiedActualPaidAmount);
                        AddUpdateCellValue(spreadSheet, "PayRollEmailEmployeesList", rowIndex, "D", payroll.ModifiedLoanAmountRemaining);
                        AddUpdateCellValue(spreadSheet, "PayRollEmailEmployeesList", rowIndex, "E", payroll.TotalWorkingDays.ToString());
                        AddUpdateCellValue(spreadSheet, "PayRollEmailEmployeesList", rowIndex, "F", payroll.EffectiveWorkingDays.ToString());
                        AddUpdateCellValue(spreadSheet, "PayRollEmailEmployeesList", rowIndex, "G", payroll.LossOfPay.ToString());

                        rowIndex++;
                    }

                    spreadSheet.Close();

                    var inputBytes = System.IO.File.ReadAllBytes(docName);


                    var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                    {
                        MemoryStream = System.IO.File.ReadAllBytes(docName),
                        FileName = "PayRollEmailExcelTemplate" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                        ContentType = "application/xlsx",
                        LoggedInUserId = loggedInContext.LoggedInUserId
                    });

                    pdfOutputModel = new PdfGenerationOutputModel()
                    {
                        ByteStream = inputBytes,
                        FileName = "PayRollEmailExcelTemplate" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx"
                    };

                }

                if (Directory.Exists(destinationPath))
                {
                    System.IO.File.Delete(docName);
                    Directory.Delete(destinationPath);



                    LoggingManager.Info("Deleting the temp folder");
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenerateWorkItemTemplate", "UserStoryApiController"));
                return pdfOutputModel;
            }
            return null;
        }

        public void AddUpdateCellValue(SpreadsheetDocument spreadSheet, string sheetname, uint rowIndex, string columnName, string text)
        {
            // Opening document for editing            
            WorksheetPart worksheetPart =
             RetrieveSheetPartByName(spreadSheet, sheetname);
            if (worksheetPart != null)
            {
                Cell cell = InsertCellInSheet(columnName, (rowIndex + 1), worksheetPart);
                cell.CellValue = new CellValue(text);


                //cell datatype     
                cell.DataType = new EnumValue<CellValues>(CellValues.String);
                // Save the worksheet.            
                worksheetPart.Worksheet.Save();
            }
        }


        public void AddUpdateTemplateCellValue(SpreadsheetDocument spreadSheet, string sheetname, uint rowIndex, string columnName, string text)
        {
            // Opening document for editing            
            WorksheetPart worksheetPart =
             RetrieveSheetPartByName(spreadSheet, sheetname);
            if (worksheetPart != null)
            {
                Cell cell = InsertTemplateCellInSheet(columnName, (rowIndex + 1), worksheetPart);
                cell.CellValue = new CellValue(text);

                CellFormat cellFormat = cell.StyleIndex != null ? GetCellFormat(spreadSheet.WorkbookPart, cell.StyleIndex).CloneNode(true) as CellFormat : new CellFormat();
                cellFormat.BorderId = SetBorderStyle(spreadSheet.WorkbookPart, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, insideBorder, BorderStyleValues.Thin, border, BorderStyleValues.Thin, insideBorder);
                cellFormat.ApplyBorder = true;
                cell.StyleIndex = InsertCellFormat(spreadSheet.WorkbookPart, cellFormat);

                //cell datatype     
                cell.DataType = new EnumValue<CellValues>(CellValues.String);
                // Save the worksheet.            
                worksheetPart.Worksheet.Save();
            }
        }

        public Cell InsertTemplateCellInSheet(string columnName, uint rowIndex, WorksheetPart worksheetPart)
        {
            Worksheet worksheet = worksheetPart.Worksheet;
            SheetData sheetData = worksheet.GetFirstChild<SheetData>();
            string cellReference = columnName + rowIndex;
            Row row;
            //check whether row exist or not            
            //if row exist            
            if (sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).Count() != 0)
                row = sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).First();
            //if row does not exist then it will create new row            
            else
            {
                row = new Row()
                {
                    RowIndex = rowIndex
                };
                sheetData.Append(row);
            }
            //check whether cell exist or not            
            //if cell exist            
            if (row.Elements<Cell>().Where(c => c.CellReference.Value == columnName + rowIndex).Count() > 0)
                return row.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).First();
            //if cell does not exist            
            else
            {
                Cell refCell = null;
                foreach (Cell cell in row.Elements<Cell>())
                {
                    if (string.Compare(cell.CellReference.Value, cellReference, true) > 0)
                    {
                        refCell = cell;
                        break;
                    }
                }
                Cell newCell = new Cell()
                {
                    CellReference = cellReference
                };
                if (cellReference.Contains("AA"))
                {
                    row.InsertAt(newCell, 26);
                }
                else if (cellReference.Contains("AB"))
                {
                    row.InsertAt(newCell, 27);
                }
                else if (cellReference.Contains("AC"))
                {
                    row.InsertAt(newCell, 28);
                }
                else if (cellReference.Contains("AD"))
                {
                    row.InsertAt(newCell, 29);
                }
                else if (cellReference.Contains("AE"))
                {
                    row.InsertAt(newCell, 30);
                }
                else if (cellReference.Contains("AF"))
                {
                    row.InsertAt(newCell, 31);
                }
                else if (cellReference.Contains("AG"))
                {
                    row.InsertAt(newCell, 32);
                }
                else if (cellReference.Contains("AH"))
                {
                    row.InsertAt(newCell, 33);
                }
                else if (cellReference.Contains("AI"))
                {
                    row.InsertAt(newCell, 34);
                }
                else row.InsertBefore(newCell, refCell);
                worksheet.Save();
                return newCell;
            }
        }

        private static uint InsertCellFormat(WorkbookPart workbookPart, CellFormat cellFormat)
        {
            CellFormats cellFormats = workbookPart.WorkbookStylesPart.Stylesheet.Elements<CellFormats>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (cellFormat != null) cellFormats.Append(cellFormat);
            return cellFormats.Count++;
        }

        private static uint SetBorderStyle(WorkbookPart workbookPart, BorderStyleValues leftBorder, HexBinaryValue leftBorderColor, BorderStyleValues rightBorder, HexBinaryValue RightBorderColor,
              BorderStyleValues topBorder, HexBinaryValue topBorderColor, BorderStyleValues bottomBorder, HexBinaryValue bottomBorderColor)
        {
            Border border2 = new Border();
            HexBinaryValue borderColor = border;

            LeftBorder leftBorder2 = new LeftBorder() { Style = leftBorder };
            Color color1 = new Color() { Rgb = leftBorderColor };
            leftBorder2.Append(color1);

            RightBorder rightBorder2 = new RightBorder() { Style = rightBorder };
            Color color2 = new Color() { Rgb = RightBorderColor };
            rightBorder2.Append(color2);

            TopBorder topBorder2 = new TopBorder() { Style = topBorder };
            Color color3 = new Color() { Rgb = topBorderColor };
            topBorder2.Append(color3);

            BottomBorder bottomBorder2 = new BottomBorder() { Style = bottomBorder };
            Color color4 = new Color() { Rgb = bottomBorderColor };
            bottomBorder2.Append(color4);

            border2.Append(leftBorder2);
            border2.Append(rightBorder2);
            border2.Append(topBorder2);
            border2.Append(bottomBorder2);


            Borders boarders = workbookPart.WorkbookStylesPart.Stylesheet.Elements<Borders>().First();
            boarders.Append(border2);

            return boarders.Count++;
        }

        private static CellFormat GetCellFormat(WorkbookPart workbookPart, uint styleIndex)
        {
            return workbookPart.WorkbookStylesPart.Stylesheet.Elements<CellFormats>().First().Elements<CellFormat>().ElementAt((int)styleIndex);
        }

        //retrieve sheetpart            
        public WorksheetPart RetrieveSheetPartByName(SpreadsheetDocument document, string sheetName)
        {
            IEnumerable<Sheet> sheets =
             document.WorkbookPart.Workbook.GetFirstChild<Sheets>().
            Elements<Sheet>().Where(s => s.Name == sheetName);
            if (sheets.Count() == 0)
                return null;

            string relationshipId = sheets.First().Id.Value;
            WorksheetPart worksheetPart = (WorksheetPart)
            document.WorkbookPart.GetPartById(relationshipId);
            return worksheetPart;
        }

        //insert cell in sheet based on column and row index            
        public Cell InsertCellInSheet(string columnName, uint rowIndex, WorksheetPart worksheetPart)
        {
            Worksheet worksheet = worksheetPart.Worksheet;
            SheetData sheetData = worksheet.GetFirstChild<SheetData>();
            string cellReference = columnName + rowIndex;
            Row row;
            //check whether row exist or not            
            //if row exist            
            if (sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).Count() != 0)
                row = sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).First();
            //if row does not exist then it will create new row            
            else
            {
                row = new Row()
                {
                    RowIndex = rowIndex
                };
                sheetData.Append(row);
            }
            //check whether cell exist or not            
            //if cell exist            
            if (row.Elements<Cell>().Where(c => c.CellReference.Value == columnName + rowIndex).Count() > 0)
                return row.Elements<Cell>().Where(c => c.CellReference.Value == cellReference).First();
            //if cell does not exist            
            else
            {
                Cell refCell = null;
                foreach (Cell cell in row.Elements<Cell>())
                {
                    if (string.Compare(cell.CellReference.Value, cellReference, true) > 0)
                    {
                        refCell = cell;
                        break;
                    }
                }
                Cell newCell = new Cell()
                {
                    CellReference = cellReference
                };
                row.InsertBefore(newCell, refCell);
                worksheet.Save();
                return newCell;
            }
        }

        public void SendPayRollPaidAlertEmailsToAdmins(LoggedInContext loggedInContext, PdfGenerationOutputModel pdfData, PayrollRunEmployee payrolldetails, List<ValidationMessage> validationMessages)
        {
            CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

            var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();

            companySettingsSearchInputModel.Key = "AdminMails";

            var companySettings = _masterManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages);

            var payslipEmailHtml = "<h4> Dear Admin ,</h4> </br> Payment is done for the following employees which are in the attached file";
            MemoryStream ms = new MemoryStream(pdfData.ByteStream);

            var contentType = "application/xlsx";
            Attachment attach = new Attachment(ms, contentType);
            attach.ContentDisposition.FileName = pdfData.FileName;
            Attachment[] attachments = new Attachment[1];
            attachments[0] = attach;

            List<Stream> fileStream = new List<Stream>();

            fileStream.Add(ms);

            if (companySettings[0].Value != null)
            {
                var toMails = companySettings[0].Value.Split(',');
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = toMails,
                    HtmlContent = payslipEmailHtml,
                    Subject = "Payslip released file for the month " + payrolldetails.PayrollStartDate?.ToString("MMM, yyyy"),
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = fileStream,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
            }
        }

        public void SendPaySlipToEmployee(LoggedInContext loggedInContext, EmployeeOutputModel employeeDetails, PdfGenerationOutputModel pdfData, EmployeePayslip payslipDetails, List<ValidationMessage> validationMessages)
        {
            CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

            var payslipEmailHtml = _goalrepository.GetHtmlTemplateByName("PayslipEmailTemplate", loggedInContext.CompanyGuid);
            MemoryStream ms = new MemoryStream(pdfData.ByteStream);
            string[] parts = pdfData.BlobUrl.Split('/');
            System.Net.Mime.ContentType contentType = new System.Net.Mime.ContentType(System.Net.Mime.MediaTypeNames.Application.Pdf);
            Attachment attach = new Attachment(ms, contentType);
            attach.ContentDisposition.FileName = parts.Last();
            Attachment[] attachments = new Attachment[1];
            attachments[0] = attach;

            var emailHtml = payslipEmailHtml
                .Replace("##EmployeeName##", employeeDetails.SurName + "  " + employeeDetails.FirstName)
                .Replace("##payslipMonth##", payslipDetails.PayrollMonth);

            List<Stream> fileStream = new List<Stream>();

            fileStream.Add(ms);
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpServer = smtpDetails?.SmtpServer,
                SmtpServerPort = smtpDetails?.SmtpServerPort,
                SmtpMail = smtpDetails?.SmtpMail,
                SmtpPassword = smtpDetails?.SmtpPassword,
                ToAddresses = new[] { employeeDetails.Email },
                HtmlContent = emailHtml,
                Subject = "Payslip for " + payslipDetails.PayrollMonth,
                CCMails = null,
                BCCMails = null,
                MailAttachments = fileStream,
                IsPdf = true
            };
            _emailService.SendMail(loggedInContext, emailModel);
        }

        public PdfGenerationOutputModel CreatePdfOfPayslip(List<EmployeePayslip> allEmployeesPayslips, LoggedInContext loggedInContext)
        {
            CompanyThemeModel companyTheme = _companyStructureService.GetCompanyTheme(loggedInContext?.LoggedInUserId);
            var payslipDetails = allEmployeesPayslips.First();
            payslipDetails.CompanyLogo = companyTheme.CompanyMainLogo != null ? companyTheme.CompanyMainLogo : "http://todaywalkins.com/Comp_images/Snovasys.png";
            payslipDetails.PayslipLogo = companyTheme.PayslipLogo != null ? companyTheme.PayslipLogo : "http://todaywalkins.com/Comp_images/Snovasys.png";
            var fullTotalEarnings = payslipDetails.TotalEarningsToDate;
            var totalEarnings = payslipDetails.ActualEarningsToDate;
            var totalDeductions = payslipDetails.ActualDeductionsToDate;
            var totalActualAmount = payslipDetails.ActualNetPayAmount;

            var payslipDetailsHtml = payslipDetails.IncludeYtd ? _goalrepository.GetHtmlTemplateByName("PayslipDetailsTemplate", loggedInContext.CompanyGuid) : _goalrepository.GetHtmlTemplateByName("PayslipDetailsTemplateWithOutYTD", loggedInContext.CompanyGuid);
            var payslipComponentHtml = payslipDetails.IncludeYtd ? _goalrepository.GetHtmlTemplateByName("PayslipComponentTemplate", loggedInContext.CompanyGuid) : _goalrepository.GetHtmlTemplateByName("PayslipComponentTemplateWithOutYTD", loggedInContext.CompanyGuid);
            var payslipDeductionsComponentHtml = payslipDetails.IncludeYtd ? _goalrepository.GetHtmlTemplateByName("PayslipDeductionsComponentTemplate", loggedInContext.CompanyGuid) : _goalrepository.GetHtmlTemplateByName("PayslipDeductionsComponentTemplateWithOutYTD", loggedInContext.CompanyGuid);

            var componentHtml = string.Empty;

            foreach (var employeePayslip in allEmployeesPayslips)
            {
                string tempHtml;
                if (employeePayslip.IsDeduction == true)
                {
                    if (employeePayslip.IncludeYtd == true)
                    {
                        tempHtml = payslipDeductionsComponentHtml
                          .Replace("##componentName##", employeePayslip.ComponentName)
                          .Replace("##full##", string.IsNullOrEmpty(employeePayslip.Full) ? employeePayslip.Full : employeePayslip.Full.ToString())
                          .Replace("##actual##", string.IsNullOrEmpty(employeePayslip.Actual) ? employeePayslip.Actual : employeePayslip.Actual.ToString());
                    }
                    else
                    {
                        tempHtml = payslipDeductionsComponentHtml
                          .Replace("##componentName##", employeePayslip.ComponentName)
                          .Replace("##actual##", string.IsNullOrEmpty(employeePayslip.Actual) ? employeePayslip.Actual : employeePayslip.Actual.ToString());
                    }

                }
                else
                {
                    if (employeePayslip.IncludeYtd == true)
                    {
                        tempHtml = payslipComponentHtml
                          .Replace("##componentName##", employeePayslip.ComponentName)
                          .Replace("##full##", string.IsNullOrEmpty(employeePayslip.Full) ? employeePayslip.Full : employeePayslip.Full.ToString())
                          .Replace("##actual##", string.IsNullOrEmpty(employeePayslip.Actual) ? employeePayslip.Actual : employeePayslip.Actual.ToString());
                    }
                    else
                    {
                        tempHtml = payslipComponentHtml
                          .Replace("##componentName##", employeePayslip.ComponentName)
                          .Replace("##actual##", string.IsNullOrEmpty(employeePayslip.Actual) ? employeePayslip.Actual : employeePayslip.Actual.ToString());
                    }

                }

                componentHtml = componentHtml + tempHtml;
            }


            var formattedHtml = payslipDetailsHtml.Replace("##companyName", payslipDetails.CompanyName)
                .Replace("##headOfficeAddress", payslipDetails.HeadOfficeAddress)
                .Replace("###CompanyLogo##", payslipDetails.PayslipLogo)
                .Replace("##companySiteAddress", payslipDetails.CompanyBranches)
                .Replace("##headOfficeAddress", payslipDetails.HeadOfficeAddress)
                .Replace("##payrollMonth", payslipDetails.PayrollMonth)
                .Replace("##employeeName", payslipDetails.EmployeeName)
                .Replace("##bankName", payslipDetails.BankName)
                .Replace("##dateOfJoining", payslipDetails.DateOfJoining.ToString("dd/MM/yyyy"))
                .Replace("##bankAccountNumber", payslipDetails.BankAccountNumber)
                .Replace("##designation", payslipDetails.Designation)
                .Replace("##pfNumber", payslipDetails.PfNumber)
                .Replace("##department", payslipDetails.Department)
                .Replace("##uan", payslipDetails.Uan)
                .Replace("##location", payslipDetails.Location)
                .Replace("##esiNumber", payslipDetails.EsiNumber)
                .Replace("##effectiveWorkingDays", payslipDetails.EffectiveWorkingDays?.ToString())
                .Replace("##panNumber", payslipDetails.PanNumber)
                .Replace("##daysInMonth", payslipDetails.DaysInMonth?.ToString())
                .Replace("##lop", payslipDetails.Lop?.ToString())
                .Replace("##payrollComponent", Regex.Replace(componentHtml, " {2,}", " "))
                .Replace("##fullTotalEarnings", fullTotalEarnings?.ToString())
                .Replace("##totalEarnings", totalEarnings?.ToString())
                .Replace("##totalDeduction", totalDeductions?.ToString())
                .Replace("##totalActualAmount", totalActualAmount?.ToString())
                .Replace("##currencyFormat", payslipDetails.CurrencyCode)
                .Replace("##actualNetPayAmountInWords", payslipDetails.ActualNetPayAmountInWords)
                .Replace("##ytdEarningsToDate", payslipDetails.TotalEarningsToDate)
                .Replace("##netPayAmount", payslipDetails.NetPayAmount)
                .Replace("##ytdDeductionsToDate", payslipDetails.TotalDeductionsToDate?.ToString());

            string fileName = "Payslip_" + payslipDetails.PayrollMonth.Replace(" ", String.Empty) + ".pdf";

            formattedHtml = Regex.Replace(formattedHtml, " {2,}", " ");

            byte[] inputBytes = PdfSharpConvert(formattedHtml);

            var blobUrl = _fileStoreService.PostFile(new FilePostInputModel
            {
                MemoryStream = inputBytes,
                FileName = fileName,
                LoggedInUserId = loggedInContext.LoggedInUserId
            });
            var pdfOutputModel = new PdfGenerationOutputModel()
            {
                ByteStream = inputBytes,
                BlobUrl = blobUrl,
                FileName = fileName
            };
            return pdfOutputModel;
        }

        public Byte[] PdfSharpConvert(String html)
        {
            Byte[] res;
            using (MemoryStream ms = new MemoryStream())
            {
                var pdf = PdfGenerator.GeneratePdf(html, PdfSharp.PageSize.A4);
                pdf.Save(ms);
                res = ms.ToArray();
            }
            return res;
        }

        public void SendEmail(EmployeePayslip payslipDetails, EmployeeOutputModel employeeDetails, PdfGenerationOutputModel pdfData, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var payslipEmailHtml = _goalrepository.GetHtmlTemplateByName("PayslipEmailTemplate", loggedInContext.CompanyGuid);
            MemoryStream ms = new MemoryStream(pdfData.ByteStream);
            string[] parts = pdfData.BlobUrl.Split('/');
            System.Net.Mime.ContentType contentType = new System.Net.Mime.ContentType(System.Net.Mime.MediaTypeNames.Application.Pdf);
            Attachment attach = new Attachment(ms, contentType);
            attach.ContentDisposition.FileName = parts.Last();
            Attachment[] attachments = new Attachment[1];
            attachments[0] = attach;
            List<Stream> fileStream = new List<Stream>();

            fileStream.Add(ms);
            var emailHtml = payslipEmailHtml
                .Replace("##EmployeeName##", employeeDetails.SurName + "  " + employeeDetails.FirstName)
                .Replace("##payslipMonth##", payslipDetails.PayrollMonth);
            CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);
            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);
            var emails = new List<string>();
            emails.Add(employeeDetails.Email);
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpServer = smtpDetails?.SmtpServer,
                SmtpServerPort = smtpDetails?.SmtpServerPort,
                SmtpMail = smtpDetails?.SmtpMail,
                SmtpPassword = smtpDetails?.SmtpPassword,
                ToAddresses = emails.ToArray(),
                HtmlContent = emailHtml,
                Subject = "Payslip for " + payslipDetails.PayrollMonth,
                CCMails = null,
                BCCMails = null,
                MailAttachments = fileStream,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
            // _communicationService.SendMail(ConfigurationManager.AppSettings["FromMailAddress"], employeeDetails.Email, null, "Payslip for " + payslipDetails.PayrollMonth, emailHtml, attachments);
        }

        public PdfGenerationOutputModel DownloadPaySlipPdf(Guid payrollRunId, Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var payslipDetails = GetPaySlipDetails(payrollRunId, employeeId, loggedInContext, validationMessages);
            if (payslipDetails.Any())
            {
                var pdfData = CreatePdfOfPayslip(payslipDetails, loggedInContext);
                return pdfData;
            }

            return new PdfGenerationOutputModel();

        }

        public PayRollMonthlyDetailsModel GetPayRollMonthlyDetails(string dateOfMonth, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            var PayRollMonthlyDetails = _payRollRepository.GetPayRollMonthlyDetails(dateOfMonth, loggedInContext, validationMessages);

            return PayRollMonthlyDetails;

        }

        public List<PayRollRunTemplate> GetPayRollRunTemplates(Guid payrollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayrollRunList", "PayRollTemplate Service"));

            List<PayRollRunTemplate> result = _payRollRepository.GetPayRollRunTemplates(payrollRunId, loggedInContext, validationMessages).ToList();

            return result;
        }

        public string RunPaymentForPayRollRun(Guid payrollRunId, string TemplateType, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RunPaymentForPayRollRun", "PayRollTemplate Service"));

            var result = DownloadPayRollRunTemplate(payrollRunId, TemplateType, loggedInContext, validationMessages);

            if (result != null)
            {
                _payRollRepository.UpdatePayrollRunBankPointer(payrollRunId, result, loggedInContext, validationMessages);
            }


            return result;
        }
        public string DownloadPayRollRunTemplate(Guid payrollRunId, string TemplateType, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            List<PayRollRunTemplate> payRollRunTemplates = GetPayRollRunTemplates(payrollRunId, loggedInContext, validationMessages);

            if (payRollRunTemplates.Any())
            {
                var path = string.Empty;

                var guid = Guid.NewGuid();

                string blobUrl;

                var path1 = HostingEnvironment.MapPath(@"~\Resources\ExcelTemplates");

                //if (TemplateType == "axis")
                //{
                //    path = HostingEnvironment.MapPath(@"~\Resources\ExcelTemplates\AxisBankTemplate.xlsx");
                //}
                //else
                //{
                //    path = HostingEnvironment.MapPath(@"~\Resources\ExcelTemplates\NonAxisBankTemplate.xlsx");
                //}

                if (path1 != null && TemplateType == "axis")
                {
                    path = HostingEnvironment.MapPath(@"~\Resources\ExcelTemplates\AxisBankTemplate.xlsx");
                    var pdfOutputModel = new PdfGenerationOutputModel();
                    var destinationPath = Path.Combine(path1, guid.ToString());
                    string docName = Path.Combine(destinationPath, "AxisBankTemplate.xlsx");
                    if (!Directory.Exists(destinationPath))
                    {
                        Directory.CreateDirectory(destinationPath);

                        if (path != null)
                        {
                            System.IO.File.Copy(path, docName, true);
                        }

                        LoggingManager.Info("Created a directory to save temp file");
                    }

                    string[] columnIndex = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" };

                    using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                    {

                        uint rowIndex = 1;

                        foreach (var payroll in payRollRunTemplates.Where(x => x.IsProcessedToPay == true).ToList())
                        {
                            AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "A", "Axis Bank");
                            AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "B", payroll.BeneficiaryName);
                            AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "C", payroll.BeneficiaryAccountNumber);
                            AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "D", payroll.Amount.ToString());
                            AddUpdateCellValue(spreadSheet, "Sheet1", rowIndex, "E", payroll.RemarksForBeneficiary);
                            rowIndex++;
                        }

                        spreadSheet.Close();

                        blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                        {
                            MemoryStream = System.IO.File.ReadAllBytes(docName),
                            FileName = "Payment" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                            ContentType = "application/xlsx",
                            LoggedInUserId = loggedInContext.LoggedInUserId
                        });

                        UpdatePayrollRunEmployeePaymentStatus(payRollRunTemplates, loggedInContext, validationMessages);

                    }

                    if (Directory.Exists(destinationPath))
                    {
                        System.IO.File.Delete(docName);
                        Directory.Delete(destinationPath);

                        LoggingManager.Info("Deleting the temp folder");
                    }
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadUserstories", "UserStoryApiController"));
                    return blobUrl;
                }

                else if (TemplateType == "icici" || TemplateType == "nonIcici")
                {
                    if(TemplateType == "icici")
                    {
                        path = HostingEnvironment.MapPath(@"~\Resources\ExcelTemplates\PaymentTemplate.xlsx");
                    }
                    else
                    {
                        path = HostingEnvironment.MapPath(@"~\Resources\ExcelTemplates\OtherBankPaymentTemplate.xlsx");
                    }

                    if (path1 != null)
                    {
                        var destinationPath = Path.Combine(path1, guid.ToString());
                        string docName = Path.Combine(destinationPath, "Payment.xlsx");
                        if (!Directory.Exists(destinationPath))
                        {
                            Directory.CreateDirectory(destinationPath);

                            if (path != null) System.IO.File.Copy(path, docName, true);

                            LoggingManager.Info("Created a directory to save temp file");
                        }


                        using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                        {
                            WorksheetPart worksheetPartFirst;
                            if (TemplateType == "icici")
                            {
                                worksheetPartFirst = GetWorksheetPartByName(spreadSheet, "Converter", "Converter");
                            }
                            else
                            {
                                worksheetPartFirst = GetWorksheetPartByName(spreadSheet, "Sheet1", "Sheet1");
                            }

                            SheetData sheetData = worksheetPartFirst.Worksheet.GetFirstChild<SheetData>();

                            uint rowIndex = 5;

                            Row row1 = sheetData.Elements<Row>().Where(r => r.RowIndex == 1).First();
                            Row row2 = sheetData.Elements<Row>().Where(r => r.RowIndex == 2).First();
                            row1.Elements<Cell>().Where(x => x.CellReference == "E" + 1).First().CellValue = new CellValue(payRollRunTemplates.FirstOrDefault()?.TraceAccountNumber);
                            row1.Elements<Cell>().Where(x => x.CellReference == "G" + 1).First().CellValue = new CellValue(payRollRunTemplates.FirstOrDefault()?.FileReference);
                            row1.Elements<Cell>().Where(x => x.CellReference == "E" + 1).First().DataType = new EnumValue<CellValues>(CellValues.Number);
                            row1.Elements<Cell>().Where(x => x.CellReference == "G" + 1).First().DataType = new EnumValue<CellValues>(CellValues.String);
                            foreach (var payroll in payRollRunTemplates.Where(x => x.IsProcessedToPay == true).ToList())
                            {
                                payroll.DebitAccountNumber = payroll.DebitAccountNumber?.Replace(" ", string.Empty);
                                payroll.BeneficiaryAccountNumber = payroll.BeneficiaryAccountNumber?.Replace(" ", string.Empty);

                                Row row;
                                if (sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).Count() != 0)
                                {
                                    row = sheetData.Elements<Row>().Where(r => r.RowIndex == rowIndex).First();
                                }
                                else
                                {
                                    row = new Row() { RowIndex = rowIndex };
                                    sheetData.Append(row);
                                }

                                row.Elements<Cell>().Where(x => x.CellReference == "A" + rowIndex).First().CellValue = new CellValue(payroll.TransactionType);
                                row.Elements<Cell>().Where(x => x.CellReference == "B" + rowIndex).First().CellValue = new CellValue(payroll.DebitAccountNumber);
                                if (payroll.TransactionType.ToUpper() != "WIB")
                                {
                                    row.Elements<Cell>().Where(x => x.CellReference == "C" + rowIndex).First().CellValue = new CellValue(payroll.DebitAccountIfsc);
                                }
                                row.Elements<Cell>().Where(x => x.CellReference == "D" + rowIndex).First().CellValue = new CellValue(payroll.BeneficiaryAccountNumber);
                                row.Elements<Cell>().Where(x => x.CellReference == "E" + rowIndex).First().CellValue = new CellValue(payroll.BeneficiaryName);
                                row.Elements<Cell>().Where(x => x.CellReference == "F" + rowIndex).First().CellValue = new CellValue(payroll.Amount.ToString());
                                row.Elements<Cell>().Where(x => x.CellReference == "F" + rowIndex).First().DataType = new EnumValue<CellValues>(CellValues.Number);
                                row.Elements<Cell>().Where(x => x.CellReference == "G" + rowIndex).First().CellValue = new CellValue(payroll.RemarksForClient);
                                row.Elements<Cell>().Where(x => x.CellReference == "H" + rowIndex).First().CellValue = new CellValue(payroll.RemarksForBeneficiary);
                                //row.Elements<Cell>().Where(x => x.CellReference == "I" + rowIndex).First().CellFormula.Reference = "SUM(A1:A3)";
                                //row.Elements<Cell>().Where(x => x.CellReference == "J" + rowIndex).First().CellFormula.Reference = "=IF(AND(ISBLANK(A" + rowIndex + "),ISBLANK(B" + rowIndex + "),ISBLANK(G" + rowIndex + "),ISBLANK(C" + rowIndex + "),ISBLANK(D" + rowIndex + "),ISBLANK(E" + rowIndex + "),ISBLANK(F" + rowIndex + ")),'',IF(AND(OR(A" + rowIndex + "!='WIB',A" + rowIndex + "!='NFT',A" + rowIndex + "!='RTG',A" + rowIndex + "!='IFC'),LEN(B" + rowIndex + "!)=12,ISNUMBER(VALUE(B" + rowIndex + "!)),IF(A" + rowIndex + "!='WIB',ISBLANK(C" + rowIndex + "!),AND(LEN(C" + rowIndex + "!)=11,MID(C" + rowIndex + "!,5,1)='0')),IF(A" + rowIndex + "!='WIB',AND(LEN(D" + rowIndex + "!)=12,ISNUMBER(VALUE(D" + rowIndex + "!))),LEN(D" + rowIndex + "!)<35),IF(ISNUMBER(F" + rowIndex + "!),LEN(ROUND(F" + rowIndex + "!,2))<16),LEN(G" + rowIndex + "!)<31,IF(A" + rowIndex + "!='WIB',OR(COUNTA(A" + rowIndex + ":D" + rowIndex + "!)=6,COUNTA(A" + rowIndex + ":D" + rowIndex + "!)=7),COUNTA(A" + rowIndex + ":D" + rowIndex + "!)=7)),IF(A" + rowIndex + "!='WIB','APW','APO')&'|'&A" + rowIndex + "!&'|'&ROUND(F" + rowIndex + "!,2)&'|INR|'&B" + rowIndex + "!&'|0011|'&IF(A" + rowIndex + "!='WIB',''ICIC0000011'',C" + rowIndex + "!)&'|'&D" + rowIndex + "!&'|0011|'&E" + rowIndex + "!&'|'&G" + rowIndex + "!&'|'&H" + rowIndex + "!&'^','Please correct data'))";

                                rowIndex++;
                            }

                            //save document on the end
                            worksheetPartFirst.Worksheet.Save();
                            spreadSheet.WorkbookPart.Workbook.Save();

                            spreadSheet.Close();
                            blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                            {
                                MemoryStream = System.IO.File.ReadAllBytes(docName),
                                FileName = "Payment" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                                ContentType = "application/xlsx",
                                LoggedInUserId = loggedInContext.LoggedInUserId
                            });

                            UpdatePayrollRunEmployeePaymentStatus(payRollRunTemplates, loggedInContext, validationMessages);


                        }

                        if (Directory.Exists(destinationPath))
                        {
                            System.IO.File.Delete(docName);
                            Directory.Delete(destinationPath);



                            LoggingManager.Info("Deleting the temp folder");
                        }
                        return blobUrl;
                    }
                    //if (payRollRunTemplates.FirstOrDefault()?.BankName == "ICICI")
                    //{
                    //    path = HostingEnvironment.MapPath(@"~\Resources\ExcelTemplates\PaymentTemplate.xlsx");
                    //}
                    //else
                    //{
                    //    path = HostingEnvironment.MapPath(@"~\Resources\ExcelTemplates\OtherBankPaymentTemplate.xlsx");
                    //}
                    //var path1 = HostingEnvironment.MapPath(@"~\Resources\ExcelTemplates");
                    //var guid = Guid.NewGuid();

                    //}

                }
                else if (TemplateType == "nonAxis")
                {
                    path = HostingEnvironment.MapPath(@"~\Resources\ExcelTemplates\NonAxisBankTemplate.xlsx");
                    var pdfOutputModel = new PdfGenerationOutputModel();
                    var destinationPath = Path.Combine(path1, guid.ToString());
                    string docName = Path.Combine(destinationPath, "NonAxisBankTemplate.xlsx");
                    if (!Directory.Exists(destinationPath))
                    {
                        Directory.CreateDirectory(destinationPath);

                        if (path != null)
                        {
                            System.IO.File.Copy(path, docName, true);
                        }

                        LoggingManager.Info("Created a directory to save temp file");
                    }

                    var employeeCreditorDetailsSearchInputModel = new EmployeeCreditorDetailsSearchInputModel();
                    employeeCreditorDetailsSearchInputModel.EmployeeCreditorDetailsId = null;
                    employeeCreditorDetailsSearchInputModel.IsArchived = false;

                    List<EmployeeCreditorDetailsSearchOutputModel> EmployeeCreditorDetails = _payRollRepository.GetEmployeeCreditorDetails(employeeCreditorDetailsSearchInputModel, loggedInContext, validationMessages).ToList();

                    string[] columnIndex = new string[] { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "AA", "AB", "AC", "AD", "AE", "AF", "AG", "AH", "AI"};

                    using (SpreadsheetDocument spreadSheet = SpreadsheetDocument.Open(docName, true))
                    {

                        uint rowIndex = 0;

                        uint creditorIndex = 0;

                        decimal totalAmount = 0;

                        foreach(var creditor in EmployeeCreditorDetails)
                        {
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "A", "1");
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "B", "SHO" + Convert.ToDateTime(payRollRunTemplates[0].RunDate.ToString()).ToString("ddMMyyyy").ToString());
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "C", "TB");
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "D", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "E", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "F", payRollRunTemplates.ToList().Count().ToString());
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "G", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "H", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "I", creditor.IfScCode);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "J", creditor.AccountNumber);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "K", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "L", creditor.AccountName);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "M", "MUMBAI");
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "N", creditor.MobileNo);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "O", creditor.Email);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "P", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "Q", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "R", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "S", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "T", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "U", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "V", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "W", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "X", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "Y", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "Z", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AA", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AB", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AC", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AD", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AE", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AF", payRollRunTemplates[0].ChequeDate.HasValue ? Convert.ToDateTime(payRollRunTemplates[0].ChequeDate.ToString()).ToString("dd-MMM-yyyy").ToString() : null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AG", payRollRunTemplates[0].AlphaCode);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AH", payRollRunTemplates[0].Cheque);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AI", payRollRunTemplates[0].ChequeNo);
                            rowIndex++;
                            creditorIndex++;
                        }

                        if(EmployeeCreditorDetails.Count == 0)
                        {
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "A", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "B", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "C", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "D", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "E", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "F", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "G", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "H", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "I", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "J", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "K", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "L", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "M", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "N", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "O", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "P", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "Q", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "R", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "S", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "T", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "U", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "V", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "W", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "X", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "Y", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "Z", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AA", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AB", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AC", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AD", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AE", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AF", payRollRunTemplates[0].ChequeDate.HasValue ? Convert.ToDateTime(payRollRunTemplates[0].ChequeDate.ToString()).ToString("dd-MMM-yyyy").ToString() : null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AG", payRollRunTemplates[0].AlphaCode);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AH", payRollRunTemplates[0].Cheque);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AI", payRollRunTemplates[0].ChequeNo);
                            rowIndex++;
                            creditorIndex++;
                        }


                        //rowIndex = rowIndex + 1;
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "A", null);
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "B", null);
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "C", null);
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "D", "3");
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "E", payRollRunTemplates.Count.ToString());
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "F", "Date in DD-MMM-YYYY");
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "G", null);
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "H", null);
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "I", null);
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "J", null);
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "K", null);
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "L", null);
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "M", "ACCOUNT HOLDER NAME");
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "N", "IFSC codes");
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "O", "A/C NUMBERS");
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "P", "10");
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "Q", "AMT");
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "R", "NARRATION TO BE CAPTURE");
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "S", null);
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "T", "Payroll Date");
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "U", null);
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "V", null);
                        //AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "W", null);

                        //rowIndex = rowIndex + 1;

                        foreach (var payroll in payRollRunTemplates.Where(x => x.IsProcessedToPay == true).ToList())
                        {
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "A", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "B", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "C", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "D", "3");
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "E", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "F", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "G", Convert.ToDateTime(payroll.RunDate.ToString()).ToString("dd-MMM-yyyy").ToString());
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "H", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "I", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "J", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "K", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "L", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "M", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "N", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "O", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "P", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "Q", payroll.BeneficiaryName);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "R", payroll.DebitAccountIfsc);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "S", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "T", payroll.BeneficiaryAccountNumber);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "U", "10");
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "V", payroll.Amount.ToString());
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "W", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "X", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "Y", payroll.RemarksForBeneficiary);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "Z", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AA", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AB", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AC", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AD", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AE", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AF", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AG", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AH", null);
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", rowIndex, "AI", null);
                            rowIndex++;
                            totalAmount = totalAmount + payroll.Amount;
                        }

                        for (uint i = 0;i < creditorIndex; i++)
                        {
                            AddUpdateTemplateCellValue(spreadSheet, "Sheet1", i, "V", totalAmount.ToString());
                        }

                        spreadSheet.Close();

                        blobUrl = _fileStoreService.PostFile(new FilePostInputModel
                        {
                            MemoryStream = System.IO.File.ReadAllBytes(docName),
                            FileName = "Payment" + DateTime.Now.ToString("yyyy-MM-dd") + ".xlsx",
                            ContentType = "application/xlsx",
                            LoggedInUserId = loggedInContext.LoggedInUserId
                        });

                        UpdatePayrollRunEmployeePaymentStatus(payRollRunTemplates, loggedInContext, validationMessages);

                    }

                    if (Directory.Exists(destinationPath))
                    {
                        System.IO.File.Delete(docName);
                        Directory.Delete(destinationPath);

                        LoggingManager.Info("Deleting the temp folder");
                    }
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadUserstories", "UserStoryApiController"));
                    return blobUrl;
                }
                return null;
            }
            return null;
        }

        public void UpdatePayrollRunEmployeePaymentStatus(List<PayRollRunTemplate> payRollRunTemplates, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var holdedPayrollRunEmployees = payRollRunTemplates.Where(x => x.IsProcessedToPay != true).Select(x => x.PayrollRunEmployeeId).ToList();
            var processedPayrollRunEmployees = payRollRunTemplates.Where(x => x.IsProcessedToPay == true).Select(x => x.PayrollRunEmployeeId).ToList();
            if (holdedPayrollRunEmployees.Any())
            {
                _payRollRepository.UpdatePayrollRunEmployeePaymentStatus(holdedPayrollRunEmployees, false, loggedInContext, validationMessages);
            }
            if (processedPayrollRunEmployees.Any())
            {
                _payRollRepository.UpdatePayrollRunEmployeePaymentStatus(processedPayrollRunEmployees, true, loggedInContext, validationMessages);
            }

        }
        private WorksheetPart GetWorksheetPartByName(SpreadsheetDocument document, string sheetName, string newName)
        {
            //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoServiceValue, "GetWorksheetPartByName", "CourseReport"));

            IEnumerable<Sheet> sheets =
                document.WorkbookPart.Workbook.GetFirstChild<Sheets>().
                    Elements<Sheet>().Where(s => s.Name == sheetName).ToList();

            if (!sheets.Any())
            {
                return null;
            }

            string relationshipId = sheets.First().Id.Value;
            if (!String.IsNullOrEmpty(newName)) sheets.First().Name = newName;
            WorksheetPart worksheetPart = (WorksheetPart)document.WorkbookPart.GetPartById(relationshipId);

            //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoServiceExitingValue, "GetWorksheetPartByName", "CourseReport"));

            return worksheetPart;

        }

        public Guid? UpsertEmployeeTaxAllowanceDetails(EmployeeTaxAllowanceDetailsUpsertInputModel employeeTaxAllowanceDetailsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(employeeTaxAllowanceDetailsUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeTaxAllowanceDetailsCommandId, employeeTaxAllowanceDetailsUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertEmployeeTaxAllowanceDetailsValidation(employeeTaxAllowanceDetailsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            employeeTaxAllowanceDetailsUpsertInputModel.EmployeeTaxAllowanceId = _payRollRepository.UpsertEmployeeTaxAllowanceDetails(employeeTaxAllowanceDetailsUpsertInputModel, loggedInContext, validationMessages);
            return employeeTaxAllowanceDetailsUpsertInputModel.EmployeeTaxAllowanceId;
        }

        public List<EmployeeTaxAllowanceDetailsSearchOutputModel> GetEmployeeTaxAllowanceDetails(EmployeeTaxAllowanceDetailsSearchInputModel employeeTaxAllowanceDetailsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeTaxAllowanceDetailss", "PayRoll Service"));
            LoggingManager.Debug(employeeTaxAllowanceDetailsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetEmployeeTaxAllowanceDetailsCommandId, employeeTaxAllowanceDetailsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<EmployeeTaxAllowanceDetailsSearchOutputModel> employeeTaxAllowanceDetails = _payRollRepository.GetEmployeeTaxAllowanceDetailss(employeeTaxAllowanceDetailsSearchInputModel, loggedInContext, validationMessages).ToList();
            return employeeTaxAllowanceDetails;
        }

        public Guid? UpsertLeaveEncashmentSettings(LeaveEncashmentSettingsUpsertInputModel leaveEncashmentSettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertLeaveEncashmentSettings", "PayRoll Service"));
            LoggingManager.Debug(leaveEncashmentSettingsUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertLeaveEncashmentSettingsCommandId, leaveEncashmentSettingsUpsertInputModel, loggedInContext);
            //if (!PayRollValidationHelper.UpsertLeaveEncashmentSettingsValidation(LeaveEncashmentSettingsUpsertInputModel, loggedInContext, validationMessages))
            //{
            //    return null;
            //}
            leaveEncashmentSettingsUpsertInputModel.LeaveEncashmentSettingsId = _payRollRepository.UpsertLeaveEncashmentSettings(leaveEncashmentSettingsUpsertInputModel, loggedInContext, validationMessages);
            return leaveEncashmentSettingsUpsertInputModel.LeaveEncashmentSettingsId;
        }
        public List<LeaveEncashmentSettingsSearchOutputModel> GetLeaveEncashmentSettings(LeaveEncashmentSettingsSearchInputModel leaveEncashmentSettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeaveEncashmentSettings", "PayRoll Service"));
            LoggingManager.Debug(leaveEncashmentSettingsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetLeaveEncashmentSettingsCommandId, leaveEncashmentSettingsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<LeaveEncashmentSettingsSearchOutputModel> leaveEncashmentSettings = _payRollRepository.GetLeaveEncashmentSettings(leaveEncashmentSettingsSearchInputModel, loggedInContext, validationMessages).ToList();
            return leaveEncashmentSettings;
        }

        public List<PayrollRunOutPutModel> InsertPayrollRun(PayrollRun payrollRun, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeePayrollConfiguration", "PayRollTemplate Service"));

            var result = _payRollRepository.InsertPayrollRun(payrollRun, loggedInContext, validationMessages);

            return result;
        }

        public Guid? UpsertEmployeeAccountDetails(EmployeeAccountDetailsUpsertInputModel EmployeeAccountDetailsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeAccountDetails", "PayRoll Service"));
            LoggingManager.Debug(EmployeeAccountDetailsUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeAccountDetailsCommandId, EmployeeAccountDetailsUpsertInputModel, loggedInContext);
            EmployeeAccountDetailsUpsertInputModel.EmployeeAccountDetailsId = _payRollRepository.UpsertEmployeeAccountDetails(EmployeeAccountDetailsUpsertInputModel, loggedInContext, validationMessages);
            return EmployeeAccountDetailsUpsertInputModel.EmployeeAccountDetailsId;
        }
        public List<EmployeeAccountDetailsSearchOutputModel> GetEmployeeAccountDetails(EmployeeAccountDetailsSearchInputModel EmployeeAccountDetailsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeAccountDetails", "PayRoll Service"));
            LoggingManager.Debug(EmployeeAccountDetailsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetEmployeeAccountDetailsCommandId, EmployeeAccountDetailsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<EmployeeAccountDetailsSearchOutputModel> EmployeeAccountDetails = _payRollRepository.GetEmployeeAccountDetails(EmployeeAccountDetailsSearchInputModel, loggedInContext, validationMessages).ToList();
            return EmployeeAccountDetails;
        }

        public Guid? UpsertFinancialYearConfigurations(FinancialYearConfigurationsUpsertInputModel FinancialYearConfigurationsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(FinancialYearConfigurationsUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertFinancialYearConfigurationsCommandId, FinancialYearConfigurationsUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertFinancialYearConfigurationsValidation(FinancialYearConfigurationsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            FinancialYearConfigurationsUpsertInputModel.FinancialYearConfigurationsId = _payRollRepository.UpsertFinancialYearConfigurations(FinancialYearConfigurationsUpsertInputModel, loggedInContext, validationMessages);
            return FinancialYearConfigurationsUpsertInputModel.FinancialYearConfigurationsId;
        }
        public List<FinancialYearConfigurationsSearchOutputModel> GetFinancialYearConfigurations(FinancialYearConfigurationsSearchInputModel FinancialYearConfigurationsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFinancialYearConfigurations", "PayRoll Service"));
            LoggingManager.Debug(FinancialYearConfigurationsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetFinancialYearConfigurationsCommandId, FinancialYearConfigurationsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<FinancialYearConfigurationsSearchOutputModel> FinancialYearConfigurations = _payRollRepository.GetFinancialYearConfigurations(FinancialYearConfigurationsSearchInputModel, loggedInContext, validationMessages).ToList();
            return FinancialYearConfigurations;
        }

        public void RunSchedulingJobs(PayRollTemplateUpsertInputModel payRollTemplateUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, int? jobId)
        {
            if (payRollTemplateUpsertInputModel != null && payRollTemplateUpsertInputModel.PayRollTemplateId != null && payRollTemplateUpsertInputModel.FrequencyId != null)
            {
                var inputModel = new PayFrequencySearchCriteriaInputModel();
                inputModel.PayFrequencyId = payRollTemplateUpsertInputModel.FrequencyId;
                var result = _masterManagementRepository.GetPayFrequency(inputModel, loggedInContext, validationMessages);
                if (result.Any())
                {
                    DateTime currentDate = DateTime.Now;
                    DateTime startDate = new DateTime(currentDate.Year, currentDate.Month, 1);
                    //var payrollRun = new PayrollRun
                    //{
                    //    PayrollStartDate = startDate,
                    //    PayrollEndDate = startDate.AddMonths(1).AddDays(-1),
                    //    TemplateId = payRollTemplateUpsertInputModel.PayRollTemplateId
                    //};
                    //RecurringJob.AddOrUpdate(jobId.ToString(), () => InsertPayrollRun(payrollRun, loggedInContext, validationMessages),
                    //    result.First().CronExpression);
                }
            }
        }

        public Guid? UpdatePayrollRunEmployeeStatus(PayrollRunEmployee payrollRunEmployee, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdatePayrollRunEmployeeStatus", "PayRollTemplate Service"));

            var result = _payRollRepository.UpdatePayrollRunEmployeeStatus(payrollRunEmployee, loggedInContext, validationMessages);

            return result;
        }

        public Guid? UpdatePayrollRunStatus(PayRollStatus payRollStatus, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdatePayrollRunStatus", "PayRollTemplate Service"));
            var status = _payRollRepository.GetPayrollStatusList(payRollStatus.Id, loggedInContext, validationMessages).FirstOrDefault();

            //if (status != null && status.PayRollStatusName == AppConstants.PayrollSubmittedStatus)
            //{
            //    var workflowModel = new WorkFlowTriggerModel
            //    {
            //        ReferenceTypeId = AppCommandConstants.PayrollReferenceTypeId

            //    };
            //    var workflowTrigger = _automatedWorkflowmanagementServices.GetWorkFlowTriggers(workflowModel, loggedInContext, validationMessages).FirstOrDefault();
            //    if (workflowTrigger != null)
            //    {
            //        var processInstanceId = StartWorkflowProcessInstance(workflowTrigger, loggedInContext, payRollStatus.PayrollRunId);

            //        if (processInstanceId != null)
            //        {
            //            payRollStatus.WorkflowProcessInstanceId = new Guid(processInstanceId);
            //        }
            //    }
            //}

            if (status != null && status.PayRollStatusName == AppConstants.PayrollPaidStatus)
            {
                _payRollRepository.UpdateStatusOfPayrollComponents(payRollStatus.PayrollRunId, loggedInContext, validationMessages);
            }


            var result = _payRollRepository.UpdatePayrollRunStatus(payRollStatus, loggedInContext, validationMessages);

            if (status != null && status.PayRollStatusName == AppConstants.PayrollPaidStatus && payRollStatus.IsPayslipReleased)
            {
                SendEmailWithPayslip(payRollStatus.PayrollRunId ?? Guid.NewGuid(), loggedInContext, validationMessages);
            }

            return result;
        }

        public Guid? GetStatusIdByName(string statusName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return _payRollRepository.GetStatusIdByName(statusName, loggedInContext, validationMessages);
        }
        public string StartWorkflowProcessInstance(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, Guid? payrollRunId)
        {

            XmlDocument document = new XmlDocument();

            document.LoadXml(workFlowTriggerModel.WorkflowXml);

            var xmlAttributeCollection = document.GetElementsByTagName("bpmn:definitions")[0]?.ChildNodes[0]?.Attributes;
            if (xmlAttributeCollection != null)
            {
                var workflowName = xmlAttributeCollection?["id"]?.InnerText.Trim();
                var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];

                CamundaEngineClient camunda = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);

                var processInstanceId = camunda.BpmnWorkflowService.StartProcessInstance(workflowName, new Dictionary<string, object>()
                {

                    {"loggedUserId",  loggedInContext.LoggedInUserId},
                    {"companyId",  loggedInContext.CompanyGuid},
                    {"PayrollRunId",  payrollRunId}
                });


                return processInstanceId;
            }

            return null;
        }

        public List<UserOutputModel> GetUsersByRole(string roleName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayrollRunList", "PayRollTemplate Service"));

            List<UserOutputModel> result = _payRollRepository.GetUsersByRole(roleName, loggedInContext, validationMessages).ToList();

            return result;
        }

        public Guid? UpsertPayRollCalculationConfigurations(PayRollCalculationConfigurationsUpsertInputModel PayRollCalculationConfigurationsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollCalculationConfigurations", "PayRoll Service"));
            LoggingManager.Debug(PayRollCalculationConfigurationsUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertPayRollCalculationConfigurationsCommandId, PayRollCalculationConfigurationsUpsertInputModel, loggedInContext);
            PayRollCalculationConfigurationsUpsertInputModel.PayRollCalculationConfigurationsId = _payRollRepository.UpsertPayRollCalculationConfigurations(PayRollCalculationConfigurationsUpsertInputModel, loggedInContext, validationMessages);
            return PayRollCalculationConfigurationsUpsertInputModel.PayRollCalculationConfigurationsId;
        }
        public List<PayRollCalculationConfigurationsSearchOutputModel> GetPayRollCalculationConfigurations(PayRollCalculationConfigurationsSearchInputModel PayRollCalculationConfigurationsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollCalculationConfigurations", "PayRoll Service"));
            LoggingManager.Debug(PayRollCalculationConfigurationsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollCalculationConfigurationsCommandId, PayRollCalculationConfigurationsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<PayRollCalculationConfigurationsSearchOutputModel> PayRollCalculationConfigurations = _payRollRepository.GetPayRollCalculationConfigurations(PayRollCalculationConfigurationsSearchInputModel, loggedInContext, validationMessages).ToList();
            return PayRollCalculationConfigurations;
        }

        public Guid? UpsertEmployeeCreditorDetails(EmployeeCreditorDetailsUpsertInputModel EmployeeCreditorDetailsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeeCreditorDetails", "PayRoll Service"));
            LoggingManager.Debug(EmployeeCreditorDetailsUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeCreditorDetailsCommandId, EmployeeCreditorDetailsUpsertInputModel, loggedInContext);
            EmployeeCreditorDetailsUpsertInputModel.EmployeeCreditorDetailsId = _payRollRepository.UpsertEmployeeCreditorDetails(EmployeeCreditorDetailsUpsertInputModel, loggedInContext, validationMessages);
            return EmployeeCreditorDetailsUpsertInputModel.EmployeeCreditorDetailsId;
        }
        public List<EmployeeCreditorDetailsSearchOutputModel> GetEmployeeCreditorDetails(EmployeeCreditorDetailsSearchInputModel EmployeeCreditorDetailsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeCreditorDetails", "PayRoll Service"));
            LoggingManager.Debug(EmployeeCreditorDetailsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetEmployeeCreditorDetailsCommandId, EmployeeCreditorDetailsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<EmployeeCreditorDetailsSearchOutputModel> EmployeeCreditorDetails = _payRollRepository.GetEmployeeCreditorDetails(EmployeeCreditorDetailsSearchInputModel, loggedInContext, validationMessages).ToList();
            return EmployeeCreditorDetails;
        }

        public List<PeriodTypeModel> GetPeriodTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPeriodTypes", "PayRoll Service"));
            LoggingManager.Debug(payRollTemplateSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollTemplatesCommandId, payRollTemplateSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<PeriodTypeModel> PeriodTypes = _payRollRepository.GetPeriodTypes(payRollTemplateSearchInputModel, loggedInContext, validationMessages).ToList();
            return PeriodTypes;
        }

        public List<PayRollCalculationTypeModel> GetPayRollCalculationTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollCalculationTypes", "PayRoll Service"));
            LoggingManager.Debug(payRollTemplateSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollTemplatesCommandId, payRollTemplateSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<PayRollCalculationTypeModel> PayRollCalculationTypes = _payRollRepository.GetPayRollCalculationTypes(payRollTemplateSearchInputModel, loggedInContext, validationMessages).ToList();
            return PayRollCalculationTypes;
        }

        public List<PayrollRunEmployee> GetEmployeePayrollDetailsList(Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeePayrollDetailsList", "PayRollTemplate Service"));

            List<PayrollRunEmployee> result = _payRollRepository.GetEmployeePayrollDetailsList(employeeId, loggedInContext, validationMessages).ToList();

            return result;
        }

        public EmployeeSalaryCertificateModel GetEmployeeSalaryCertificate(Guid employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeSalaryCertificate", "PayRoll Service"));

            EmployeeSalaryCertificateModel result = _payRollRepository.GetEmployeeSalaryCertificate(employeeId, loggedInContext, validationMessages);

            return result;
        }

        public List<FinancialYearTypeModel> GetFinancialYearTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFinancialYearTypes", "PayRoll Service"));
            LoggingManager.Debug(payRollTemplateSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollTemplatesCommandId, payRollTemplateSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<FinancialYearTypeModel> FinancialYearTypes = _payRollRepository.GetFinancialYearTypes(payRollTemplateSearchInputModel, loggedInContext, validationMessages).ToList();
            return FinancialYearTypes;
        }

        public decimal? GetPayrollRunEmployeeCount(Guid? payrollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFinancialYearTypes", "PayRoll Service"));

            var count = _payRollRepository.GetPayrollRunEmployeeCount(payrollRunId, loggedInContext, validationMessages);
            return count;
        }

        public List<ESIMonthlyStatementOutputModel> GetESIMonthlyStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetESIMonthlyStatement", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ESIMonthlyStatementOutputModel> result = _payRollRepository.GetESIMonthlyStatement(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<SalaryRegisterOutputModel> GetSalaryRegister(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSalaryRegister", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<SalaryRegisterOutputModel> result = _payRollRepository.GetSalaryRegister(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<IncomeSalaryStatementOutputModel> GetIncomeSalaryStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetIncomeSalaryStatement", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<IncomeSalaryStatementOutputModel> result = _payRollRepository.GetIncomeSalaryStatement(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }
        public List<ProfessionTaxMonthlyStatementOutputModel> GetProfessionTaxMonthlyStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProfessionTaxMonthlyStatement", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ProfessionTaxMonthlyStatementOutputModel> result = _payRollRepository.GetProfessionTaxMonthlyStatement(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }
        public List<ProfessionTaxReturnsOutputModel> GetProfessionTaxReturns(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProfessionTaxReturns", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ProfessionTaxReturnsOutputModel> result = _payRollRepository.GetProfessionTaxReturns(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<SalaryBillRegisterOutputModel> GetSalaryBillRegister(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSalaryBillRegister", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<SalaryBillRegisterOutputModel> result = _payRollRepository.GetSalaryBillRegister(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<IncomeSalaryStatementDetailsOutputModel> GetIncomeSalaryStatementDetails(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetIncomeSalaryStatementDetails", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<IncomeSalaryStatementDetailsOutputModel> result = _payRollRepository.GetIncomeSalaryStatementDetails(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<ITSavingsReportOutputModel> GetITSavingsReport(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetITSavingsReport", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ITSavingsReportOutputModel> result = _payRollRepository.GetITSavingsReport(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }
        public List<IncomeTaxMonthlyStatementOutputModel> GetIncomeTaxMonthlyStatement(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetIncomeTaxMonthlyStatement", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<IncomeTaxMonthlyStatementOutputModel> result = _payRollRepository.GetIncomeTaxMonthlyStatement(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<SalaryForITOutputModel> GetSalaryforITOfAnEmployee(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSalaryforITOfAnEmployee", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<SalaryForITOutputModel> result = _payRollRepository.GetSalaryforITOfAnEmployee(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<RegisterOfWagesOutputModel> GetRegisterOfWages(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRegisterOfWages", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<RegisterOfWagesOutputModel> result = _payRollRepository.GetRegisterOfWages(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<EmployeeESIReportOutputModel> GetEmployeeESIReport(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeESIReport", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<EmployeeESIReportOutputModel> result = _payRollRepository.GetEmployeeESIReport(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public List<EmployeePFReportOutputModel> GetEmployeePFReport(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeePFReport", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<EmployeePFReportOutputModel> result = _payRollRepository.GetEmployeePFReport(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();
            return result;
        }

        public async Task<byte[]> PrintFormv(PayRollReportsSearchInputModel payRollReportsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProfessionTaxReturns", "PayRoll Service"));

            LoggingManager.Debug(payRollReportsSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ProfessionTaxReturnsOutputModel> result = _payRollRepository.GetProfessionTaxReturns(payRollReportsSearchInputModel, loggedInContext, validationMessages).ToList();

            string html = "<!DOCTYPE html><html><head><style>.form-v-table {border: 1px solid #dddddd;text-align: left;padding: 8px;}";

            html += ".hide-content-overflow {overflow: hidden !important;text-overflow: ellipsis;white-space: nowrap;}</style></head><body style=\"font-family: Arial, Helvetica, sans-serif; \">";
            html += "<div style=\"border-style: solid; border-width: 2px; \"><div style = \"border-bottom-style: solid;border-width: 2px;flex: 1 1 0%;box-sizing: border-box;flex-flow: row wrap;display: flex;\">";
            html += "<div style = \"border-right-style: solid;border-right-width: 2px;flex: 1 1 30%;box-sizing: border-box;max-width: 30%;background-color:#cececa\">";
            html += "<div style = \"flex: 1 1 0%;box-sizing: border-box;place-content: center;align-items: center;flex-direction: row;display: flex;\">";
            html += "<b><p style = \"margin: 0.5rem !important;\"> FORM V </p></b></div>";
            html += "<div style = \"flex: 1 1 0%;box-sizing: border-box;place-content: center;align-items: center;flex-direction: row;display: flex;\">";
            html += "<b><p style = \"margin: 3px;\"> (See Ruler 12)</p></b></div></div><div style = \"flex: 1 1 0%;box-sizing: border-box;\">";
            html += "<div style = \"flex: 1 1 0%;box-sizing: border-box;place-content: center;align-items: center;flex-direction: row;display: flex;\">";
            html += "<b><p style = \"margin: 0.5rem !important;\"> RETURN OF TAX PAYABLE BY EMPLOYER </p></b></div>";
            html += "<div style = \"flex: 1 1 0%;box-sizing: border-box;place-content: center;align-items: center;flex-direction: row;display: flex;\">";
            html += "<b><p style = \"margin: 3px;\"> Under Sub - section(1) of the A.P Tax on Professions, Traders, Calling</p></b></div><div style = \"flex: 1 1 0%;box-sizing: border-box;place-content: center;align-items: center;flex-direction: row;display: flex;\">";
            html += "<b><p style = \"margin: 3px;\"> and Employments Act,1967 </p></b ></div></div></div>";
            html += "<p style = \"margin: 0 !important;padding-bottom:5px\"> Return on Tax Payable for the month ending on </p><div style = \"flex: 1 1 0%;box-sizing: border-box;flex-flow: row wrap;display: flex;\">";
            html += "<div style = \"flex: 1 1 15%;box-sizing: border-box;max-width: 23%;padding-bottom:5px\">Name of the Employer:</div><div style = \"flex: 1 1 0%;box-sizing: border-box;\">";
            html += result[0].CompanyName;
            html += "</div></div>";
            html += "<div style = \"flex: 1 1 0%;box-sizing: border-box;flex-flow: row wrap;display: flex;\"><div style = \"flex: 1 1 15%;box-sizing: border-box;max-width: 15%;padding-bottom:5px\">";
            html += "Address:</div><div style = \"flex: 1 1 0%;box-sizing: border-box;\">";
            html += payRollReportsSearchInputModel.CompleteAddress;
            html += "</div></div>Number of employees during the month in respect of whom the tax payable is under:";
            html += "<table style=\"width: 100%; border-collapse: collapse;\"><tr><th class=\"form-v-table\"style=\"background-color:#cececa\">Employees whose monthly salaries or wages or both</th>";
            html += "<th class=\"form-v-table\"style=\"background-color:#cececa\">Number of employees</th><th class=\"form-v-table\"style=\"background-color:#cececa\">Rate of Tax</th><th class=\"form-v-table\"style=\"background-color:#cececa\">Amount of Tax Deducted</th></tr>";
            var totalEmployees = 0;
            var totalAmount = 0.0;
            var totalTax = 0.0;
            foreach (var x in result)
            {
                html += "<tr><td class=\"form-v-table\">" + x.Ranges + "</td>";
                html += "<td class=\"form-v-table\">" + x.NoOfEmployee + "</td>";
                html += "<td class=\"form-v-table\">" + x.TaxAmount + "</td>";
                html += "<td class=\"form-v-table\">" + x.TotalTax + "</td>";
                html += "</tr>";
                totalEmployees += x.NoOfEmployee;
                totalAmount += x.TaxAmount;
                totalTax += x.TotalTax;
            }
            html += "<tr><td class=\"form-v-table\">" + "<b>Total</b>" + "</td>";
            html += "<td class=\"form-v-table\"><b>" + totalEmployees + "</b></td>";
            html += "<td class=\"form-v-table\"><b>" + "" + "</b></td>";
            html += "<td class=\"form-v-table\"><b>" + totalTax + "</b></td>";
            html += "</tr>";
            html += "</table><p style=\"width:50%;\"> Add: simple interset payable (if any) on the obve amount at two percent per month or part thereof( vide section II (2) of the Act ).</p>";
            html += "<table style=\"width: 100%; border-collapse: collapse;\"><tr>";

            html += "<th class=\"form-v-table\" style=\"width:46.5%;\"><b>" + "GrandTotal" + "</b></th>";
            html += "<th class=\"form-v-table\" style=\"width:20%;\"><b>" + totalEmployees + "</b></th>";
            html += "<th class=\"form-v-table\" style=\"width: 11%;\"><b>" + "" + "</b></th>";
            html += "<th class=\"form-v-table\"><b>" + totalTax + "</b></th>";
            html += "</tr>";
            html += "</table>";

            html += "<div style=\"flex-flow: row wrap; box-sizing: border-box; display: flex;padding-top:5px \"><div style = \"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;\">";
            html += "<div style = \"flex-flow: row wrap;box-sizing: border-box;display: flex;\"><div style = \"flex: 1 1 45%;box-sizing: border-box;max-width: 45%;\">";
            html += "<label><b>Amount paid</b></label></div>";
            html += "<div style = \"flex: 1 1 55%;box-sizing: border-box;max-width: 55%;\" class=\"hide-content-overflow\"><label>:&nbsp;" + totalTax + "</label>";
            html += "</div></div></div>";
            html += "<div style = \"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;\">";
            html += "<div style= \"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style= \"flex: 1 1 45%;box-sizing: border-box;max-width: 45%;\">";
            html += "<label><b> Under Challan No</b></label>";
            html += "</div>";
            html += "<div style = \"flex: 1 1 55%;box-sizing: border-box;max-width: 55%;\" class=\"hide-content-overflow\">";
            html += "<label>:&nbsp;" + "" + "</label></div></div></div>";
            html += "<div style = \"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;\">";
            html += "<div style=\"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style = \"flex: 1 1 45%;box-sizing: border-box;max-width: 45%;\">";
            html += "<label><b>dated</b></label>";
            html += "</div>";
            html += "<div style=\"flex: 1 1 55%;box-sizing: border-box;max-width: 55%;\" class=\"hide-content-overflow\">";
            html += "<label>:&nbsp;</label></div></div></div></div>";
            html += "I certify that the employees who are liable to pay tax in my employment during the period of return have been covered by the foregoing particulars.I also certify that the necessary revision in the amoiunt of tax";
            html += "deductable from the salary or wages of the employees on account variation in the salary or wages earned by them has been";
            html += "made wherever necessary.<br><br>Solemnly declare that the above statements are true to the best of my knowledge and belief.<br><br>";
            html += "<div style = \"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style = \"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;\">";
            html += "<div style = \"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style = \"flex: 1 1 45%;box-sizing: border-box;max-width: 45%;\">";
            html += "<label><b> " + "Place" + " </b></label></div>";

            html += "<div style = \"flex: 1 1 55%;box-sizing: border-box;max-width: 55%;\" class=\"hide-content-overflow\">";
            html += "<label>:&nbsp;" + "" + "</label></div></div></div>";

            html += "<div style = \"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;\">";
            html += "</div>";
            html += "<div style=\"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;\">";
            html += "<div style = \"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style=\"flex: 1 1 45%;box-sizing: border-box;max-width: 45%;\">";
            html += "<label><b>Signature</b></label>";
            html += "</div>";
            html += "<div style = \"flex: 1 1 55%;box-sizing: border-box;max-width: 55%;\" class=\"hide-content-overflow\">";
            html += "<label>:&nbsp;" + "" + "</label><br>";
            html += "(Employer)</div></div></div></div>";

            html += "<div style = \"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style=\"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;\">";
            html += "<div style = \"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";

            html += "<div style=\"flex: 1 1 45%;box-sizing: border-box;max-width: 45%;\">";
            html += "<label><b>Date</b></label></div>";
            html += "<div style = \"flex: 1 1 55%;box-sizing: border-box;max-width: 55%;\" class=\"hide-content-overflow\">";
            html += "<label>:&nbsp;" + "" + "</label></div></div></div><br>";
            html += "<div style = \"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;\">";
            html += "</div>";
            html += "<div style=\"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;\">";
            html += "<div style = \"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style=\"flex: 1 1 45%;box-sizing: border-box;max-width: 45%;\">";
            html += "<label><b>Signature</b></label></div>";
            html += "<div style = \"flex: 1 1 55%;box-sizing: border-box;max-width: 55%;\" class=\"hide-content-overflow\">";
            html += "<label>:&nbsp;" + "" + "</label></div></div></div></div>";
            html += "<div style = \"border-bottom-style: solid;border-bottom-width: 2px;padding:5px 0px 5px 0px\"></div>";
            html += "<div style=\"flex: 1 1 0%;box-sizing: border-box;place-content: center;align-items: center;flex-direction: row;display: flex;\">";
            html += "<b>(FOR OFFICIAL USE ONLY)</b>";
            html += "</div>";
            html += "<p style=\"margin:5px\">The return is accepted on verification</p>";
            html += "<div style=\"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style = \"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;padding-bottom:5px\">";
            html += "<div style=\"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style = \"flex: 1 1 45%;box-sizing: border-box;max-width: 45%;\">";
            html += "<label><b> Tax assessed</b></label>";
            html += "</div>";
            html += "<div style = \"flex: 1 1 55%;box-sizing: border-box;max-width: 55%;\" class=\"hide-content-overflow\">";
            html += "<label>:&nbsp;Rs</label></div></div></div></div>";

            html += "<div style = \"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style=\"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;padding-bottom:5px\">";
            html += "<div style = \"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style=\"flex: 1 1 45%;box-sizing: border-box;max-width: 45%;\">";
            html += "<label><b>Tax paid</b></label></div>";
            html += "<div style = \"flex: 1 1 55%;box-sizing: border-box;max-width: 55%;\" class=\"hide-content-overflow\">";
            html += "<label>:&nbsp;Rs</label></div></div></div></div>";

            html += "<div style = \"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style=\"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;padding-bottom:5px\">";
            html += "<div style = \"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style=\"flex: 1 1 45%;box-sizing: border-box;max-width: 45%;\">";
            html += "<label><b>Balance</b></label></div><div style = \"flex: 1 1 55%;box-sizing: border-box;max-width: 55%;\" class=\"hide-content-overflow\">";
            html += "<label>:&nbsp;Rs</label></div></div></div>";
            html += "<div style = \"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;\">";
            html += "</div>";
            html += "<div style=\"margin-right: 0px;flex: 1 1 33.3%;box-sizing: border-box;max-width: 33.3%;\">";
            html += "<div style = \"flex-flow: row wrap;box-sizing: border-box;display: flex;\">";
            html += "<div style=\"flex: 1 1 70%;box-sizing: border-box;max-width: 70%;\">";
            html += "<label><b>Assessing Authority</b></label></div></div></div></div>";
            html += "<div style = \"flex: 1 1 0%;box-sizing: border-box;place-content: center;align-items: center;flex-direction: row;display: flex;padding-top:5px\">";
            html += "<b> Note: When the return is not acceptable seperate order of assessment should be passed.</b>";
            html += "</div></div><body></html>";

            var pdfOutput = await _chromiumService.GeneratePdf(html, null, "FormV");

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "PrintAssets", "Asset Service"));

            LoggingManager.Debug(pdfOutput.ByteStream.ToString());

            return pdfOutput.ByteStream;
        }

        public Guid? UpsertTdsSettings(TdsSettingsUpsertInputModel TdsSettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(TdsSettingsUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertTdsSettingsCommandId, TdsSettingsUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertTdsSettingsValidation(TdsSettingsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            TdsSettingsUpsertInputModel.TdsSettingsId = _payRollRepository.UpsertTdsSettings(TdsSettingsUpsertInputModel, loggedInContext, validationMessages);
            return TdsSettingsUpsertInputModel.TdsSettingsId;
        }
        public List<TdsSettingsSearchOutputModel> GetTdsSettings(TdsSettingsSearchInputModel TdsSettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTdsSettings", "PayRoll Service"));
            LoggingManager.Debug(TdsSettingsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetTdsSettingsCommandId, TdsSettingsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<TdsSettingsSearchOutputModel> TdsSettings = _payRollRepository.GetTdsSettings(TdsSettingsSearchInputModel, loggedInContext, validationMessages).ToList();
            return TdsSettings;
        }

        public List<HourlyTdsConfigurationSearchOutputModel> GetHourlyTdsConfiguration(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHourlyTdsConfiguration", "PayRoll Service"));

            var HourlyList = _payRollRepository.GetHourlyTdsConfiguration(hourlyTdsConfigurationSearchInputModel, loggedInContext, validationMessages);

            if (HourlyList != null && HourlyList.Count > 0)
            {
                return HourlyList;
            }

            return new List<HourlyTdsConfigurationSearchOutputModel>();
        }

        public string UpsertHourlyTdsConfiguration(HourlyTdsConfigurationUpsertInputModel hourlyTdsConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertHourlyTdsConfiguration", "PayRoll Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _payRollRepository.UpsertHourlyTdsConfiguration(hourlyTdsConfigurationUpsertInputModel, loggedInContext, validationMessages);
        }

        public List<DaysOfWeekConfigurationOutputModel> GetDaysOfWeekConfiguration(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDaysOfWeekConfiguration", "PayRoll Service"));

            var DaysOfWeekList = _payRollRepository.GetDaysOfWeekConfiguration(hourlyTdsConfigurationSearchInputModel, loggedInContext, validationMessages);

            if (DaysOfWeekList != null && DaysOfWeekList.Count > 0)
            {
                return DaysOfWeekList;
            }

            return new List<DaysOfWeekConfigurationOutputModel>();
        }

        public string UpsertDaysOfWeekConfiguration(UpsertDaysOfWeekConfigurationInputModel upsertDaysOfWeekConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDaysOfWeekConfiguration", "PayRoll Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            return _payRollRepository.UpsertDaysOfWeekConfiguration(upsertDaysOfWeekConfigurationInputModel, loggedInContext, validationMessages);
        }

        public List<AllowanceTimeSearchOutputModel> GetAllowanceTime(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllowanceTime", "PayRoll Service"));

            var allowanceList = _payRollRepository.GetAllowanceTime(hourlyTdsConfigurationSearchInputModel, loggedInContext, validationMessages);

            if (allowanceList != null && allowanceList.Count > 0)
            {
                return allowanceList;
            }

            return new List<AllowanceTimeSearchOutputModel>();
        }

        public string UpsertAllowanceTime(UpsertAllowanceTimeInputModel upsertAllowanceTimeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAllowanceTime", "PayRoll Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _payRollRepository.UpsertAllowanceTime(upsertAllowanceTimeInputModel, loggedInContext, validationMessages);
        }

        public List<ContractPayTypeModel> GetContractPayTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetContractPayTypes", "PayRoll Service"));
            LoggingManager.Debug(payRollTemplateSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollTemplatesCommandId, payRollTemplateSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ContractPayTypeModel> ContractPayTypes = _payRollRepository.GetContractPayTypes(payRollTemplateSearchInputModel, loggedInContext, validationMessages).ToList();
            return ContractPayTypes;
        }

        public Guid? UpsertContractPaySettings(ContractPaySettingsUpsertInputModel ContractPaySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(ContractPaySettingsUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertContractPaySettingsCommandId, ContractPaySettingsUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertContractPaySettingsValidation(ContractPaySettingsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            ContractPaySettingsUpsertInputModel.ContractPaySettingsId = _payRollRepository.UpsertContractPaySettings(ContractPaySettingsUpsertInputModel, loggedInContext, validationMessages);
            return ContractPaySettingsUpsertInputModel.ContractPaySettingsId;
        }
        public List<ContractPaySettingsSearchOutputModel> GetContractPaySettings(ContractPaySettingsSearchInputModel ContractPaySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetContractPaySettings", "PayRoll Service"));
            LoggingManager.Debug(ContractPaySettingsSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetContractPaySettingsCommandId, ContractPaySettingsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<ContractPaySettingsSearchOutputModel> ContractPaySettings = _payRollRepository.GetContractPaySettings(ContractPaySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
            return ContractPaySettings;
        }

        public List<PartsOfDayModel> GetPartsOfDays(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPartsOfDays", "PayRoll Service"));
            LoggingManager.Debug(payRollTemplateSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollTemplatesCommandId, payRollTemplateSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<PartsOfDayModel> PartsOfDays = _payRollRepository.GetPartsOfDays(payRollTemplateSearchInputModel, loggedInContext, validationMessages).ToList();
            return PartsOfDays;
        }

        public Guid? UpsertEmployeeLoan(EmployeeLoanUpsertInputModel EmployeeLoanUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(EmployeeLoanUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeLoanCommandId, EmployeeLoanUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertEmployeeLoanValidation(EmployeeLoanUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            EmployeeLoanUpsertInputModel.EmployeeLoanId = _payRollRepository.UpsertEmployeeLoan(EmployeeLoanUpsertInputModel, loggedInContext, validationMessages);

            if (EmployeeLoanUpsertInputModel.EmployeeLoanId != null && EmployeeLoanUpsertInputModel.IsApproved == true)
            {
                _payRollRepository.EmployeeLoanCalulations(EmployeeLoanUpsertInputModel.EmployeeLoanId, loggedInContext, validationMessages);
            }

            return EmployeeLoanUpsertInputModel.EmployeeLoanId;
        }
        public List<EmployeeLoanSearchOutputModel> GetEmployeeLoans(EmployeeLoanSearchInputModel EmployeeLoanSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeLoan", "PayRoll Service"));
            LoggingManager.Debug(EmployeeLoanSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetEmployeeLoansCommandId, EmployeeLoanSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<EmployeeLoanSearchOutputModel> EmployeeLoan = _payRollRepository.GetEmployeeLoans(EmployeeLoanSearchInputModel, loggedInContext, validationMessages).ToList();
            return EmployeeLoan;
        }

        public List<LoanTypeModel> GetLoanTypes(PayRollTemplateSearchInputModel payRollTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLoanTypes", "PayRoll Service"));
            LoggingManager.Debug(payRollTemplateSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetLoanTypesCommandId, payRollTemplateSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<LoanTypeModel> LoanTypes = _payRollRepository.GetLoanTypes(payRollTemplateSearchInputModel, loggedInContext, validationMessages).ToList();
            return LoanTypes;
        }

        public List<EmployeeLoanInstallmentOutputModel> GetEmployeeLoanInstallment(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeLoanInstallment", "PayRoll Service"));
            LoggingManager.Debug(hourlyTdsConfigurationSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollTemplatesCommandId, hourlyTdsConfigurationSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<EmployeeLoanInstallmentOutputModel> value = _payRollRepository.GetEmployeeLoanInstallment(hourlyTdsConfigurationSearchInputModel, loggedInContext, validationMessages);
            return value;
        }

        public Guid? UpsertEmployeeLoanInstallment(EmployeeLoanInstallmentInputModel employeeLoanInstallmentInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Employee Loan Installment", "PayRoll Service"));
            LoggingManager.Debug(employeeLoanInstallmentInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeLoanCommandId, employeeLoanInstallmentInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var value = _payRollRepository.UpsertEmployeeLoanInstallment(employeeLoanInstallmentInputModel, loggedInContext, validationMessages);

            if (value != null)
            {
                _payRollRepository.EmployeeLoanInstallmentCalulations(value, loggedInContext, validationMessages);
            }

            return null;
        }

        public Guid? FinalPayRollRun(PayrollRun payrollRun, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmployeePayrollConfiguration", "PayRoll Service"));

            var result = _payRollRepository.FinalPayRollRun(payrollRun, loggedInContext, validationMessages);

            return result;
        }

        public List<PayrollRunOutPutModel> GetPayRollRunEmployeeLeaveDetailsList(Guid? payRollRunId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollRunEmployeeLeaveDetailsList", "PayRoll Service"));

            var result = _payRollRepository.GetPayRollRunEmployeeLeaveDetailsList(payRollRunId, loggedInContext, validationMessages);

            return result;
        }

        public List<EmployeeLoanInstallmentOutputModel> GetEmployeeLoanStatementDetails(Guid? employeeId, Guid? employeeloanId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollRunEmployeeLeaveDetailsList", "PayRoll Service"));

            var result = _payRollRepository.GetEmployeeLoanStatementDetails(employeeId, employeeloanId, loggedInContext, validationMessages);

            return result;
        }

        public Guid? UpsertPayRollRunEmployeeComponent(PayRollRunEmployeeComponentUpsertInputModel PayRollRunEmployeeComponentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayRollRunEmployeeComponent", "PayRoll Service"));
            LoggingManager.Debug(PayRollRunEmployeeComponentUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertPayRollRunEmployeeComponentCommandId, PayRollRunEmployeeComponentUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertPayRollRunEmployeeComponentValidation(PayRollRunEmployeeComponentUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (PayRollRunEmployeeComponentUpsertInputModel.AddOrUpdateComponent == true)
            {
                PayRollRunEmployeeComponentUpsertInputModel.PayRollRunEmployeeComponentId = _payRollRepository.UpsertPayRollRunEmployeeComponent(PayRollRunEmployeeComponentUpsertInputModel, loggedInContext, validationMessages);

            }

            if (PayRollRunEmployeeComponentUpsertInputModel.AddOrUpdateYtdComponent == true)
            {
                PayRollRunEmployeeComponentUpsertInputModel.PayRollRunEmployeeComponentYtdId = _payRollRepository.UpsertPayRollRunEmployeeComponentYTD(PayRollRunEmployeeComponentUpsertInputModel, loggedInContext, validationMessages);
            }
            return PayRollRunEmployeeComponentUpsertInputModel.PayRollRunEmployeeComponentId;
        }


        public string GetTakeHomeAmount(Guid? employeesalaryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeePFReport", "PayRoll Service"));

            LoggingManager.Debug(employeesalaryId.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            var result = _payRollRepository.GetTakeHomeAmount(employeesalaryId, loggedInContext, validationMessages);

            var amount = result?.ToString();

            return amount;
        }

        public string GetUserCountry(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeePFReport", "PayRoll Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            var result = _payRollRepository.GetUserCountry(loggedInContext, validationMessages);

            return result;
        }

        public List<RateTagOutputModel> GetRateTags(RateTagSearchCriteriaInputModel rateSheetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Rate Sheets", "rateSheetSearchCriteriaInputModel", rateSheetSearchCriteriaInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetAllRateTagsCommandId, rateSheetSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                rateSheetSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting rate tag list ");
            List<RateTagOutputModel> rateSheetList = _payRollRepository.GetRateTags(rateSheetSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            foreach (var item in rateSheetList)
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

            return rateSheetList;
        }

        public List<RateTagForOutputModel> GetRateTagForNames(RateTagForSearchCriteriaInputModel rateSheetForSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Rate Sheet for", "rateSheetSearchCriteriaInputModel", rateSheetForSearchCriteriaInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetAllRateTagForCommandId, rateSheetForSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                rateSheetForSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting rate tag for list ");
            List<RateTagForOutputModel> rateSheetForList = _payRollRepository.GetRateTagForNames(rateSheetForSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return rateSheetForList;
        }

        public Guid? UpsertRateTag(RateTagInputModel rateSheetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertRateTag", "Master Data Management Service"));

            LoggingManager.Debug(rateSheetInputModel.ToString());

            if (!PayRollValidationHelper.UpsertRateTagValidation(rateSheetInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if (rateSheetInputModel.RateTagForIds != null)
            {
                rateSheetInputModel.RateTagForIdsXml = Utilities.ConvertIntoListXml(rateSheetInputModel.RateTagForIds);
            }

            rateSheetInputModel.RateTagId = _payRollRepository.UpsertRateTag(rateSheetInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertRateTagCommandId, rateSheetInputModel, loggedInContext);

            LoggingManager.Debug(rateSheetInputModel.RateTagId?.ToString());

            return rateSheetInputModel.RateTagId;
        }

        public Guid? InsertEmployeeRateTagDetails(EmployeeRateTagDetailsAddInputModel employeeRateTagDetailsAddInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeSalaryDetails", "employeeRateTagDetailsAddInputModel", employeeRateTagDetailsAddInputModel, "HrManagement Service"));

            if (employeeRateTagDetailsAddInputModel.IsClearCustomize != true)
            {
                if (!PayRollValidationHelper.InsertEmployeeRateTagDetailsValidation(employeeRateTagDetailsAddInputModel, loggedInContext,
                validationMessages))
                {
                    return null;
                }
                employeeRateTagDetailsAddInputModel.EmployeeRateTagDetailsString = JsonConvert.SerializeObject(employeeRateTagDetailsAddInputModel.RateTagDetails);
            }

            Guid? employeeRateTagId = _payRollRepository.InsertRateTagDetails(employeeRateTagDetailsAddInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee Salary Details with the id " + employeeRateTagId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeSalaryDetailsCommandId, employeeRateTagDetailsAddInputModel, loggedInContext);
            return employeeRateTagId;
        }

        public Guid? UpdateEmployeeRateTagDetails(EmployeeRateTagDetailsEditInputModel employeeRateTagDetailsEditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeSalaryDetails", "employeeRateTagDetailsAddInputModel", employeeRateTagDetailsEditInputModel, "HrManagement Service"));

            if (!PayRollValidationHelper.UpdateEmployeeRateTagDetailsValidation(employeeRateTagDetailsEditInputModel, loggedInContext,
            validationMessages))
            {
                return null;
            }
            Guid? employeeRateTagId = _payRollRepository.UpdateRateTagDetails(employeeRateTagDetailsEditInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Employee Salary Details with the id " + employeeRateTagId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeSalaryDetailsCommandId, employeeRateTagDetailsEditInputModel, loggedInContext);
            return employeeRateTagId;
        }

        public EmployeeRateTagDetailsApiReturnModel SearchEmployeeRateTagDetails(EmployeeRateTagDetailsInputModel getEmployeeRateTagDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "getEmployeeRateTagDetailsInputModel", "EmployeeId", getEmployeeRateTagDetailsInputModel.EmployeeId, "HrManagement Service"));

            if (!PayRollValidationHelper.ValidateEmployeeRateTagById(getEmployeeRateTagDetailsInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            EmployeeRateTagDetailsApiReturnModel employeeRateTagDetailsApiReturnModel = _payRollRepository.GetEmployeeRateTagDetailsById(getEmployeeRateTagDetailsInputModel, loggedInContext, validationMessages).FirstOrDefault();

            _auditService.SaveAudit(AppCommandConstants.SearchEmployeeRateTagDetailsCommandId, getEmployeeRateTagDetailsInputModel, loggedInContext);
            return employeeRateTagDetailsApiReturnModel;
        }

        public List<RateTagAllowanceTimeSearchOutputModel> GetRateTagAllowanceTime(HourlyTdsConfigurationSearchInputModel hourlyTdsConfigurationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRateTagAllowanceTime", "PayRoll Service"));

            var allowanceList = _payRollRepository.GetRateTagAllowanceTime(hourlyTdsConfigurationSearchInputModel, loggedInContext, validationMessages);

            if (allowanceList != null && allowanceList.Count > 0)
            {
                return allowanceList;
            }

            return new List<RateTagAllowanceTimeSearchOutputModel>();
        }

        public string UpsertRateTagAllowanceTime(UpsertRateTagAllowanceTimeInputModel upsertRateTagAllowanceTimeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertRateTagAllowanceTime", "PayRoll Service"));
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            if (upsertRateTagAllowanceTimeInputModel.AllowanceRateTagForIds != null)
            {
                upsertRateTagAllowanceTimeInputModel.AllowanceRateTagForIdsXml = Utilities.ConvertIntoListXml(upsertRateTagAllowanceTimeInputModel.AllowanceRateTagForIds);
            }

            return _payRollRepository.UpsertRateTagAllowanceTime(upsertRateTagAllowanceTimeInputModel, loggedInContext, validationMessages);
        }

        public Guid? UpsertPartsOfDay(PartsOfDayUpsertInputModel PartsOfDayUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(PartsOfDayUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertPartsOfDayCommandId, PartsOfDayUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertPartsOfDayValidation(PartsOfDayUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            PartsOfDayUpsertInputModel.PartsOfDayId = _payRollRepository.UpsertPartsOfDay(PartsOfDayUpsertInputModel, loggedInContext, validationMessages);
            return PartsOfDayUpsertInputModel.PartsOfDayId;
        }

        public List<BankModel> GetBanks(BankSearchInputModel bankSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBanks", "PayRoll Service"));
            LoggingManager.Debug(bankSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollTemplatesCommandId, bankSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<BankModel> banklist = _payRollRepository.GetBanks(bankSearchInputModel, loggedInContext, validationMessages).ToList();
            return banklist;
        }

        public Guid? InsertRateTagConfigurations(RateTagConfigurationAddInputModel rateTagConfigurationAddInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeSalaryDetails", "rateTagConfigurationsAddInputModel", rateTagConfigurationAddInputModel, "PayRoll Service"));
            if (!PayRollValidationHelper.InsertRateTagConfigurationsValidation(rateTagConfigurationAddInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }
            rateTagConfigurationAddInputModel.RateTagConfigurationString = JsonConvert.SerializeObject(rateTagConfigurationAddInputModel.RateTagDetails);
            Guid? rateTagConfigurationId = _payRollRepository.InsertRateTagConfigurations(rateTagConfigurationAddInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Rate tag configurations with the id " + rateTagConfigurationId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeSalaryDetailsCommandId, rateTagConfigurationAddInputModel, loggedInContext);
            return rateTagConfigurationId;
        }

        public Guid? UpdateRateTagConfiguration(RateTagConfigurationEditInputModel rateTagConfigurationEditInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateRateTagConfigurations", "rateTagConfigurationsAddInputModel", rateTagConfigurationEditInputModel, "PayRoll Service"));
            if (!PayRollValidationHelper.UpdateRateTagConfigurationValidation(rateTagConfigurationEditInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            Guid? rateTagConfigurationId = _payRollRepository.UpdateRateTagConfiguration(rateTagConfigurationEditInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Rate tag configurations with the id " + rateTagConfigurationId);
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeeSalaryDetailsCommandId, rateTagConfigurationEditInputModel, loggedInContext);
            return rateTagConfigurationId;
        }

        public List<RateTagConfigurationsApiReturnModel> GetRateTagConfigurations(RateTagConfigurationsInputModel rateTagConfigurationsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetRateTagConfigurations", "getRateTagConfigurationInputModel", rateTagConfigurationsInputModel, "PayRoll Service"));

            List<RateTagConfigurationsApiReturnModel> rateTagsList = _payRollRepository.GetRateTagConfigurations(rateTagConfigurationsInputModel, loggedInContext, validationMessages).ToList();

            foreach (var item in rateTagsList)
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

            _auditService.SaveAudit(AppCommandConstants.GetRateTagConfigurationCommandId, rateTagConfigurationsInputModel, loggedInContext);
            return rateTagsList;
        }

        public Guid? ArchivePayRoll(PayRollRunArchiveInputModel payRollRunArchiveInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ArchivePayRoll", "PayRoll Service"));
            LoggingManager.Debug(payRollRunArchiveInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.ArchivePayRollCommandId, payRollRunArchiveInputModel, loggedInContext);
            var result = _payRollRepository.ArchivePayRoll(payRollRunArchiveInputModel, loggedInContext, validationMessages);
            return result;
        }

        public Guid? UpsertRateTagRoleBranchConfiguration(RateTagRoleBranchConfigurationUpsertInputModel payRollBranchConfigurationUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertRateTagRoleBranchConfiguration", "PayRoll Service"));
            LoggingManager.Debug(payRollBranchConfigurationUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertRateTagRoleBranchConfigurationCommandId, payRollBranchConfigurationUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertRateTagRoleBranchConfigurationValidation(payRollBranchConfigurationUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            payRollBranchConfigurationUpsertInputModel.RateTagRoleBranchConfigurationId = _payRollRepository.UpsertRateTagRoleBranchConfiguration(payRollBranchConfigurationUpsertInputModel, loggedInContext, validationMessages);
            return payRollBranchConfigurationUpsertInputModel.RateTagRoleBranchConfigurationId;
        }

        public List<RateTagRoleBranchConfigurationApiReturnModel> GetRateTagRoleBranchConfigurations(RateTagRoleBranchConfigurationInputModel rateTagRoleBranchConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetRateTagRoleBranchConfigurations", "getRateTagConfigurationInputModel", rateTagRoleBranchConfigurationInputModel, "PayRoll Service"));

            List<RateTagRoleBranchConfigurationApiReturnModel> result = _payRollRepository.GetRateTagRoleBranchConfigurations(rateTagRoleBranchConfigurationInputModel, loggedInContext, validationMessages).ToList();

            _auditService.SaveAudit(AppCommandConstants.GetRateTagConfigurationCommandId, rateTagRoleBranchConfigurationInputModel, loggedInContext);
            return result;
        }

        public Guid? UpsertBank(BankUpsertInputModel bankUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertBank", "PayRoll Service"));
            LoggingManager.Debug(bankUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertBankCommandId, bankUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertBankValidation(bankUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            bankUpsertInputModel.BankId = _payRollRepository.UpsertBank(bankUpsertInputModel, loggedInContext, validationMessages);
            return bankUpsertInputModel.BankId;
        }

        public Guid? UpsertPayRollBands(PayRollBandsUpsertInputModel payRollBandsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(payRollBandsUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertPayRollBandCommandId, payRollBandsUpsertInputModel, loggedInContext);
            payRollBandsUpsertInputModel.PayRollBandId = _payRollRepository.UpsertPayRollBands(payRollBandsUpsertInputModel, loggedInContext, validationMessages);
            return payRollBandsUpsertInputModel.PayRollBandId;
        }

        public List<PayRollBandsSearchOutputModel> GetPayRollBands(PayRollBandsSearchInputModel payRollComponentSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPayRollBands", "PayRoll Service"));
            LoggingManager.Debug(payRollComponentSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollBandsCommandId, payRollComponentSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<PayRollBandsSearchOutputModel> payRollComponent = _payRollRepository.GetPayRollBands(payRollComponentSearchInputModel, loggedInContext, validationMessages).ToList();
            return payRollComponent;
        }

        public Guid? UpsertEmployeePreviousCompanyTax(EmployeePreviousCompanyTaxUpsertInputModel EmployeePreviousCompanyTaxUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert PayRoll Component", "PayRoll Service"));
            LoggingManager.Debug(EmployeePreviousCompanyTaxUpsertInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.UpsertEmployeePreviousCompanyTaxCommandId, EmployeePreviousCompanyTaxUpsertInputModel, loggedInContext);
            if (!PayRollValidationHelper.UpsertEmployeePreviousCompanyTaxValidation(EmployeePreviousCompanyTaxUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            EmployeePreviousCompanyTaxUpsertInputModel.EmployeePreviousCompanyTaxId = _payRollRepository.UpsertEmployeePreviousCompanyTax(EmployeePreviousCompanyTaxUpsertInputModel, loggedInContext, validationMessages);
            return EmployeePreviousCompanyTaxUpsertInputModel.EmployeePreviousCompanyTaxId;
        }
        public List<EmployeePreviousCompanyTaxSearchOutputModel> GetEmployeePreviousCompanyTaxes(EmployeePreviousCompanyTaxSearchInputModel EmployeePreviousCompanyTaxSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeePreviousCompanyTax", "PayRoll Service"));
            LoggingManager.Debug(EmployeePreviousCompanyTaxSearchInputModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetEmployeePreviousCompanyTaxCommandId, EmployeePreviousCompanyTaxSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<EmployeePreviousCompanyTaxSearchOutputModel> employeePreviousCompanyTaxes = _payRollRepository.GetEmployeePreviousCompanyTaxes(EmployeePreviousCompanyTaxSearchInputModel, loggedInContext, validationMessages).ToList();
            return employeePreviousCompanyTaxes;
        }

        public List<TaxCalculationTypeModel> GetTaxCalculationTypes(TaxCalculationTypeModel taxCalculationTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTaxCalculationTypes", "PayRoll Service"));
            LoggingManager.Debug(taxCalculationTypeModel.ToString());
            _auditService.SaveAudit(AppCommandConstants.GetPayRollTemplatesCommandId, taxCalculationTypeModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            List<TaxCalculationTypeModel> TaxCalculationTypes = _payRollRepository.GetTaxCalculationTypes(taxCalculationTypeModel, loggedInContext, validationMessages).ToList();
            return TaxCalculationTypes;
        }

        public List<EmployeeRateTagConfigurationApiReturnModel> GetEmployeeRateTagConfigurations(EmployeeRateTagConfigurationInputModel EmployeeRateTagConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeRateTagConfigurations", "getRateTagConfigurationInputModel", EmployeeRateTagConfigurationInputModel, "PayRoll Service"));

            List<EmployeeRateTagConfigurationApiReturnModel> result = _payRollRepository.GetEmployeeRateTagConfigurations(EmployeeRateTagConfigurationInputModel, loggedInContext, validationMessages).ToList();

            _auditService.SaveAudit(AppCommandConstants.GetRateTagConfigurationCommandId, EmployeeRateTagConfigurationInputModel, loggedInContext);
            return result;
        }
    }
}