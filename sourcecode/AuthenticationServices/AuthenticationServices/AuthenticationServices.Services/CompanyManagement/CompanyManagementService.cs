using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.CompanyStructure;
using AuthenticationServices.Models.MasterData;
using AuthenticationServices.Models.Modules;
using AuthenticationServices.Repositories.Repositories.CompanyManagement;
using AuthenticationServices.Services.Email;
using AuthenticationServices.Services.Helpers;
using AuthenticationServices.Services.Helpers.CompanyStructureValidationHelpers;
using System;
using System.Collections.Generic;
using System.Linq;

namespace AuthenticationServices.Services.CompanyManagement
{
    public class CompanyManagementService : ICompanyManagementService
    {
        private readonly ICompanyManagementRepository _companyManagementRepository;
        private readonly IEmailService _emailService;
        public CompanyManagementService(ICompanyManagementRepository companyManagementRepository, IEmailService emailService)
        {
            _companyManagementRepository = companyManagementRepository;
            _emailService = emailService;
        }
        public CompanyOutputModel GetCompanyById(Guid? companyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyById", "companyId", companyId, "CompanyManagementService"));
            CompanySearchCriteriaInputModel searchCriteriaModel = new CompanySearchCriteriaInputModel { CompanyId = companyId };
            LoggingManager.Info("Getting Company Detail by Id ");
            CompanyOutputModel companyList = _companyManagementRepository.SearchCompanies(searchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();
            return companyList;
        }

        public List<CompanyOutputModel> SearchCompanies(CompanySearchCriteriaInputModel companySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCompanies", "companySearchCriteriaInputModel", companySearchCriteriaInputModel, "CompanyManagementService"));
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                companySearchCriteriaInputModel, validationMessages))
            {
                return null;
            }
            if(string.IsNullOrEmpty(companySearchCriteriaInputModel.SearchText))
            {
                companySearchCriteriaInputModel.SearchText = "";
            }
            LoggingManager.Info("Getting Companies list ");
            List<CompanyOutputModel> companyList = _companyManagementRepository.SearchCompanies(companySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return companyList;
        }

