using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Dashboard;
using Btrak.Models.User;
using Btrak.Services.Audit;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.Dashboard;
using BTrak.Common;
using Btrak.Models.BillingManagement;
using Btrak.Services.BillingManagement;
using Btrak.Models.SystemManagement;
using System.Web;
using Btrak.Models.MasterData;
using Btrak.Services.Chromium;
using Btrak.Dapper.Dal.Partial;
using Btrak.Services.Trading;
using Microsoft.WindowsAzure.Storage.Blob;
using System.Net;
using System.IO;
using Btrak.Services.Email;

namespace Btrak.Services.Dashboard
{
    public class ProcessDashboardService : IProcessDashboardService
    {
        private readonly ProcessDashboardRepository _processDashboardRepository;
        private readonly IAuditService _auditService;
        private readonly UserRepository _userRepository;
        private readonly ClientRepository _clientRepository;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IClientService _clientService;
        private readonly IChromiumService _chromiumService;
        private readonly ITradingService _tradingService;
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly IEmailService _emailService;


        public ProcessDashboardService(ProcessDashboardRepository processDashboardRepository, IAuditService auditService,
            UserRepository userRepository, ICompanyStructureService companyStructureService,ClientRepository clientRepository
            ,IClientService clientService,IChromiumService chromiumService, MasterDataManagementRepository masterDataManagementRepository,
            ITradingService tradingService,IEmailService emailService)
        {
            _processDashboardRepository = processDashboardRepository;
            _auditService = auditService;
            _userRepository = userRepository;
            _companyStructureService = companyStructureService;
            _clientRepository = clientRepository;
            _clientService = clientService;
            _chromiumService = chromiumService;
            _masterDataManagementRepository = masterDataManagementRepository;
            _tradingService = tradingService;
            _emailService = emailService;
        }

        public List<ProcessDashboardApiReturnModel> SearchOnboardedGoals(string statusColor,Guid? entityId, Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchOnboardedGoals", "Process Dashboard Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(statusColor);


            List<ProcessDashboardApiReturnModel> processDashboardApiReturnModels = _processDashboardRepository.SearchOnboardedGoals(statusColor, entityId, projectId, loggedInContext, validationMessages).ToList();

            
            return processDashboardApiReturnModels;
        }

        public int? GetLatestDashboardNumber(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLatestDashboardNumber", "Process Dashboard Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            int? dashboardNumber = _processDashboardRepository.GetLatestDashboardNumber(loggedInContext, validationMessages);

            return dashboardNumber;
        }

        public int? UpsertProcessDashboard(List<ProcessDashboardUpsertInputModel> processDashboardUpsertInputModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            string processDashboardXml = null;

            if (processDashboardUpsertInputModels != null && processDashboardUpsertInputModels.Count > 0)
            {
                processDashboardXml = Utilities.GetXmlFromObject(processDashboardUpsertInputModels);
            }

            if (processDashboardUpsertInputModels == null || processDashboardUpsertInputModels.Count <= 0)
            {
                var snapshotDashboardId = _processDashboardRepository.UpsertProcessDashboard(null, loggedInContext, validationMessages);

                if (snapshotDashboardId != 0)
                {
                    LoggingManager.Debug("Snapshot process dashboard for the dashboard id = " + snapshotDashboardId + " has been created.");

                    _auditService.SaveAudit(AppCommandConstants.UpsertProcessDashboardCommandId, processDashboardUpsertInputModels, loggedInContext);

                    return snapshotDashboardId;
                }

                throw new Exception(ValidationMessages.ExceptionProcessDashboardCouldNotBeCreated);
            }

            int? dashboardId = _processDashboardRepository.UpsertProcessDashboard(processDashboardXml, loggedInContext, validationMessages);

            LoggingManager.Debug("Updated process dashboard and new process dashboard for the dashboard id = " + dashboardId + " has been created.");

            _auditService.SaveAudit(AppCommandConstants.UpsertProcessDashboardCommandId, processDashboardXml, loggedInContext);

            return dashboardId;
        }

