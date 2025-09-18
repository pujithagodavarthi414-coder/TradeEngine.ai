using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.CompanyStructureValidationHelpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Hangfire;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models.Widgets;
using System.Configuration;
using Btrak.Services.Email;
using Btrak.Models.MasterData;
using BusinessView.Common;
using Newtonsoft.Json;
using JsonDeserialiseData = BTrak.Common.JsonDeserialiseData;

namespace Btrak.Services.CompanyStructure
{
    public class CompanyStructureService : ICompanyStructureService
    {
        private readonly CompanyStructureRepository _companyStructureRepository;
        private readonly IAuditService _auditService;
        private readonly WidgetRepository _widgetRepository = new WidgetRepository();
        private readonly GoalRepository _goalRepository = new GoalRepository();
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly RoleRepository _roleRepository;
        private readonly IEmailService _emailService;
        public CompanyStructureService(CompanyStructureRepository companyStructureRepository, IEmailService emailService, IAuditService auditService, MasterDataManagementRepository masterDataManagementRepository, RoleRepository roleRepository)
        {
            _companyStructureRepository = companyStructureRepository;
            _auditService = auditService;
            _emailService = emailService;
            _masterDataManagementRepository = masterDataManagementRepository;
            _roleRepository = roleRepository;
        }

        public List<CompanyStructureOutputModel> SearchIndustries(CompanyStructureSearchCriteriaInputModel companyStructureSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchIndustries", "companyStructureSearchCriteriaInputModel", companyStructureSearchCriteriaInputModel, "CompanyStructure Api"));
            if (!CommonValidationHelper.ValidateSearchCriteriaForAllowAnonymous(companyStructureSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Industries list ");
            List<CompanyStructureOutputModel> industriesList = _companyStructureRepository.SearchCompanyStructure(companyStructureSearchCriteriaInputModel, validationMessages).ToList();
            return industriesList;
        }

        public CompanyStructureOutputModel GetIndustryById(Guid? industryId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetIndustryById", "industryId", industryId, "CompanyStructureService"));
            if (!CompanyStructureValidationHelper.GetIndustryByIdValidation(industryId, validationMessages))
            {
                return null;
            }

            CompanyStructureSearchCriteriaInputModel searchCriteriaModel = new CompanyStructureSearchCriteriaInputModel { IndustryId = industryId };
            LoggingManager.Debug("Getting Industry Detail by Id ");
            CompanyStructureOutputModel industryList = _companyStructureRepository.SearchCompanyStructure(searchCriteriaModel, validationMessages).FirstOrDefault();
            return industryList;
        }

        public List<MainUseCaseOutputModel> SearchMainUseCases(MainUseCaseSearchCriteriaInputModel mainUseCaseSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchMainUseCases", "mainUseCaseSearchCriteriaInputModel", mainUseCaseSearchCriteriaInputModel, "CompanyStructure Api"));
            if (!CommonValidationHelper.ValidateSearchCriteriaForAllowAnonymous(mainUseCaseSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting MainUseCase list ");
            List<MainUseCaseOutputModel> mainUseCaseList = _companyStructureRepository.SearchMainUseCases(mainUseCaseSearchCriteriaInputModel, validationMessages).ToList();
            return mainUseCaseList;
        }

        public MainUseCaseOutputModel GetMainUseCaseById(Guid? mainUseCaseId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMainUseCaseById", "mainUseCaseId", mainUseCaseId, "CompanyStructureService"));
            if (!CompanyStructureValidationHelper.GetMainUseCaseByIdValidation(mainUseCaseId, validationMessages))
            {
                return null;
            }

            MainUseCaseSearchCriteriaInputModel searchCriteriaModel = new MainUseCaseSearchCriteriaInputModel { MainUseCaseId = mainUseCaseId };
            LoggingManager.Info("Getting MainUseCase Detail by Id ");
            MainUseCaseOutputModel industryList = _companyStructureRepository.SearchMainUseCases(searchCriteriaModel, validationMessages).FirstOrDefault();
            return industryList;
        }

        public Guid? UpsertIndustryModule(IndustryModuleInputModel industryModuleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertIndustryModule", "industryModuleInputModel", industryModuleInputModel, "CompanyStructure Service"));
            if (!CompanyStructureValidationHelper.UpsertIndustryModuleValidation(industryModuleInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            industryModuleInputModel.IndustryModuleId = _companyStructureRepository.UpsertIndustryModule(industryModuleInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("IndustryModule with the id " + industryModuleInputModel.IndustryId);
            _auditService.SaveAudit(AppCommandConstants.UpsertIndustryModuleCommandId, industryModuleInputModel, loggedInContext);
            return industryModuleInputModel.IndustryModuleId;
        }

        public List<IndustryModuleOutputModel> SearchIndustryModule(IndustryModuleSearchCriteriaInputModel industryModuleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchIndustryModule", "industryModuleSearchCriteriaInputModel", industryModuleSearchCriteriaInputModel, "CompanyStructure Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchIndustryModuleCommandId, industryModuleSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                industryModuleSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting IndustryModule list ");
            List<IndustryModuleOutputModel> industryModuleList = _companyStructureRepository.SearchIndustryModule(industryModuleSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return industryModuleList;
        }

        public IndustryModuleOutputModel GetIndustryModuleById(Guid? industryModuleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetIndustryModuleById", "industryModuleId", industryModuleId, "CompanyStructureService"));
            _auditService.SaveAudit(AppCommandConstants.GetIndustryModuleByIdCommandId, industryModuleId, loggedInContext);
            if (!CompanyStructureValidationHelper.GetIndustryModuleByIdValidation(industryModuleId, loggedInContext,
                validationMessages))
            {
                return null;
            }

            IndustryModuleSearchCriteriaInputModel searchCriteriaModel = new IndustryModuleSearchCriteriaInputModel { IndustryModuleId = industryModuleId };
            LoggingManager.Info("Getting IndustryModule Detail by Id ");
            IndustryModuleOutputModel industryModuleList = _companyStructureRepository.SearchIndustryModule(searchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();
            return industryModuleList;
        }

        public List<NumberFormatOutputModel> SearchNumberFormats(NumberFormatSearchCriteriaInputModel numberFormatSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchNumberFormats", "numberFormatSearchCriteriaInputModel", numberFormatSearchCriteriaInputModel, "CompanyStructure Service"));

            if (!CommonValidationHelper.ValidateSearchCriteriaForAllowAnonymous(numberFormatSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Number Formats list ");
            List<NumberFormatOutputModel> numberFormatList = _companyStructureRepository.SearchNumberFormat(numberFormatSearchCriteriaInputModel, validationMessages).ToList();
            return numberFormatList;
        }

        public NumberFormatOutputModel GetNumberFormatById(Guid? numberFormatId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetNumberFormatById", "numberFormatId", numberFormatId, "CompanyStructureService"));

            if (!CompanyStructureValidationHelper.GetNumberFormatByIdValidation(numberFormatId, validationMessages))
            {
                return null;
            }

            NumberFormatSearchCriteriaInputModel searchCriteriaModel = new NumberFormatSearchCriteriaInputModel { NumberFormatId = numberFormatId };
            LoggingManager.Info("Getting NumberFormat Detail by Id ");
            NumberFormatOutputModel numberFormatModuleList = _companyStructureRepository.SearchNumberFormat(searchCriteriaModel, validationMessages).FirstOrDefault();
            return numberFormatModuleList;
        }

        public List<DateFormatOutputModel> SearchDateFormats(DateFormatSearchCriteriaInputModel dateFormatSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchDateFormats", "dateFormatSearchCriteriaInputModel", dateFormatSearchCriteriaInputModel, "CompanyStructure Service"));

            if (!CommonValidationHelper.ValidateSearchCriteriaForAllowAnonymous(dateFormatSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Date Format list ");
            List<DateFormatOutputModel> dateFormatList = _companyStructureRepository.SearchDateFormats(dateFormatSearchCriteriaInputModel, validationMessages).ToList();
            return dateFormatList;
        }

        public DateFormatOutputModel GetDateFormatById(Guid? dateFormatId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetDateFormatById", "dateFormatId", dateFormatId, "CompanyStructureService"));

            if (!CompanyStructureValidationHelper.GetDateFormatByIdValidation(dateFormatId, validationMessages))
            {
                return null;
            }

            DateFormatSearchCriteriaInputModel searchCriteriaModel = new DateFormatSearchCriteriaInputModel { DateFormatId = dateFormatId };
            LoggingManager.Info("Getting Date Format Detail by Id ");
            DateFormatOutputModel dateFormatModuleList = _companyStructureRepository.SearchDateFormats(searchCriteriaModel, validationMessages).FirstOrDefault();
            return dateFormatModuleList;
        }

        public List<TimeFormatOutputModel> SearchTimeFormats(TimeFormatSearchCriteriaInputModel timeFormatSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchTimeFormats", "timeFormatSearchCriteriaInputModel", timeFormatSearchCriteriaInputModel, "CompanyStructure Service"));

            if (!CommonValidationHelper.ValidateSearchCriteriaForAllowAnonymous(timeFormatSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Time Format list ");
            List<TimeFormatOutputModel> timeFormatList = _companyStructureRepository.SearchTimeFormats(timeFormatSearchCriteriaInputModel, validationMessages).ToList();
            return timeFormatList;
        }

        public TimeFormatOutputModel GetTimeFormatById(Guid? timeFormatId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTimeFormatById", "timeFormatId", timeFormatId, "CompanyStructureService"));

            if (!CompanyStructureValidationHelper.GetTimeFormatByIdValidation(timeFormatId, validationMessages))
            {
                return null;
            }

            TimeFormatSearchCriteriaInputModel searchCriteriaModel = new TimeFormatSearchCriteriaInputModel { TimeFormatId = timeFormatId };
            LoggingManager.Info("Getting Time Format Detail by Id ");
            TimeFormatOutputModel timeFormatModuleList = _companyStructureRepository.SearchTimeFormats(searchCriteriaModel, validationMessages).FirstOrDefault();
            return timeFormatModuleList;
        }

        public void CheckUpsertCompanyValidations(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "CheckUpsertCompanyValidations", "companyInputModel", companyInputModel, "CompanyStructure Service"));
            CompanyStructureValidationHelper.UpsertCompany(companyInputModel, validationMessages);

            if (validationMessages.Count == 0)
            {
                _companyStructureRepository.CheckUpsertCompanyValidations(companyInputModel, validationMessages);


                if (validationMessages.Count == 0)
                {
                    // companyInputModel.MainPassword = companyInputModel.Password;
                    LoggingManager.Debug("Password checking" + companyInputModel.MainPassword);
                    companyInputModel.Password = Utilities.GetSaltedPassword(companyInputModel.Password);

                }
            }
        }

        public Guid? UpsertCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyDetails", "loggedincontext", loggedInContext, "CompanyStructure Service"));

            Guid? companyId = _companyStructureRepository.UpsertComopanyDetails(companyInputModel, loggedInContext, validationMessages);

            return companyId;
        }

        public string UpdateCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyDetails", "loggedincontext", loggedInContext, "CompanyStructure Service"));

            string companyId = _companyStructureRepository.UpdateCompanyDetails(companyInputModel, loggedInContext, validationMessages);

            return companyId;
        }

        public CompanyOutputModel GetCompanyDetails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "CheckUpsertCompanyValidations", "loggedincontext", loggedInContext, "CompanyStructure Service"));

            var result = ApiWrapper.GetApiCallsWithAuthorisation(RouteConstants.ASCompanyDetails, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], new List<ParamsInputModel>(), loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);

            if (responseJson.Success) 
            {
                var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                var companyDetails = JsonConvert.DeserializeObject<CompanyOutputModel>(jsonResponse);
                //CompanyOutputModel companyDetails = _companyStructureRepository.GetCompanyDetails(loggedInContext, validationMessages);

                //if (validationMessages.Count() > 0)
                //{
                //    return null;
                //}
                return companyDetails;
            }
            else
            {
                if (responseJson?.ApiResponseMessages.Count > 0)
                {
                    var validationMessage = new ValidationMessage()
                    {
                        ValidationMessaage = responseJson.ApiResponseMessages[0].Message,
                        ValidationMessageType = MessageTypeEnum.Error,
                        Field = responseJson.ApiResponseMessages[0].FieldName
                    };
                    validationMessages.Add(validationMessage);
                }
                return null;
            }
        }

        public UpsertCompanyOutputModel UpsertCompany(LoggedInContext loggedInContext, CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompany", "companyInputModel", companyInputModel, "CompanyStructure Service"));
            companyInputModel.Password = Utilities.GetSaltedPassword(companyInputModel.Password);
            var roleList = _roleRepository.GetRolesFromAuthenticationServices(companyInputModel.CompanyAuthenticationId, validationMessages);
            if (roleList.Count > 0)
            {
                var roleListXml = Utilities.ConvertIntoListXml(roleList);
                companyInputModel.RoleListXml = roleListXml;
            }
            else
            {
                companyInputModel.RoleListXml = null;
            }
            UpsertCompanyOutputModel companyDetails = _companyStructureRepository.UpsertCompany(companyInputModel, validationMessages);

            if (!validationMessages.Any())
            {
                companyInputModel.CompanyId = companyDetails.CompanyId;
            }
            if (companyDetails != null)
            {
                loggedInContext = new LoggedInContext
                {
                    LoggedInUserId = (Guid)companyDetails.UserId,
                    CompanyGuid = (Guid)companyDetails.CompanyId
                };

                bool? isInsert = _companyStructureRepository.UpdateCompanySettings(companyInputModel, loggedInContext, validationMessages);

                SendCompanyInsertEmailToRegisteredEmailAddress(loggedInContext, companyInputModel, validationMessages);

                if (companyInputModel.CompanyId != null && companyInputModel.CompanyId != Guid.Empty)
                {
                    SendDemoDataEmailToRegisteredEmailAddress(loggedInContext, companyInputModel, validationMessages);
                }

                LoggingManager.Debug("Company with the id " + companyInputModel.CompanyId);
            }

            return companyDetails;
        }

        public void InsertCompanyTestData(UpsertCompanyOutputModel upsertCompanyOutputModel)
        {
            _companyStructureRepository.InsertCompanyTestData(upsertCompanyOutputModel, new List<ValidationMessage>());
        }

        private void SendDemoDataEmailToRegisteredEmailAddress(LoggedInContext loggedInContext, CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            var html = _goalRepository.GetHtmlTemplateByName("CompanyRegistrationDemoDataTemplate", loggedInContext.CompanyGuid).Replace("##ToName##", companyInputModel.FirstName);
            var toMails = companyInputModel.WorkEmail.Split('\n');
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpMail = null,
                SmtpPassword = null,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Snovasys Business Suite",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
        }

        private void SendCompanyInsertEmailToRegisteredEmailAddress(LoggedInContext loggedInContext, CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SendRemoteSiteEmailToRegisteredEmailAddress", "companyInputModel", companyInputModel, "Remote Site Mail"));

            var actvityLink = ConfigurationManager.AppSettings["ActivityTracker"];
            var webmessangerLink = ConfigurationManager.AppSettings["ChatApplicationWeb"];
            var mobileMsgLink = ConfigurationManager.AppSettings["ChatApplicationMobile"];
            var guideLink = ConfigurationManager.AppSettings["UserGuide"];
            var templateName = companyInputModel.RegistrationTemplateName ?? "CompanyRegistrationTemplate";
            CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
            {
                Key = "CompanySigninLogo",
                IsArchived = false
            };

            string mainLogo = (_masterDataManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);

            var CompanySigninLogo = companyInputModel.CompanySigninLogo ?? mainLogo;
            var footer = companyInputModel.MailFooterAddress;
            LoggingManager.Debug("Mial with the Password " + companyInputModel.MainPassword);
            var siteaddress = companyInputModel.SiteAddress + companyInputModel.SiteDomain;
            var html = _goalRepository.GetHtmlTemplateByName(templateName, loggedInContext.CompanyGuid).Replace("##ToName##", companyInputModel.FirstName).Replace("##userName##", companyInputModel.WorkEmail).Replace("##password##", companyInputModel.MainPassword).Replace("##siteAddress##", siteaddress).Replace("##trackerLink##", actvityLink).
                Replace("##chatApllication##", webmessangerLink).Replace("##mobileChat##", mobileMsgLink).Replace("##guidelink##", guideLink).Replace("##CompanyRegistrationLogo##", CompanySigninLogo);
            var toMails = companyInputModel.WorkEmail?.Split('\n');
            var bccMail = companyInputModel.BccEmail?.Split('\n');
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpMail = null,
                SmtpPassword = null,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Snovasys Remote Working Software",
                CCMails = null,
                BCCMails = bccMail,
                MailAttachments = null,
                IsPdf = null,
                FooterAddress = footer
            };
            _emailService.SendMail(loggedInContext, emailModel);
            LoggingManager.Debug("Mail sent successfully " + companyInputModel.MainPassword);

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendRemoteSiteEmailToRegisteredEmailAddress", "CompanyStructure service"));
        }


        public string SendEmailContact(SendMailInputModel sendMailInputModel)
        {
            var contactMail = ConfigurationManager.AppSettings["ContactMail"];
            var html = _goalRepository.GetHtmlTemplateByName("RemoteContactMailTemplate", null).Replace("##userName##", sendMailInputModel.PersonName).Replace("##phone##", sendMailInputModel.PhoneNumber).Replace("##description##", sendMailInputModel.Description).Replace("##company##", sendMailInputModel.CompanyName).Replace("##email##", sendMailInputModel.Email).Replace("##CompanyLogo##", sendMailInputModel.CompanyLogo);
            var toMails = contactMail.Split('\n');
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpMail = null,
                SmtpPassword = null,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Remote working software new customer message",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(new LoggedInContext(), emailModel);
            return null;
        }

        public string SendEmailOffer(SendMailInputModel sendMailInputModel, LoggedInContext loggedInContext)
        {
            var contactMail = sendMailInputModel.Email;
                //ConfigurationManager.AppSettings["ContactMail"];
            var html = _goalRepository.GetHtmlTemplateByName("OfferMailTemplate", loggedInContext.CompanyGuid).Replace("##Candidate##", sendMailInputModel.PersonName).Replace("##Date##", sendMailInputModel.Date).Replace("##PdfUrl##", sendMailInputModel.PdfURL);
            var toMails = contactMail.Split('\n');
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpMail = null,
                SmtpPassword = null,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Offer Letter",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendMail(loggedInContext, emailModel);
            return null;
        }

        public List<CompanyOutputModel> SearchCompanies(CompanySearchCriteriaInputModel companySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCompanies", "companySearchCriteriaInputModel", companySearchCriteriaInputModel, "CompanyStructure Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchCompaniesCommandId, companySearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                companySearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Companies list ");

            List<ParamsInputModel> inputParams = new List<ParamsInputModel>();
            var paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "CompanyId";
            paramsModel.Value = companySearchCriteriaInputModel.CompanyId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "TimeZoneId";
            paramsModel.Value = companySearchCriteriaInputModel.TimeFormatId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "MainUseCaseId";
            paramsModel.Value = companySearchCriteriaInputModel.MainUseCaseId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "IndustryId";
            paramsModel.Value = companySearchCriteriaInputModel.IndustryId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "CountryId";
            paramsModel.Value = companySearchCriteriaInputModel.CountryId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "CurrencyId";
            paramsModel.Value = companySearchCriteriaInputModel.CurrencyId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "NumberFormatId";
            paramsModel.Value = companySearchCriteriaInputModel.NumberFormatId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "DateFormatId";
            paramsModel.Value = companySearchCriteriaInputModel.DateFormatId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "TimeFormatId";
            paramsModel.Value = companySearchCriteriaInputModel.TimeFormatId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "int?";
            paramsModel.Key = "TeamSize";
            paramsModel.Value = companySearchCriteriaInputModel.TeamSize;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "string";
            paramsModel.Key = "PhoneNumber";
            paramsModel.Value = companySearchCriteriaInputModel.PhoneNumber;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "string";
            paramsModel.Key = "SearchText";
            paramsModel.Value = companySearchCriteriaInputModel.SearchText;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "int";
            paramsModel.Key = "PageNumber";
            paramsModel.Value = companySearchCriteriaInputModel.PageNumber;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "int";
            paramsModel.Key = "PageSize";
            paramsModel.Value = companySearchCriteriaInputModel.PageSize;
            inputParams.Add(paramsModel);

            var result = ApiWrapper.GetApiCallsWithAuthorisation(RouteConstants.ASSearchCompanies, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], inputParams, loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            if (responseJson.Success)
            {
                var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                var companiesList = JsonConvert.DeserializeObject<List<CompanyOutputModel>>(jsonResponse);
                return companiesList;
            } 
            else
            {
                if (responseJson?.ApiResponseMessages.Count > 0)
                {
                    var validationMessage = new ValidationMessage()
                    {
                        ValidationMessaage = responseJson.ApiResponseMessages[0].Message,
                        ValidationMessageType = MessageTypeEnum.Error,
                        Field = responseJson.ApiResponseMessages[0].FieldName
                    };
                    validationMessages.Add(validationMessage);
                }
                return new List<CompanyOutputModel>();
            }

            //List<CompanyOutputModel> companyList = _companyStructureRepository.SearchCompanies(companySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            //return companyList;
        }

        public CompanyOutputModel GetCompanyById(Guid? companyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyById", "companyId", companyId, "CompanyStructureService"));
            _auditService.SaveAudit(AppCommandConstants.GetCompanyByIdCommandId, companyId, loggedInContext);
            CompanySearchCriteriaInputModel searchCriteriaModel = new CompanySearchCriteriaInputModel { CompanyId = companyId };
            LoggingManager.Info("Getting Company Detail by Id ");

            List<ParamsInputModel> inputParams = new List<ParamsInputModel>();
            var paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "companyId";
            paramsModel.Value = companyId;
            inputParams.Add(paramsModel);

            var result = ApiWrapper.GetApiCallsWithAuthorisation(RouteConstants.ASGetCompanyById, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], inputParams, loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            if (responseJson.Success)
            {
                var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                var companiesList = JsonConvert.DeserializeObject<CompanyOutputModel>(jsonResponse);
                return companiesList;
            }
            else
            {
                if (responseJson?.ApiResponseMessages.Count > 0)
                {
                    var validationMessage = new ValidationMessage()
                    {
                        ValidationMessaage = responseJson.ApiResponseMessages[0].Message,
                        ValidationMessageType = MessageTypeEnum.Error,
                        Field = responseJson.ApiResponseMessages[0].FieldName
                    };
                    validationMessages.Add(validationMessage);
                }
                return new CompanyOutputModel();
            }

            //CompanyOutputModel companyList = _companyStructureRepository.SearchCompanies(searchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();
            //return companyList;
        }

        public List<IntroducedByOptionsOutputModel> SearchIntroducedByOptions(IntroducedByOptionsSearchInputModel introducedByOptionsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Introduced By Options", "introducedByOptionsSearchInputModel", introducedByOptionsSearchInputModel, "CompanyStructure Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchIntroducedByOptionsCommandId, introducedByOptionsSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                introducedByOptionsSearchInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Introduced By Options list ");
            List<IntroducedByOptionsOutputModel> introducedByOptionsList = _companyStructureRepository.SearchIntroducedByOptions(introducedByOptionsSearchInputModel, loggedInContext, validationMessages).ToList();
            return introducedByOptionsList;
        }

        public IntroducedByOptionsOutputModel GetIntroducedByOptionById(Guid? introducedByOptionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetIntroducedByOptionById", "introducedByOptionId", introducedByOptionId, "CompanyStructureService"));
            _auditService.SaveAudit(AppCommandConstants.GetIntroducedByOptionByIdCommandId, introducedByOptionId, loggedInContext);
            if (!CompanyStructureValidationHelper.GetIntroducedByOptionById(introducedByOptionId, loggedInContext,
                validationMessages))
            {
                return null;
            }

            IntroducedByOptionsSearchInputModel searchCriteriaModel = new IntroducedByOptionsSearchInputModel { CompanyIntroducedByOptionId = introducedByOptionId };
            LoggingManager.Info("Getting Introduced By Option Details");
            IntroducedByOptionsOutputModel introducedByOptionsList = _companyStructureRepository.SearchIntroducedByOptions(searchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();
            return introducedByOptionsList;
        }

        public List<int?> GetCronExpressionJobIds(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var customWidgetDetails = _widgetRepository.GetCustomWidgets(new CustomWidgetSearchCriteriaInputModel(), loggedInContext, validationMessages);

            return customWidgetDetails.Select(x => x.JobId).ToList();
        }

        public Guid? DeleteCompanyModule(DeleteCompanyModuleModel deleteCompanyModuleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteCompanyModule", "deleteCompanyModuleModel", deleteCompanyModuleModel, "CompanyStructure Service"));
            if (!CompanyStructureValidationHelper.DeleteCompanyModule(deleteCompanyModuleModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            deleteCompanyModuleModel.CompanyModuleId = _companyStructureRepository.DeleteCompanyModule(deleteCompanyModuleModel, loggedInContext, validationMessages);
            LoggingManager.Debug("CompanyModule with the id " + deleteCompanyModuleModel.CompanyModuleId);
            _auditService.SaveAudit(AppCommandConstants.DeleteCompanyModuleCommandId, deleteCompanyModuleModel, loggedInContext);
            return deleteCompanyModuleModel.CompanyModuleId;
        }

        public Guid? DeleteCompanyTestData(DeleteCompanyTestDataModel deleteCompanyTestDataModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteCompanyTestDataModel", "DeleteCompanyTestDataModel", deleteCompanyTestDataModel, "CompanyStructure Service"));
            if (!CompanyStructureValidationHelper.DeleteCompanyTestData(deleteCompanyTestDataModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            List<int?> jobids = GetCronExpressionJobIds(loggedInContext, validationMessages);

            foreach (var x in jobids)
            {
                if (x != null)
                {
                    RecurringJob.RemoveIfExists(x.ToString());
                }
            }
            var companyId = deleteCompanyTestDataModel.CompanyId;
            deleteCompanyTestDataModel.CompanyId = _companyStructureRepository.DeleteCompanyTestData(deleteCompanyTestDataModel, loggedInContext, validationMessages);
            if(companyId == deleteCompanyTestDataModel.CompanyId)
            {
                var result = ApiWrapper.PostentityToApi(RouteConstants.ASUpsertCompany, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], deleteCompanyTestDataModel, loggedInContext.AccessToken).Result;
                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            }
            LoggingManager.Debug("CompanyTestData with the id " + deleteCompanyTestDataModel?.CompanyId);
            _auditService.SaveAudit(AppCommandConstants.DeleteCompanyModuleCommandId, deleteCompanyTestDataModel, loggedInContext);
            return deleteCompanyTestDataModel?.CompanyId;
        }

        public virtual CompanyThemeModel GetCompanyTheme(Guid? loggedInUserId)
        {
            var url = HttpContext.Current.Request.Url.Authority;

            var splits = url.Split('.');

            return _companyStructureRepository.GetCompanyTheme(splits[0], loggedInUserId,
                new List<ValidationMessage>());
        }

        public bool? IsCompanyExists(List<ValidationMessage> validationMessages)
        {
            string url = HttpContext.Current.Request.Url.Authority;


            var splits = url.Split('.');

            var siteAddress = _companyStructureRepository.IsCompanyExists(splits[0], validationMessages);

            if (siteAddress == null)
            {
                return false;
            }
            return true;
        }

        public bool? UpsertCompanyConfigurationUrl(LoggedInContext loggedInContext, CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyConfigurationUrl", "companyInputModel", companyInputModel, "CompanyStructure Service"));

            return _companyStructureRepository.UpsertCompanyConfigurationUrl(companyInputModel, loggedInContext, validationMessages);
        }
        public string GetCompanyConfigurationUrl(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyConfigurationUrl", "companyInputModel", "", "CompanyStructure Service"));
            return _companyStructureRepository.GetCompanyConfigurationUrl(loggedInContext, validationMessages);
        }

        public bool? UpdateCompanySettings(LoggedInContext loggedInContext, CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateCompanySettings", "companyInputModel", companyInputModel, "CompanyStructure Service"));

            return _companyStructureRepository.UpdateCompanySettings(companyInputModel, loggedInContext, validationMessages);
        }

        public string UpsertCompanySignUpDetails(CompanyInputModel registrationInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanySignUpDetails", "companyInputModel", "", "CompanyStructure Service"));
            var result = _companyStructureRepository.UpsertCompanySignUpDetails(registrationInputModel, validationMessages);
            return result;
        }

        public bool SendVerificationEmail(CompanyInputModel registrationInputModel)
        {
            var contactMail = registrationInputModel.EmailAddress;
            var siteAddress = registrationInputModel.RegistrerSiteAddress + "?Name=" + registrationInputModel.UserName + "&Email=" + registrationInputModel.EmailAddress + "&Id=" + registrationInputModel.RegistorId;
            var companyMainRegistrationLogo = registrationInputModel.CompanySigninLogo;
            var html = _goalRepository.GetHtmlTemplateByName("RegistrationVerificationEmailTemplate", null).Replace("##UserName##", registrationInputModel.UserName).Replace("##siteAddress##", siteAddress).Replace("##OTP##", registrationInputModel.VerificationCode.ToString()).Replace("##CompanyLogo##", companyMainRegistrationLogo).Replace("##CompanyRegistrationLogo##", companyMainRegistrationLogo);
            var toMails = contactMail.Split('\n');
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpMail = null,
                SmtpPassword = null,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Registration Email Verification",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };
            _emailService.SendEmailWithKeys(emailModel);
            return true;
        }

        public bool? UpsertEmailVerifyDetails(CompanyInputModel registrationInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmailVerifyDetails", "companyInputModel", "", "CompanyStructure Service"));
            var result = _companyStructureRepository.UpsertEmailVerifyDetails(registrationInputModel, validationMessages);
            return result;
        }
    }
}