        public List<CompanyModuleOutputModel> GetCompanyModules(CompanyModuleSearchInputModel companyModuleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyModules", "companySearchCriteriaInputModel", companyModuleSearchInputModel, "CompanyManagementService"));
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                companyModuleSearchInputModel, validationMessages))
            {
                return null;
            }
            if (string.IsNullOrEmpty(companyModuleSearchInputModel.SearchText) || companyModuleSearchInputModel.SearchText == "undefined")
            {
                companyModuleSearchInputModel.SearchText = "";
            }
            LoggingManager.Info("Getting GetCompanyModules list ");
            List<CompanyModuleOutputModel> companyList = _companyManagementRepository.GetCompanyModules(companyModuleSearchInputModel, loggedInContext, validationMessages).ToList();
            return companyList;
        }

        public void CheckUpsertCompanyValidations(CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "CheckUpsertCompanyValidations", "companyInputModel", companyInputModel, "CompanyManagementService"));
            CompanyStructureValidationHelper.UpsertCompany(companyInputModel, validationMessages);

            if (validationMessages.Count == 0)
            {
                _companyManagementRepository.CheckUpsertCompanyValidations(companyInputModel, validationMessages);

                if (validationMessages.Count == 0)
                {
                    // companyInputModel.MainPassword = companyInputModel.Password;
                    LoggingManager.Debug("Password checking" + companyInputModel.MainPassword);
                    companyInputModel.Password = Utilities.GetSaltedPassword(companyInputModel.Password);

                }
            }
        }

        public UpsertCompanyOutputModel UpsertCompany(LoggedInContext loggedInContext, CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompany", "companyInputModel", companyInputModel, "CompanyManagementService"));

            UpsertCompanyOutputModel companyDetails = _companyManagementRepository.UpsertCompany(companyInputModel, validationMessages);

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

                bool? isInsert = _companyManagementRepository.UpdateCompanySettings(companyInputModel, loggedInContext, validationMessages);

                //TaskWrapper.ExecuteFunctionInNewThread(() =>
                //{
                //    SendCompanyInsertEmailToRegisteredEmailAddress(loggedInContext, companyInputModel, validationMessages);

                //});
              
               LoggingManager.Debug("Company with the id " + companyInputModel.CompanyId);
            }

            return companyDetails;
        }

        public virtual void SendCompanyInsertEmailToRegisteredEmailAddress(LoggedInContext loggedInContext, CompanyInputModel companyInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SendRemoteSiteEmailToRegisteredEmailAddress", "companyInputModel", companyInputModel, "Remote Site Mail"));

            CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
            {
                Key = "CompanySigninLogo",
                IsArchived = false
            };

            string mainLogo = (_companyManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);

            var CompanySigninLogo = companyInputModel.CompanySigninLogo ?? mainLogo;
            var footer = companyInputModel.MailFooterAddress;
            var siteAddress = "https://" + companyInputModel.SiteAddress + companyInputModel.SiteDomain;
            var html = _companyManagementRepository.GetHtmlTemplateByName("CompanyRegistrationTemplate", loggedInContext.CompanyGuid).Replace("##ToName##", companyInputModel.FirstName).Replace("##userName##", companyInputModel.WorkEmail).Replace("##password##", companyInputModel.MainPassword).Replace("##siteAddress##", siteAddress);
                
            LoggingManager.Debug("Mial with the Password " + companyInputModel.MainPassword);

            var siteaddress = companyInputModel.SiteAddress + companyInputModel.SiteDomain;

            var toMails = companyInputModel.WorkEmail?.Split('\n');
            var bccMail = companyInputModel.BccEmail?.Split('\n');
            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpMail = null,
                SmtpPassword = null,
                ToAddresses = toMails,
                HtmlContent = html,
                Subject = "Nxus world",
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

        public Guid? UpsertCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyDetails", "loggedincontext", loggedInContext, "CompanyManagementService"));

            if(companyInputModel.IsUpdate == false || companyInputModel.IsUpdate == null)
            {
                companyInputModel.Password = Utilities.GetSaltedPassword(companyInputModel.Password);
            }
            

            Guid? companyId = _companyManagementRepository.UpsertCompanyDetails(companyInputModel, loggedInContext, validationMessages);

            return companyId;
        }

        public string UpdateCompanyDetails(CompanyInputModel companyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyDetails", "loggedincontext", loggedInContext, "CompanyManagementService"));

            string companyId = _companyManagementRepository.UpdateCompanyDetails(companyInputModel, loggedInContext, validationMessages);

            return companyId;
        }

        public Guid? DeleteCompanyTestData(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return _companyManagementRepository.DeleteCompanyTestData(loggedInContext, validationMessages);
        }
        public CompanyOutputModel GetCompanyDetails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "CheckUpsertCompanyValidations", "loggedincontext", loggedInContext, "CompanyManagementService"));

            CompanyOutputModel companyDetails = _companyManagementRepository.GetCompanyDetails(loggedInContext, validationMessages);

            if (validationMessages.Count() > 0)
            {
                return null;
            }
            return companyDetails;
        }

        public Guid? DeleteCompanyModule(DeleteCompanyModuleModel deleteCompanyModuleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteCompanyModule", "deleteCompanyModuleModel", deleteCompanyModuleModel, "CompanyManagementService"));
            if (!CompanyStructureValidationHelper.DeleteCompanyModule(deleteCompanyModuleModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            deleteCompanyModuleModel.CompanyModuleId = _companyManagementRepository.DeleteCompanyModule(deleteCompanyModuleModel, loggedInContext, validationMessages);
            LoggingManager.Debug("CompanyModule with the id " + deleteCompanyModuleModel.CompanyModuleId);
            return deleteCompanyModuleModel.CompanyModuleId;
        }

        public Guid? ArchiveCompany(ArchiveCompanyInputModel archiveCompanyInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ArchiveCompany", "archiveCompanyInputModel", archiveCompanyInputModel, "CompanyManagementService"));
            if (!CompanyStructureValidationHelper.ArchiveCompany(archiveCompanyInputModel, loggedInContext,validationMessages))
            {
                return null;
            }
            return _companyManagementRepository.ArchiveCompany(archiveCompanyInputModel, loggedInContext, validationMessages);
        }

        public List<CompanyStructureOutputModel> SearchIndustries(CompanyStructureSearchCriteriaInputModel companyStructureSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchIndustries", "companyStructureSearchCriteriaInputModel", companyStructureSearchCriteriaInputModel, "CompanyStructure Api"));
            if (!CommonValidationHelper.ValidateSearchCriteriaForAllowAnonymous(companyStructureSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Industries list ");
            List<CompanyStructureOutputModel> industriesList = _companyManagementRepository.SearchCompanyStructure(companyStructureSearchCriteriaInputModel, validationMessages);
            return industriesList;
        }

        public Guid? UpsertModule(ModuleUpsertInputModel moduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyDetails", "loggedincontext", loggedInContext, "CompanyManagementService"));

            if (!ModuleValidationHelper.UpsertModule(moduleInputModel, validationMessages))
            {
                return null;
            }

            Guid? moduleId = _companyManagementRepository.UpsertModule(moduleInputModel, loggedInContext, validationMessages);

            return moduleId;
        }

        public List<ModulePageOutputReturnModel> GetModulePages(ModulePageSearchInputModel modulePageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchIndustries", "companyStructureSearchCriteriaInputModel", modulePageSearchInputModel, "CompanyStructure Api"));
           
            LoggingManager.Info("Getting module pages list ");
            List<ModulePageOutputReturnModel> industriesList = _companyManagementRepository.GetModulePages(modulePageSearchInputModel, loggedInContext,validationMessages);
            return industriesList;
        }

        public Guid? UpsertModulePage(ModulePageUpsertInputModel moduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteCompanyModule", "deleteCompanyModuleModel", moduleInputModel, "CompanyManagementService"));
            if (!CompanyStructureValidationHelper.UpsertModulePageValidations(moduleInputModel, 
                validationMessages))
            {
                return null;
            }

            Guid? modulePageId = _companyManagementRepository.UpsertModulePage(moduleInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("CompanyModule with the id " + modulePageId);
            return modulePageId;
        }

        public List<ModuleLayoutOutputReturnModel> GetModuleLayouts(ModulePageSearchInputModel modulePageSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetModuleLayouts", "companyStructureSearchCriteriaInputModel", modulePageSearchInputModel, "CompanyStructure Api"));

            LoggingManager.Info("Getting module pages list ");
            List<ModuleLayoutOutputReturnModel> moduleLayouts = _companyManagementRepository.GetModuleLayouts(modulePageSearchInputModel, loggedInContext, validationMessages);
            return moduleLayouts;
        }

        public Guid? UpsertModuleLayout(ModuleLayoutUpsertInputModel moduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteCompanyModule", "deleteCompanyModuleModel", moduleInputModel, "CompanyManagementService"));
           
            Guid? modulePageId = _companyManagementRepository.UpsertModuleLayout(moduleInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("CompanyModule with the id " + modulePageId);
            return modulePageId;
        }

        public List<ModuleOutputModel> GetModules(ModuleSearchInputModel moduleSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetModules", "ModuleSearchInputModel", moduleSearchInputModel, "CompanyStructure Api"));

            LoggingManager.Info("Getting module pages list ");
            List<ModuleOutputModel> modulesList = _companyManagementRepository.GetModules(moduleSearchInputModel, loggedInContext, validationMessages);
            return modulesList;
        }

        public Guid? UpsertCompanyModule(CompanyModuleUpsertModel companyModuleUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyModule", "CompanyModuleUpsertModel", companyModuleUpsertModel, "CompanyManagementService"));

            Guid? modulePageId = _companyManagementRepository.UpsertCompanyModules(companyModuleUpsertModel, loggedInContext, validationMessages);
            LoggingManager.Debug("CompanyModule with the id " + modulePageId);
            return modulePageId;
        }
    }
}