        public List<ProcessDashboardApiReturnModel> GetGoalsOverAllStatusByDashboardId(int? dashboardId, Guid? entityId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGoalsOverAllStatusByDashboardId", "ProcessDashboard Service"));

            if (!ProcessDashboardValidations.ValidateGoalsOverAllStatusByDashboardId(dashboardId, loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(dashboardId?.ToString());

            List<ProcessDashboardApiReturnModel> processDashboardApiReturnModels = _processDashboardRepository.GetGoalsOverAllStatusByDashboardId(dashboardId, null, entityId , loggedInContext, validationMessages);

            return processDashboardApiReturnModels;
        }

        public List<ProcessDashboardApiReturnModel> GetProcessDashboardByProjectId(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetProcessDashboardByProjectId", "ProcessDashboard Service and logged details=" + loggedInContext));

            LoggingManager.Debug(projectId.ToString());

            if (!ProcessDashboardValidations.ValidateGetProcessDashboardByProjectId(projectId, loggedInContext, validationMessages))
            {
                return null;
            }

            List<ProcessDashboardApiReturnModel> processDashboardApiReturnModels = _processDashboardRepository.GetGoalsOverAllStatusByDashboardId(null, projectId, null, loggedInContext, validationMessages);

            return processDashboardApiReturnModels;
        }

        public string ShareDashboardsPdf(WidgetInputModel widgetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<ProcessDashboardApiReturnModel> processDashboardApiReturnModels = new List<ProcessDashboardApiReturnModel>();
            if (!CommonValidationHelper.ValidateDynamicField(widgetInputModel.UserIds != null && widgetInputModel.UserIds.Count > 0 ?
                widgetInputModel.UserIds.ToString() :null , "UserIds", loggedInContext, validationMessages))
            {
                return null;
            }
            foreach (var userId in widgetInputModel.UserIds)
            {
                var clientData = _clientRepository.GetClientByUserId(null, userId, loggedInContext, validationMessages, null);
                var clientId = clientData != null ? clientData.ClientId : new Guid("54e16782-1459-4b3c-bcc7-383e0bbb3f9e");
                SendDashBoardWidgetInformationToUser(widgetInputModel, userId,clientId, loggedInContext,validationMessages);
            }
            return null;
        }
        public async void SendDashBoardWidgetInformationToUser(WidgetInputModel widgetInputModel,Guid? userId,Guid? clientId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                List<UserOutputModel> usersList = _userRepository.GetUserDetailsAndCountry(userId, loggedInContext, validationMessages);
                CompanyThemeModel companyTheme = _companyStructureService.GetCompanyTheme(loggedInContext?.LoggedInUserId);
                var CompanyLogo = companyTheme.CompanyMainLogo != null ? companyTheme.CompanyMainLogo : "http://todaywalkins.com/Comp_images/Snovasys.png";
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DashboardWidgetTemplate", "ProcessDashboard Service"));
                {
                    var toEmails = usersList[0].Email.Trim().Split('\n');
                    var mobileNo = usersList[0].CountryCode + usersList[0].MobileNo;
                    var siteDomain = ConfigurationManager.AppSettings["SiteUrl"];
                    var RouteAddress = siteDomain + "/trading/viewcontract/" + widgetInputModel.WidgetId + "/sales-contract";
                    var messageBody = "Dashboard widget information";
                    EmailTemplateModel EmailTemplateModel = new EmailTemplateModel
                    {
                        ClientId = clientId,
                        EmailTemplateName = "DashboardWidgetPdfTemplate"
                    };
                    var template = _clientService.GetAllEmailTemplates(EmailTemplateModel, loggedInContext, validationMessages).ToList()[0];
                    var html = template.EmailTemplate.Replace("##WidgetHtmlData##", widgetInputModel.WidgetHtmlCode);
                    var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
                    companySettingsSearchInputModel.CompanyId = loggedInContext.CompanyGuid;
                    companySettingsSearchInputModel.IsSystemApp = null;
                    string storageAccountName = string.Empty;

                    var PdfOutput = await _chromiumService.GenerateExecutionPdf(html, null, "WidgetInformation").ConfigureAwait(false);

                    List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
                    if (companySettings.Count > 0)
                    {
                        var storageAccountDetails = companySettings.Where(x => x.Key == "StorageAccountName").FirstOrDefault();
                        storageAccountName = storageAccountDetails?.Value;
                    }
                    CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                    var directory = _tradingService.SetupCompanyFileContainer(companyModel, 6, loggedInContext.LoggedInUserId, storageAccountName);

                    var ContractFileName = "WidgetInformation";

                    var fileExtension = ".pdf";

                    var ContractConvertedFileName = ContractFileName + fileExtension;

                    CloudBlockBlob ContractConvertedBlockBlob = directory.GetBlockBlobReference(ContractConvertedFileName);

                    ContractConvertedBlockBlob.Properties.CacheControl = "public, max-age=2592000";

                    ContractConvertedBlockBlob.Properties.ContentType = "application/pdf";

                    Byte[] ContractBytes = PdfOutput.ByteStream;

                    ContractConvertedBlockBlob.UploadFromByteArray(ContractBytes, 0, ContractBytes.Length);

                    var invoicePdfUrl = ContractConvertedBlockBlob.Uri.AbsoluteUri;
                    var webClient = new WebClient();
                    byte[] fileBytes = webClient.DownloadData(invoicePdfUrl);
                    Stream stream = new MemoryStream(fileBytes);
                    List<StreamWithType> fileStream = new List<StreamWithType>();
                    fileStream.Add(new StreamWithType() { FileStream = stream, FileName = "WidgetInformation", FileType = ".pdf", IsPdf = true });
                    EmailTemplateModel EmailTemplateModel1 = new EmailTemplateModel
                    {
                        ClientId = clientId,
                        EmailTemplateName = "DashboardWidgetTemplate"
                    };
                    var template1 = _clientService.GetAllEmailTemplates(EmailTemplateModel1, loggedInContext, validationMessages).ToList()[0];
                    var html1 = template1.EmailTemplate.Replace("##siteUrl##", RouteAddress)
                        .Replace("##CompanyLogo##", CompanyLogo);
                    SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);
                    TaskWrapper.ExecuteFunctionInNewThread(() =>
                    {
                        EmailGenericModel emailModel = new EmailGenericModel
                        {
                            SmtpServer = smtpDetails?.SmtpServer,
                            SmtpServerPort = smtpDetails?.SmtpServerPort,
                            SmtpMail = smtpDetails?.SmtpMail,
                            SmtpPassword = smtpDetails?.SmtpPassword,
                            ToAddresses = toEmails,
                            HtmlContent = html1,
                            Subject = null,
                            MailAttachments = null,
                            MailAttachmentsWithFileType= fileStream,
                            IsPdf = true
                        };
                        _emailService.SendMail(loggedInContext, emailModel);
                        _emailService.SendSMS(mobileNo, messageBody, loggedInContext);
                    });
                }
            }
            catch(Exception exception)
            {
                LoggingManager.Error(exception);
            }
        }

        public string UpsertModuleTabsData(List<ModuleTabModel> moduleTabModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (!CommonValidationHelper.ValidateDynamicField(moduleTabModels != null?
                moduleTabModels.ToString() : null, "Tabs", loggedInContext, validationMessages))
            {
                return null;
            }
            foreach (var moduleTab in moduleTabModels)
            {
                moduleTab.IsUpsert = true;
                _processDashboardRepository.UpsertModuleTabsData(moduleTab, loggedInContext, validationMessages);
            }
            return null;
        }

        public List<ModuleTabModel> GetModuleTabs(Guid? moduleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (!CommonValidationHelper.ValidateDynamicField(moduleId != null && moduleId != Guid.Empty ?
                moduleId.ToString() : null, "ModuleId", loggedInContext, validationMessages))
            {
                return null;
            }
            ModuleTabModel moduleTabModel = new ModuleTabModel()
            {
                ModuleId = moduleId,
                IsUpsert = false
            };
            return _processDashboardRepository.UpsertModuleTabsData(moduleTabModel, loggedInContext, validationMessages);
        }
    }
}