using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using Btrak.Models.MasterData;
using Btrak.Models.User;
using Btrak.Models.SoftLabelConfigurations;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.MasterDataValidationHelper;
using BTrak.Common;
using Btrak.Models.PayRoll;
using Btrak.Services.File;
using System.Net;
using Syroot.Windows.IO;
using Btrak.Services.FileUploadDownload;
using Newtonsoft.Json;
using Btrak.Models.EntityType;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Services.TimeSheet;
using Btrak.Dapper.Dal.SpModels;
using Newtonsoft.Json.Serialization;
using Btrak.Models.Branch;
using System.Configuration;
using Hangfire;
using Btrak.Services.Notification;
using Btrak.Models.Notification;
using BTrak.Common.Constants;
using BusinessView.Common;
using JsonDeserialiseData = BTrak.Common.JsonDeserialiseData;

namespace Btrak.Services.MasterData
{
    public class MasterDataManagementService : IMasterDataManagementService
    {
        private readonly MasterDataManagementRepository _masterDataManagementRepository;
        private readonly SkillRepository _skillRepository;
        private readonly IAuditService _auditService;
        private readonly FileUpload.IFileService _fileService;
        private readonly IFileStoreService _fileStoreService;
        private readonly TimeSheetRepository _timeSheetRepository;
        private readonly EntityRoleFeatureRepository _entityRoleFeatureRepository;
        private readonly MasterTableRepository _masterTableRepository = new MasterTableRepository();
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly INotificationService _notificationService;

        public MasterDataManagementService(MasterDataManagementRepository masterDataManagementRepository, INotificationService notificationService, TimeSheetRepository timeSheetRepository, EntityRoleFeatureRepository entityRoleFeatureRepository, SkillRepository skillRepository, IAuditService auditService, FileUpload.IFileService fileService, IFileStoreService fileStoreService)
        {
            _masterDataManagementRepository = masterDataManagementRepository;
            _skillRepository = skillRepository;
            _auditService = auditService;
            _fileService = fileService;
            _fileStoreService = fileStoreService;
            _timeSheetRepository = timeSheetRepository;
            _entityRoleFeatureRepository = entityRoleFeatureRepository;
            _notificationService = notificationService;
        }

        public List<GetStatesOutputModel> GetStates(GetStatesSearchCriteriaInputModel getStatesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get States", "getStatesSearchCriteriaInputModel", getStatesSearchCriteriaInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetStatesCommandId, getStatesSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                getStatesSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting States list ");
            List<GetStatesOutputModel> statesList = _masterDataManagementRepository.GetStates(getStatesSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return statesList;
        }

        public List<EmploymentStatusOutputModel> GetEmploymentStatus(EmploymentStatusSearchCriteriaInputModel getEmploymentStatusSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Employment Status", "getEmploymentStatusSearchCriteriaInputModel", getEmploymentStatusSearchCriteriaInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetEmploymentStatusCommandId, getEmploymentStatusSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                getEmploymentStatusSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Employment Status list ");
            List<EmploymentStatusOutputModel> employmentStatusList = _masterDataManagementRepository.GetEmploymentStatus(getEmploymentStatusSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return employmentStatusList;
        }

        public List<GetLicenceTypesOutputModel> GetLicenceTypes(GetLicenceTypesSearchCriteriaInputModel getLicenceTypesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Licence Types", "getLicenceTypesSearchCriteriaInputModel", getLicenceTypesSearchCriteriaInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetLicenceTypesCommandId, getLicenceTypesSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                getLicenceTypesSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Licence Types List");
            List<GetLicenceTypesOutputModel> licenceTypesList = _masterDataManagementRepository.GetLicenceTypes(getLicenceTypesSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return licenceTypesList;
        }

        public List<ReportingMethodsOutputModel> GetReportingMethods(ReportingMethodsSearchCriteriaInputModel getReportingMethodsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Reporting Methods", "getReportingMethodsSearchCriteriaInputModel", getReportingMethodsSearchCriteriaInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetReportingMethodsCommandId, getReportingMethodsSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                getReportingMethodsSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Reporting Methods List");
            List<ReportingMethodsOutputModel> getReportingMethodsList = _masterDataManagementRepository.GetReportingMethods(getReportingMethodsSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return getReportingMethodsList;
        }

        public List<PayFrequencyOutputModel> GetPayFrequency(PayFrequencySearchCriteriaInputModel payFrequencySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Pay Frequency", "payFrequencySearchCriteriaInputModel", payFrequencySearchCriteriaInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetPayFrequencyCommandId, payFrequencySearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                payFrequencySearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Pay Frequency List");
            List<PayFrequencyOutputModel> getPayFrequencyList = _masterDataManagementRepository.GetPayFrequency(payFrequencySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return getPayFrequencyList;
        }

        public List<EducationLevelsOutputModel> GetEducationLevels(EducationLevelSearchInputModel educationLevelSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEducationLevels", "getEducationLevelsSearchCriteriaInputModel", educationLevelSearchInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetEducationLevelsCommandId, educationLevelSearchInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                educationLevelSearchInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Education Levels List");
            List<EducationLevelsOutputModel> getEducationLevelsList = _masterDataManagementRepository.GetEducationLevels(educationLevelSearchInputModel, loggedInContext, validationMessages).ToList();
            return getEducationLevelsList;
        }

        public List<EducationLevelsDropDownOutputModel> GetEducationLevelsDropDown(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEducationLevelsDropDown", "searchText", searchText, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetEducationLevelsCommandId, searchText, loggedInContext);
            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            LoggingManager.Info("Getting Education Levels List");
            List<EducationLevelsDropDownOutputModel> getEducationLevelsDropDownList = _masterDataManagementRepository.GetEducationLevelsDropDown(searchText, loggedInContext, validationMessages).ToList();
            return getEducationLevelsDropDownList;
        }

        public Guid? UpsertSkills(SkillsInputModel skillsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertSkills", "skillsInputModel", skillsInputModel, "MasterDataManagement Service"));
            if (!MasterDataValidationHelper.UpsertSkillsValidation(skillsInputModel, loggedInContext,
                validationMessages))
            {
                return null;
            }

            skillsInputModel.SkillId = _skillRepository.UpsertSkills(skillsInputModel, loggedInContext, validationMessages);
            LoggingManager.Debug("Skills with the id " + skillsInputModel.SkillId);
            _auditService.SaveAudit(AppCommandConstants.UpsertSkillsCommandId, skillsInputModel, loggedInContext);
            return skillsInputModel.SkillId;
        }

        public List<SkillsOutputModel> GetSkills(SkillsSearchCriteriaInputModel skillsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Skills", "skillsSearchCriteriaInputModel", skillsSearchCriteriaInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetSkillsCommandId, skillsSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, skillsSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting Skills List");
            List<SkillsOutputModel> getSkillsList = _masterDataManagementRepository.GetSkills(skillsSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return getSkillsList;
        }

        public List<NationalityApiReturnModel> GetNationalities(NationalitySearchInputModel nationalitySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetNationalities", "MasterDataManagement Service"));

            LoggingManager.Debug(nationalitySearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetNationalitiesCommandId, nationalitySearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<NationalityApiReturnModel> nationalityReturnModels = _masterDataManagementRepository.GetNationalities(nationalitySearchInputModel, loggedInContext, validationMessages).ToList();

            return nationalityReturnModels;
        }

        public List<CompetenciesOutputModel> GetCompetencies(GetCompetenciesSearchCriteriaInputModel getCompetenciesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompetencies", "MasterDataManagement Service"));
            LoggingManager.Debug(getCompetenciesSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetCompetenciesCommandId, getCompetenciesSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<CompetenciesOutputModel> competenciesReturnModels = _masterDataManagementRepository.GetCompetencies(getCompetenciesSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return competenciesReturnModels;
        }

        public List<LanguageFluenciesOutputModel> GetLanguageFluencies(GetLanguageFluenciesSearchCriteriaInputModel getLanguageFluenciesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLanguageFluencies", "MasterDataManagement Service"));
            LoggingManager.Debug(getLanguageFluenciesSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetLanguageFluenciesCommandId, getLanguageFluenciesSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<LanguageFluenciesOutputModel> languageFluenciesReturnModels = _masterDataManagementRepository.GetLanguageFluencies(getLanguageFluenciesSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return languageFluenciesReturnModels;
        }

        public List<LanguagesOutputModel> GetLanguages(GetLanguagesSearchCriteriaInputModel getLanguagesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLanguages", "MasterDataManagement Service"));
            LoggingManager.Debug(getLanguagesSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetLanguagesCommandId, getLanguagesSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<LanguagesOutputModel> languagesReturnModels = _masterDataManagementRepository.GetLanguages(getLanguagesSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return languagesReturnModels;
        }

        public Guid? UpsertSubscriptionPaidByOption(SubscriptionPaidByUpsertInputModel subscriptionPaidByUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSubscriptionPaidByOption", "MasterDataManagement Service"));

            subscriptionPaidByUpsertInputModel.SubscriptionPaidByName = subscriptionPaidByUpsertInputModel.SubscriptionPaidByName?.Trim();

            LoggingManager.Debug(subscriptionPaidByUpsertInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertSubscriptionPaidBy(subscriptionPaidByUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            subscriptionPaidByUpsertInputModel.SubscriptionPaidById = _masterDataManagementRepository.UpsertSubscriptionPaidByOption(subscriptionPaidByUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertSubscriptionPaidByOptionCommandId, subscriptionPaidByUpsertInputModel, loggedInContext);

            LoggingManager.Debug(subscriptionPaidByUpsertInputModel.SubscriptionPaidById?.ToString());

            return subscriptionPaidByUpsertInputModel.SubscriptionPaidById;
        }

        public List<SubscriptionPaidByApiReturnModel> GetSubscriptionPaidByOptions(SubscriptionPaidBySearchCriteriaInputModel subscriptionPaidBySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSubscriptionPaidByOptions", "MasterDataManagement Service"));

            LoggingManager.Debug(subscriptionPaidBySearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetSubscriptionPaidByOptionsCommandId, subscriptionPaidBySearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<SubscriptionPaidByApiReturnModel> subscriptionPaidByApiReturnModels = _masterDataManagementRepository.GetSubscriptionPaidByOptions(subscriptionPaidBySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return subscriptionPaidByApiReturnModels;
        }

        public List<MembershipApiReturnModel> GetMemberships(MembershipSearchCriteriaInputModel membershipSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMemberships", "MasterDataManagement Service"));

            LoggingManager.Debug(membershipSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetMembershipsCommandId, membershipSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<MembershipApiReturnModel> membershipApiReturnModels = _masterDataManagementRepository.GetMemberships(membershipSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return membershipApiReturnModels;
        }

        public Guid? UpsertTimeFormat(TimeFormatInputModel timeFormatInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertTimeFormat", "MasterDataManagement Service"));
            LoggingManager.Debug(timeFormatInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertTimeFormatValidation(timeFormatInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            timeFormatInputModel.TimeFormatId = _masterDataManagementRepository.UpsertTimeFormat(timeFormatInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertTimeFormatCommandId, timeFormatInputModel, loggedInContext);

            LoggingManager.Debug(timeFormatInputModel.TimeFormatId?.ToString());

            return timeFormatInputModel.TimeFormatId;
        }

        public Guid? UpsertDateFormat(DateFormatInputModel dateFormatInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertDateFormat", "MasterDataManagement Service"));
            LoggingManager.Debug(dateFormatInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertDateFormatValidation(dateFormatInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            dateFormatInputModel.DateFormatId = _masterDataManagementRepository.UpsertDateFormat(dateFormatInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertDateFormatCommandId, dateFormatInputModel, loggedInContext);

            LoggingManager.Debug(dateFormatInputModel.DateFormatId?.ToString());

            return dateFormatInputModel.DateFormatId;
        }

        public Guid? UpsertMainUseCase(MainUseCaseInputModel mainUseCaseInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertMainUseCase", "MasterDataManagement Service"));
            LoggingManager.Debug(mainUseCaseInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertMainUseCaseValidation(mainUseCaseInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            mainUseCaseInputModel.MainUseCaseId = _masterDataManagementRepository.UpsertMainUseCase(mainUseCaseInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertMainUseCaseCommandId, mainUseCaseInputModel, loggedInContext);

            LoggingManager.Debug(mainUseCaseInputModel.MainUseCaseId?.ToString());

            return mainUseCaseInputModel.MainUseCaseId;
        }

        public List<GetAccessibleIpAddressesOutputModel> GetAccessibleIpAddresses(GetAccessibleIpAddressesSearchCriteriaInputModel getAccessibleIpAddressesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLanguages", "MasterDataManagement Service"));
            LoggingManager.Debug(getAccessibleIpAddressesSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAccessibleIpAddressesCommandId, getAccessibleIpAddressesSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<GetAccessibleIpAddressesOutputModel> ipAddresses = _masterDataManagementRepository.GetAccessibleIpAddresses(getAccessibleIpAddressesSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return ipAddresses;
        }

        public List<GetScriptsOutputModel> GetScripts(GetScriptsInputModel getScriptsInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetScripts", "MasterDataManagement Service"));
            LoggingManager.Debug(getScriptsInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAccessibleIpAddressesCommandId, getScriptsInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<GetScriptsOutputModel> scripts = _masterDataManagementRepository.GetScripts(getScriptsInputModel, loggedInContext, validationMessages).ToList();
            return scripts;
        }

        public byte[] Scripts(string scriptName, string version, List<ValidationMessage> validationMessages)
        {
            GetScriptsInputModel getScriptsInputModel = new GetScriptsInputModel
            {
                ScriptName = scriptName,
                Version = version
            };

            if (string.IsNullOrEmpty(version))
            {
                getScriptsInputModel.IsLatest = true;
            }

            GetScriptsOutputModel scripts = _masterDataManagementRepository.GetScripts(getScriptsInputModel, validationMessages).FirstOrDefault();

            string downloadsPath = new KnownFolder(KnownFolderType.Downloads).Path + "\\";

            if (!string.IsNullOrEmpty(scripts?.ScriptUrl))
            {
                using (var client = new WebClient())
                {
                    client.DownloadFileAsync(new Uri(scripts?.ScriptUrl), downloadsPath + scripts.ScriptName + "_" + scripts?.Version + ".js");
                }
            }

            byte[] fileData = _fileStoreService.DownloadFile(scripts?.ScriptUrl);

            return fileData;
        }

        public string GetScriptPath(string scriptName, string version, List<ValidationMessage> validationMessages)
        {
            GetScriptsInputModel getScriptsInputModel = new GetScriptsInputModel
            {
                ScriptName = scriptName,
                Version = version,
            };

            GetScriptsOutputModel scripts = _masterDataManagementRepository.GetScripts(getScriptsInputModel, validationMessages).FirstOrDefault();

            if (!string.IsNullOrEmpty(scripts?.ScriptUrl))
            {
                return scripts?.ScriptUrl;
            }

            return null;
        }

        public Guid? UpsertScript(GetScriptsInputModel scriptsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert script", "MasterDataManagement Service"));
            LoggingManager.Debug(scriptsInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertScriptValidation(scriptsInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            scriptsInputModel.ScriptId = _masterDataManagementRepository.UpsertScript(scriptsInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertScriptCommandId, scriptsInputModel, loggedInContext);

            LoggingManager.Debug(scriptsInputModel.ScriptId?.ToString());

            return scriptsInputModel.ScriptId;
        }

        public void DeleteScript(Guid scriptId, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            _masterDataManagementRepository.DeleteScript(scriptId, loggedInContext, validationMessages);
        }

        public Guid? UpsertNumberFormat(NumberFormatInputModel numberFormatInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertNumberFormat", "MasterDataManagement Service"));
            LoggingManager.Debug(numberFormatInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertNumberFormatValidation(numberFormatInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            numberFormatInputModel.NumberFormatId = _masterDataManagementRepository.UpsertNumberFormat(numberFormatInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertNumberFormatCommandId, numberFormatInputModel, loggedInContext);

            LoggingManager.Debug(numberFormatInputModel.NumberFormatId?.ToString());

            return numberFormatInputModel.NumberFormatId;
        }

        public Guid? UpsertCompanyIntroducedByOption(CompanyIntroducedByOptionInputModel companyIntroducedByOptionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertNumberFormat", "MasterDataManagement Service"));
            LoggingManager.Debug(companyIntroducedByOptionInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertCompanyIntroducedByOptionValidation(companyIntroducedByOptionInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            companyIntroducedByOptionInputModel.CompanyIntroducedByOptionId = _masterDataManagementRepository.UpsertCompanyIntroducedByOption(companyIntroducedByOptionInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertCompanyIntroducedByOptionCommandId, companyIntroducedByOptionInputModel, loggedInContext);

            LoggingManager.Debug(companyIntroducedByOptionInputModel.CompanyIntroducedByOptionId?.ToString());

            return companyIntroducedByOptionInputModel.CompanyIntroducedByOptionId;
        }

        public Guid? UpsertState(StateInputModel stateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertState", "MasterDataManagement Service"));
            LoggingManager.Debug(stateInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertStateValidation(stateInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            stateInputModel.StateId = _masterDataManagementRepository.UpsertState(stateInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertStateCommandId, stateInputModel, loggedInContext);

            LoggingManager.Debug(stateInputModel.StateId?.ToString());

            return stateInputModel.StateId;
        }

        public Guid? UpsertReferenceType(ReferenceTypeInputModel referenceTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertReferenceType", "MasterDataManagement Service"));
            LoggingManager.Debug(referenceTypeInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertReferenceTypeValidation(referenceTypeInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            referenceTypeInputModel.ReferenceTypeId = _masterDataManagementRepository.UpsertReferenceType(referenceTypeInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertReferenceTypeCommandId, referenceTypeInputModel, loggedInContext);

            LoggingManager.Debug(referenceTypeInputModel.ReferenceTypeId?.ToString());

            return referenceTypeInputModel.ReferenceTypeId;
        }

        public List<ReferenceTypeOutputModel> GetReferenceTypes(ReferenceTypeSearchCriteriaInputModel referenceTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetReferenceTypes", "MasterDataManagement Service"));
            LoggingManager.Debug(referenceTypeSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetReferenceTypesCommandId, referenceTypeSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ReferenceTypeOutputModel> referenceTypeList = _masterDataManagementRepository.GetReferenceTypes(referenceTypeSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return referenceTypeList;
        }

        public Guid? UpsertLicenseType(LicenseTypeInputModel licenseTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertLicenseType", "MasterDataManagement Service"));
            LoggingManager.Debug(licenseTypeInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertLicenseTypeValidation(licenseTypeInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            licenseTypeInputModel.LicenceTypeId = _masterDataManagementRepository.UpsertLicenseType(licenseTypeInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertLicenseTypeCommandId, licenseTypeInputModel, loggedInContext);

            LoggingManager.Debug(licenseTypeInputModel.LicenceTypeId?.ToString());

            return licenseTypeInputModel.LicenceTypeId;
        }

        public Guid? UpsertHoliday(HolidayInputModel holidayInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertHoliday", "MasterDataManagement Service"));
            // LoggingManager.Debug(holidayInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertHolidayValidation(holidayInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            holidayInputModel.HolidayId = _masterDataManagementRepository.UpsertHoliday(holidayInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertHolidayCommandId, holidayInputModel, loggedInContext);

            LoggingManager.Debug(holidayInputModel.HolidayId?.ToString());

            return holidayInputModel.HolidayId;
        }

        public List<HolidaysOutputModel> GetHolidays(HolidaySearchCriteriaInputModel holidaySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHolidays", "MasterDataManagement Service"));
            LoggingManager.Debug(holidaySearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetHolidaysCommandId, holidaySearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<HolidaysOutputModel> holidaysList = _masterDataManagementRepository.GetHolidays(holidaySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            Parallel.ForEach(holidaysList, holiday =>
             {
                 holiday.WeekOffDays = holiday.WeekOff != null ? holiday.WeekOff.Split(',').ToList() : new List<string>();
             });

            return holidaysList;
        }

        public List<GetAllNationalitiesOutputModel> GetAllNationalities(GetAllNationalitiesSearchCriteriaInputModel getAllNationalitiesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetNationalities", "MasterDataManagement Service"));

            LoggingManager.Debug(getAllNationalitiesSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAllNationalitiesCommandId, getAllNationalitiesSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<GetAllNationalitiesOutputModel> nationalityList = _masterDataManagementRepository.GetAllNationalities(getAllNationalitiesSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return nationalityList;
        }

        public List<GendersOutputModel> GetGenders(GendersSearchCriteriaInputModel gendersSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenders", "MasterDataManagement Service"));

            LoggingManager.Debug(gendersSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetGendersCommandId, gendersSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<GendersOutputModel> gendersList = _masterDataManagementRepository.GetGenders(gendersSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return gendersList;
        }

        public List<MaritalStatusesOutputModel> GetMaritalStatuses(MaritalStatusesSearchCriteriaInputModel maritalStatusesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMaritalStatuses", "MasterDataManagement Service"));

            LoggingManager.Debug(maritalStatusesSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetMaritalStatusesCommandId, maritalStatusesSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<MaritalStatusesOutputModel> maritalStatusesList = _masterDataManagementRepository.GetMaritalStatuses(maritalStatusesSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return maritalStatusesList;
        }

        public Guid? UpsertEducationLevel(EducationLevelUpsertModel educationLevelUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEducatinLevel", "MasterDataManagement Service"));
            LoggingManager.Debug(educationLevelUpsertModel.ToString());

            if (!MasterDataValidationHelper.UpsertEducationLevel(educationLevelUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            educationLevelUpsertModel.EducationLevelId = _masterDataManagementRepository.UpsertEducationLevel(educationLevelUpsertModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertEducationLevelCommandId, educationLevelUpsertModel, loggedInContext);

            LoggingManager.Debug(educationLevelUpsertModel.EducationLevelId?.ToString());

            return educationLevelUpsertModel.EducationLevelId;
        }

        public Guid? UpsertReportingMethod(ReportingMethodUpsertModel reportingMethodUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertReportingMethod", "MasterDataManagement Service"));
            LoggingManager.Debug(reportingMethodUpsertModel.ToString());

            if (!MasterDataValidationHelper.UpsertReportingMethod(reportingMethodUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            reportingMethodUpsertModel.ReportingMethodId = _masterDataManagementRepository.UpsertReportingMethod(reportingMethodUpsertModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertReportingMethodCommandId, reportingMethodUpsertModel, loggedInContext);

            LoggingManager.Debug(reportingMethodUpsertModel.ReportingMethodId?.ToString());

            return reportingMethodUpsertModel.ReportingMethodId;
        }

        public Guid? UpsertMembership(MembershipUpsertModel membershipUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertReportingMethod", "MasterDataManagement Service"));
            LoggingManager.Debug(membershipUpsertModel.ToString());

            if (!MasterDataValidationHelper.UpsertMembership(membershipUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            membershipUpsertModel.MembershipId = _masterDataManagementRepository.UpsertMembership(membershipUpsertModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertMembershipCommandId, membershipUpsertModel, loggedInContext);

            LoggingManager.Debug(membershipUpsertModel.MembershipId?.ToString());

            return membershipUpsertModel.MembershipId;
        }

        public Guid? UpsertEmploymentStatus(EmploymentStatusInputModel employmentStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEmploymentStatus", "Master Data Management Service"));

            LoggingManager.Debug(employmentStatusInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertEmploymentStatusValidation(employmentStatusInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            employmentStatusInputModel.EmploymentStatusId = _masterDataManagementRepository.UpsertEmploymentStatus(employmentStatusInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertEmploymentStatusCommandId, employmentStatusInputModel, loggedInContext);

            LoggingManager.Debug(employmentStatusInputModel.EmploymentStatusId?.ToString());

            return employmentStatusInputModel.EmploymentStatusId;
        }

        public Guid? UpsertPayFrequency(PayFrequencyUpsertModel payFrequencyUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPayFrequency", "Master Data Management Service"));

            LoggingManager.Debug(payFrequencyUpsertModel.ToString());

            //if (!MasterDataValidationHelper.UpsertPayFrequencyValidation(payFrequencyUpsertModel, loggedInContext, validationMessages))
            //{
            //    return null;
            //}

            payFrequencyUpsertModel.PayFrequencyId = _masterDataManagementRepository.UpsertPayFrequency(payFrequencyUpsertModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertPayFrequencyCommandId, payFrequencyUpsertModel, loggedInContext);

            LoggingManager.Debug(payFrequencyUpsertModel.PayFrequencyId?.ToString());

            return payFrequencyUpsertModel.PayFrequencyId;
        }

        public Guid? UpsertNationality(NationalityUpsertModel nationalityUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "nationalityUpsertModel", "Master Data Management Service"));

            LoggingManager.Debug(nationalityUpsertModel.ToString());

            if (!MasterDataValidationHelper.UpsertNationalityValidation(nationalityUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            nationalityUpsertModel.NationalityId = _masterDataManagementRepository.UpsertNationality(nationalityUpsertModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertNationalityCommandId, nationalityUpsertModel, loggedInContext);

            LoggingManager.Debug(nationalityUpsertModel.NationalityId?.ToString());

            return nationalityUpsertModel.NationalityId;
        }

        public Guid? UpsertLanguage(LanguageUpsertModel languageUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Language", "Master Data Management Service"));

            LoggingManager.Debug(languageUpsertModel.ToString());

            if (!MasterDataValidationHelper.UpsertLanguageValidation(languageUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            languageUpsertModel.LanguageId = _masterDataManagementRepository.UpsertLanguage(languageUpsertModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertLanguageCommandId, languageUpsertModel, loggedInContext);

            LoggingManager.Debug(languageUpsertModel.LanguageId?.ToString());

            return languageUpsertModel.LanguageId;
        }

        public Guid? UpsertJobCategories(JobCategoriesUpsertModel jobCategoriesUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Language", "Master Data Management Service"));

            LoggingManager.Debug(jobCategoriesUpsertModel.ToString());

            if (!MasterDataValidationHelper.UpsertJobCategoriesValidation(jobCategoriesUpsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            jobCategoriesUpsertModel.JobCategoryId = _masterDataManagementRepository.UpsertJobCategories(jobCategoriesUpsertModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertJobCategoriesCommandId, jobCategoriesUpsertModel, loggedInContext);

            LoggingManager.Debug(jobCategoriesUpsertModel.JobCategoryId?.ToString());

            return jobCategoriesUpsertModel.JobCategoryId;
        }

        public List<JobCategorySearchOutputModel> SearchJobCategoryDetails(JobCategorySearchInputModel jobCategorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get job category", "MasterDataManagement Service"));
            LoggingManager.Debug(jobCategorySearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetJobCategoryDetailsCommandId, jobCategorySearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<JobCategorySearchOutputModel> jobCategoryDetails = _masterDataManagementRepository.SearchJobCategoryDetails(jobCategorySearchInputModel, loggedInContext, validationMessages).ToList();
            return jobCategoryDetails;
        }

        public List<AppSettingsOutputModel> GetAppsettings(Appsettings appSettingSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get job category", "MasterDataManagement Service"));
            LoggingManager.Debug(appSettingSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetJobCategoryDetailsCommandId, appSettingSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<AppSettingsOutputModel> appSettingsOutputs = _masterDataManagementRepository.GetAppsettings(appSettingSearchInputModel, loggedInContext, validationMessages).ToList();
            return appSettingsOutputs;
        }

        public Guid? UpsertAppSettings(AppSettingsUpsertInputModel appSettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get App Settings", "MasterDataManagement Service"));

            LoggingManager.Debug(appSettingsUpsertInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetJobCategoryDetailsCommandId, appSettingsUpsertInputModel, loggedInContext);

            if (!MasterDataValidationHelper.UpsertAppSettingsValidation(appSettingsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? appSettingId = _masterDataManagementRepository.UpsertAppSettings(appSettingsUpsertInputModel, loggedInContext, validationMessages);

            return appSettingId;
        }

        public Guid? UpsertCompanySettings(CompanySettingsUpsertInputModel companySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Company Settings", "MasterDataManagement Service"));

            LoggingManager.Debug(companySettingsUpsertInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetJobCategoryDetailsCommandId, companySettingsUpsertInputModel, loggedInContext);

            if (!MasterDataValidationHelper.UpsertCompanySettingsValidation(companySettingsUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if(!string.IsNullOrEmpty(loggedInContext.AccessToken))
            {
                var result = ApiWrapper.PostentityToApi(RouteConstants.ASUpsertCompanysettings, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], companySettingsUpsertInputModel, loggedInContext.AccessToken).Result;
                var responseJson = JsonConvert.DeserializeObject<BTrak.Common.JsonDeserialiseData>(result);
                var responseid = JsonConvert.SerializeObject(responseJson.Data);
                if (responseJson.Success && (responseid != null && responseid != "null"))
                {
                    companySettingsUpsertInputModel.CompanySettingsId = null;
                    companySettingsUpsertInputModel.CompanySettingsId = _masterDataManagementRepository.UpsertCompanySettings(companySettingsUpsertInputModel, loggedInContext, validationMessages);

                    if (companySettingsUpsertInputModel.Key == "ProbationDuration")
                    {
                        JobInputModel GetJobModel = new JobInputModel();
                        GetJobModel.IsForProbation = true;
                        List<TimeSheetJobDetails> timeSheetJobDetails = _timeSheetRepository.GetTimeSheetJobDetails(GetJobModel, loggedInContext, validationMessages);

                        if (timeSheetJobDetails.Count > 0)
                        {
                            foreach (var timeSheetJob in timeSheetJobDetails)
                            {
                                RecurringJob.RemoveIfExists("Probation-Job" + timeSheetJob.JobId.ToString());
                                RecurringJob.RemoveIfExists(timeSheetJob.JobId.ToString());
                                JobInputModel jobModel = new JobInputModel();
                                jobModel.JobId = timeSheetJob.JobId.ToString();
                                jobModel.IsArchived = true;
                                jobModel.IsForProbation = true;
                                var archivedId = _timeSheetRepository.UpsertTimeSheetJobDetails(jobModel, loggedInContext, validationMessages);
                            }
                        }

                        var JobId = Guid.NewGuid();
                        RecurringJob.AddOrUpdate("Probation-Job" + JobId.ToString(),
                        () => RunProbationJob(companySettingsUpsertInputModel, loggedInContext, validationMessages),
                            "0 0 1/1 * *");

                        JobInputModel jobInputModel = new JobInputModel();
                        jobInputModel.JobId = "Probation-Job" + JobId.ToString();
                        jobInputModel.IsArchived = false;
                        jobInputModel.IsForProbation = true;
                        var id = _timeSheetRepository.UpsertTimeSheetJobDetails(jobInputModel, loggedInContext, validationMessages);
                    }
                    return companySettingsUpsertInputModel.CompanySettingsId;
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
            else
            {
                companySettingsUpsertInputModel.CompanySettingsId = null;
                companySettingsUpsertInputModel.CompanySettingsId = _masterDataManagementRepository.UpsertCompanySettings(companySettingsUpsertInputModel, loggedInContext, validationMessages);

                if (companySettingsUpsertInputModel.Key == "ProbationDuration")
                {
                    JobInputModel GetJobModel = new JobInputModel();
                    GetJobModel.IsForProbation = true;
                    List<TimeSheetJobDetails> timeSheetJobDetails = _timeSheetRepository.GetTimeSheetJobDetails(GetJobModel, loggedInContext, validationMessages);

                    if (timeSheetJobDetails.Count > 0)
                    {
                        foreach (var timeSheetJob in timeSheetJobDetails)
                        {
                            RecurringJob.RemoveIfExists("Probation-Job" + timeSheetJob.JobId.ToString());
                            RecurringJob.RemoveIfExists(timeSheetJob.JobId.ToString());
                            JobInputModel jobModel = new JobInputModel();
                            jobModel.JobId = timeSheetJob.JobId.ToString();
                            jobModel.IsArchived = true;
                            jobModel.IsForProbation = true;
                            var archivedId = _timeSheetRepository.UpsertTimeSheetJobDetails(jobModel, loggedInContext, validationMessages);
                        }
                    }

                    var JobId = Guid.NewGuid();
                    RecurringJob.AddOrUpdate("Probation-Job" + JobId.ToString(),
                    () => RunProbationJob(companySettingsUpsertInputModel, loggedInContext, validationMessages),
                        "0 0 1/1 * *");

                    JobInputModel jobInputModel = new JobInputModel();
                    jobInputModel.JobId = "Probation-Job" + JobId.ToString();
                    jobInputModel.IsArchived = false;
                    jobInputModel.IsForProbation = true;
                    var id = _timeSheetRepository.UpsertTimeSheetJobDetails(jobInputModel, loggedInContext, validationMessages);
                }
                return companySettingsUpsertInputModel.CompanySettingsId;
            }
        }

        public void RunProbationJob(CompanySettingsUpsertInputModel companySettingsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<LineManagerOutputModel> lineManagerOutputModel = _timeSheetRepository.GetLineManagersWithTimeZones(loggedInContext, validationMessages);

            foreach (var lineManager in lineManagerOutputModel)
            {
                List<ReportingMembersDetailsModel> reportingMembers = new List<ReportingMembersDetailsModel>();
                if (lineManager.ReportingMembers != null)
                {
                    reportingMembers = JsonConvert.DeserializeObject<List<ReportingMembersDetailsModel>>(lineManager.ReportingMembers);
                }

                if (reportingMembers.Count > 0)
                {
                    foreach (var reportingMember in reportingMembers)
                    {
                        int probationDays = Int32.Parse(companySettingsUpsertInputModel.Value);
                        DateTime executionDate;
                        if (probationDays == 0 || probationDays < 5)
                        {
                            executionDate = reportingMember.JoinedDate.AddDays(probationDays);
                        }
                        else
                        {
                            executionDate = reportingMember.JoinedDate.AddDays(probationDays - 5);
                        }
                        if(executionDate.Date == DateTime.Now.Date)
                        {
                            _notificationService.SendNotification((new NotificationModelForProbationAssign(
                                                          string.Format(NotificationSummaryConstants.ProbationAssignNotification,
                                                              reportingMember.Name),reportingMember.ChildId,reportingMember.Name)), loggedInContext, lineManager.UserId);
                        }
                    }
                }
            }
        }
        public List<CompanySettingsSearchOutputModel> GetCompanySettings(CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? importConfiguration = false)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanySettings", "MasterDataManagement Service"));
            LoggingManager.Debug(companySettingsSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetCompetenciesCommandId, companySettingsSearchInputModel, loggedInContext);

            if (importConfiguration == false)
            {
                List<ParamsInputModel> inputParams = new List<ParamsInputModel>();
                var paramsModel = new ParamsInputModel();
                paramsModel.Type = "Guid?";
                paramsModel.Key = "companySettingsId";
                paramsModel.Value = companySettingsSearchInputModel.CompanyId;
                inputParams.Add(paramsModel);

                paramsModel = new ParamsInputModel();
                paramsModel.Type = "string";
                paramsModel.Key = "key";
                paramsModel.Value = companySettingsSearchInputModel.Key;
                inputParams.Add(paramsModel);

                paramsModel = new ParamsInputModel();
                paramsModel.Type = "string";
                paramsModel.Key = "description";
                paramsModel.Value = companySettingsSearchInputModel.Description;
                inputParams.Add(paramsModel);

                paramsModel = new ParamsInputModel();
                paramsModel.Type = "string";
                paramsModel.Key = "value";
                paramsModel.Value = companySettingsSearchInputModel.Value;
                inputParams.Add(paramsModel);

                paramsModel = new ParamsInputModel();
                paramsModel.Type = "string";
                paramsModel.Key = "searchText";
                paramsModel.Value = companySettingsSearchInputModel.SearchText;
                inputParams.Add(paramsModel);

                paramsModel = new ParamsInputModel();
                paramsModel.Type = "bool?";
                paramsModel.Key = "isArchived";
                paramsModel.Value = companySettingsSearchInputModel.IsArchived;
                inputParams.Add(paramsModel);

                paramsModel = new ParamsInputModel();
                paramsModel.Type = "bool?";
                paramsModel.Key = "isSystemApp";
                paramsModel.Value = companySettingsSearchInputModel.IsSystemApp;
                inputParams.Add(paramsModel);

                paramsModel = new ParamsInputModel();
                paramsModel.Type = "bool?";
                paramsModel.Key = "isFromExport";
                paramsModel.Value = companySettingsSearchInputModel.IsFromExport;
                inputParams.Add(paramsModel);

                var result = ApiWrapper.GetApiCallsWithAuthorisation(RouteConstants.ASGetCompanySettingsDetails, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], inputParams, loggedInContext.AccessToken).Result;
                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
                if (responseJson.Success)
                {
                    var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                    var companiesList = JsonConvert.DeserializeObject<List<CompanySettingsSearchOutputModel>>(jsonResponse);
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
                    return new List<CompanySettingsSearchOutputModel>();
                }
            }
            else
            {
                if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
                {
                    return null;
                }
                List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInContext, validationMessages).ToList();
                return companySettings;
            }
        }

        public UsersInitialDataModel GetUsersInitialData(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUsersInitialData", "MasterDataManagement Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            CompanySettingsSearchInputModel companySettingsSearchInputModel = new CompanySettingsSearchInputModel() { IsArchived = false };
            EntityRoleFeatureSearchInputModel entityRoleFeatureSearchInputModel = new EntityRoleFeatureSearchInputModel();
            UsersInitialDataModel usersInitialData = new UsersInitialDataModel()
            {
                TimeSheetButtonDetails = JsonConvert.SerializeObject(GetEnableorDisableTimesheetButtons(loggedInContext)),
                EntityFeatures = _entityRoleFeatureRepository.SearchEntityRoleFeaturesByUserId(entityRoleFeatureSearchInputModel, loggedInContext, validationMessages).ToList(),
                AddOrEditCustomAppIsRequired = GetAddOrEditCustomAppIsRequired(loggedInContext, validationMessages)
            };
            return usersInitialData;
        }

        public TimesheetDisableorEnable GetEnableorDisableTimesheetButtons(LoggedInContext loggedInContext)
        {
            if (!CheckIpAddressExists(loggedInContext))
            {
                LoggingManager.Warn($"Some one with IP address {loggedInContext.RequestedHostAddress} tried to access the BTrak.");

                return new TimesheetDisableorEnable { TimeSheetRestricted = true };
            }

            var indianTimeDetails = TimeZoneHelper.GetIstTime();
            DateTimeOffset? buttonClickedDate = indianTimeDetails?.UserTimeOffset;

            if (!string.IsNullOrEmpty(loggedInContext.RequestedHostAddress) && loggedInContext.RequestedHostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + loggedInContext.RequestedHostAddress);

                var userTimeDetails = TimeZoneHelper.GetUserCurrentTimeByIp(loggedInContext.RequestedHostAddress);
                buttonClickedDate = userTimeDetails?.UserTimeOffset;
            }

            TimesheetDisableorEnableEntity enableorDisableTimesheetButtons = _timeSheetRepository.GetEnableorDisableTimesheetButtons(loggedInContext.LoggedInUserId, buttonClickedDate);

            if (enableorDisableTimesheetButtons != null)
            {
                TimesheetDisableorEnable timesheetDetails = new TimesheetDisableorEnable
                {
                    StartTime = enableorDisableTimesheetButtons.StartTime != null ? GetTimeInHoursandMinutes(enableorDisableTimesheetButtons.StartTime.Value.UtcDateTime, loggedInContext.LoggedInUserId) : null,
                    LunchStartTime = enableorDisableTimesheetButtons.LunchStartTime != null ? GetTimeInHoursandMinutes(enableorDisableTimesheetButtons.LunchStartTime.Value.UtcDateTime, loggedInContext.LoggedInUserId) : null,
                    LunchEndTime = enableorDisableTimesheetButtons.LunchEndTime != null ? GetTimeInHoursandMinutes(enableorDisableTimesheetButtons.LunchEndTime.Value.UtcDateTime, loggedInContext.LoggedInUserId) : null,
                    FinishTime = enableorDisableTimesheetButtons.FinishTime != null ? GetTimeInHoursandMinutes(enableorDisableTimesheetButtons.FinishTime.Value.UtcDateTime, loggedInContext.LoggedInUserId) : null,
                    BreakInTime = enableorDisableTimesheetButtons.BreakInTime != null ? GetTimeInHoursandMinutes(enableorDisableTimesheetButtons.BreakInTime.Value.UtcDateTime, loggedInContext.LoggedInUserId) : null,
                    BreakOutTime = enableorDisableTimesheetButtons.BreakOutTime != null ? GetTimeInHoursandMinutes(enableorDisableTimesheetButtons.BreakOutTime.Value.UtcDateTime, loggedInContext.LoggedInUserId) : null,
                    BreakIn = enableorDisableTimesheetButtons.IsBreakIn,
                    BreakOut = enableorDisableTimesheetButtons.IsBreakOut,
                    Start = enableorDisableTimesheetButtons.IsStart,
                    Finish = enableorDisableTimesheetButtons.IsFinish,
                    LunchStart = enableorDisableTimesheetButtons.IsLunchStart,
                    LunchEnd = enableorDisableTimesheetButtons.IsLunchEnd,
                    SpentTime = enableorDisableTimesheetButtons.SpentTime,
                };

                return timesheetDetails;
            }

            return null;
        }

        public bool CheckIpAddressExists(LoggedInContext loggedInContext)
        {
            string ipAddressVal = _timeSheetRepository.IsIpExisting(loggedInContext);
            if (!string.IsNullOrEmpty(ipAddressVal))
            {
                return true;
            }
            return false;
        }

        public string GetTimeInHoursandMinutes(DateTime? time, Guid loggedUserId)
        {
            if (time != null)
            {
                Guid? timeZoneId;
                string defaultTimeZoneString;
                var userDetails = _userRepository.UserDetails(loggedUserId);
                if (userDetails?.TimeZoneId == null)
                {
                    timeZoneId = AppConstants.DefaultTimeZoneId;
                    defaultTimeZoneString = AppConstants.DefaultTimeZone;
                }
                else
                {
                    timeZoneId = userDetails.TimeZoneId;
                    defaultTimeZoneString = null;
                }

                DateTime? indianTime = ConvertFromUtCtoLocal(time, timeZoneId, defaultTimeZoneString);
                int? hours = indianTime?.TimeOfDay.Hours;
                int? minutes = indianTime?.TimeOfDay.Minutes;
                if (hours < 10 && minutes < 10)
                {
                    return "0" + hours + ":" + "0" + minutes;
                }
                if (hours < 10)
                {
                    return "0" + hours + ":" + minutes;
                }
                if (minutes < 10)
                {
                    return hours + ":" + "0" + minutes;
                }
                return hours + ":" + minutes;
            }
            return null;
        }

        public DateTime? ConvertFromUtCtoLocal(DateTime? time, Guid? timeZoneId, string defaultTimeZone = null)
        {
            if (time != null)
            {
                string localTimeZone = _masterTableRepository.GetTimeZone(Guid.Parse(MasterDataTypeConstants.TimeZoneId), Guid.Parse(timeZoneId.ToString()));
                if (localTimeZone == null)
                    return time;

                var timeZoneList = TimeZoneInfo.GetSystemTimeZones();

                if (timeZoneList.Select(tz => tz.StandardName).Contains(localTimeZone))
                {
                    TimeZoneInfo timeZone = TimeZoneInfo.FindSystemTimeZoneById(defaultTimeZone == null ? localTimeZone : defaultTimeZone);
                    DateTime localTime = TimeZoneInfo.ConvertTimeFromUtc(Convert.ToDateTime(time), timeZone);
                    return localTime;
                }
            }
            return time;
        }

        public List<UserStoryTypeDropDownOutputModel> GetUserStoryTypeDropDown(bool? isArchived, string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserStoryTypeDropDown", "searchText", searchText, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetEducationLevelsCommandId, searchText, loggedInContext);
            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            LoggingManager.Info("Getting user story type List");
            List<UserStoryTypeDropDownOutputModel> getEducationLevelsDropDownList = _masterDataManagementRepository.GetUserStoryTypeDropDown(isArchived, searchText, loggedInContext, validationMessages).ToList();
            return getEducationLevelsDropDownList;
        }

        public List<LeaveFrequencySearchOutputModel> GetLeaveFrequencies(LeaveFrequencySearchInputModel leaveFrequencySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeaveFrequencies", "MasterDataManagement Service"));
            LoggingManager.Debug(leaveFrequencySearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetCompetenciesCommandId, leaveFrequencySearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<LeaveFrequencySearchOutputModel> leaveFrequencies = _masterDataManagementRepository.GetLeaveFrequencies(leaveFrequencySearchInputModel, loggedInContext, validationMessages).ToList();
            return leaveFrequencies;
        }

        public Guid? UpsertLeaveFrequency(LeaveFrequencyUpsertInputModel leaveFrequencyUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Leave Frequency", "MasterDataManagement Service"));

            LoggingManager.Debug(leaveFrequencyUpsertInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertLeaveFrequencyCommandId, leaveFrequencyUpsertInputModel, loggedInContext);

            if (!MasterDataValidationHelper.UpsertLeaveFrequencyValidations(leaveFrequencyUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? LeaveFrequencyId = _masterDataManagementRepository.UpsertLeaveFrequency(leaveFrequencyUpsertInputModel, loggedInContext, validationMessages);

            return LeaveFrequencyId;
        }

        public List<LeaveFormulSearchOutputModel> GetLeaveFormula(LeaveFormulaSearchInputModel leaveFormulaSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeaveFormula", "MasterDataManagement Service"));
            LoggingManager.Debug(leaveFormulaSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetCompetenciesCommandId, leaveFormulaSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<LeaveFormulSearchOutputModel> leaveFromula = _masterDataManagementRepository.GetLeaveFormula(leaveFormulaSearchInputModel, loggedInContext, validationMessages).ToList();
            return leaveFromula;
        }

        public Guid? UpsertLeaveFormula(LeaveFormulaUpsertInputModel leaveFormulaUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Leave Frequency", "MasterDataManagement Service"));

            LoggingManager.Debug(leaveFormulaUpsertInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertLeaveFrequencyCommandId, leaveFormulaUpsertInputModel, loggedInContext);

            if (!MasterDataValidationHelper.UpsertLeaveFormulaValidations(leaveFormulaUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? LeaveFrequencyId = _masterDataManagementRepository.UpsertLeaveFormula(leaveFormulaUpsertInputModel, loggedInContext, validationMessages);

            return LeaveFrequencyId;
        }

        public List<EncashmentTypeSearchOutputModel> GetEncashmentTypes(SearchCriteriaInputModelBase searchCriteriaInputModelBase, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEncashmentTypes", "MasterDataManagement Service"));

            _auditService.SaveAudit(AppCommandConstants.GetEncashmentTypeCommandId, searchCriteriaInputModelBase, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<EncashmentTypeSearchOutputModel> encashmentTypes = _masterDataManagementRepository.GetEncashmentTypes(searchCriteriaInputModelBase, loggedInContext, validationMessages).ToList();
            return encashmentTypes;
        }

        public List<RestrictionTypeSearchOutputModel> GetRestrictionTypes(RestrictionTypeSearchInputModel restrictionTypeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRestrictionTypes", "MasterDataManagement Service"));
            LoggingManager.Debug(restrictionTypeSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetRestrictionTypeCommandId, restrictionTypeSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<RestrictionTypeSearchOutputModel> restrictionTypes = _masterDataManagementRepository.GetRestictiontypes(restrictionTypeSearchInputModel, loggedInContext, validationMessages).ToList();
            return restrictionTypes;
        }

        public Guid? UpsertRestrictionType(RestrictionTypeUpsertInputModel restrictionTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Restriction Type", "MasterDataManagement Service"));

            LoggingManager.Debug(restrictionTypeUpsertInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertGetRestrictionTypesCommandId, restrictionTypeUpsertInputModel, loggedInContext);

            Guid? LeaveFrequencyId = _masterDataManagementRepository.UpsertRestrictiontype(restrictionTypeUpsertInputModel, loggedInContext, validationMessages);

            return LeaveFrequencyId;
        }

        public Guid? UpsertSoftLabelConfigurations(UpsertSoftLabelConfigurationsModel softLabelUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSoftLabelConfigurations", "MasterDataManagement Service"));

            LoggingManager.Debug(softLabelUpsertInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.UpsertSoftDetailsCommandId, softLabelUpsertInputModel, loggedInContext);

            if (!MasterDataValidationHelper.UpsertSoftLabelConfigurationsValidation(softLabelUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            softLabelUpsertInputModel.SoftLabelConfigurationId = _masterDataManagementRepository.UpsertSoftLabelConfigurations(softLabelUpsertInputModel, loggedInContext, validationMessages);

            return softLabelUpsertInputModel.SoftLabelConfigurationId;
        }

        public List<SoftLabelApiReturnModel> GetSoftLabelsConfigurationsList(SoftLabelsSearchInputModel softLabelsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanySettings", "MasterDataManagement Service"));
            LoggingManager.Debug(softLabelsSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetSoftDetailsCommandId, softLabelsSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<SoftLabelApiReturnModel> softLabelsList = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).ToList();
            return softLabelsList;
        }

        public SoftLabelApiReturnModel GetSoftLabelById(Guid? softLabelId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSoftLabelById", "MasterDataManagement Service" + "and softlabel id=" + softLabelId));

            LoggingManager.Debug(softLabelId?.ToString());

            if (!MasterDataValidationHelper.GetSoftLabelByIdValidations(softLabelId, loggedInContext, validationMessages))
                return null;

            var softLabelsSearchInputModel = new SoftLabelsSearchInputModel
            {
                SoftLabelConfigurationId = softLabelId
            };

            SoftLabelApiReturnModel softLabelApiReturnModel = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (softLabelApiReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundSoftLabelWithTheId, softLabelId)
                });

                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetSoftDetailsCommandId, softLabelsSearchInputModel, loggedInContext);


            LoggingManager.Debug(softLabelApiReturnModel.ToString());

            return softLabelApiReturnModel;
        }


        public List<ModuleDetailsModel> GetModulesList(ModuleDetailsModel moduleDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserStoryTypeDropDown", "searchText", moduleDetailsModel.SearchText, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetEducationLevelsCommandId, moduleDetailsModel.SearchText, loggedInContext);
            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }


            List<ModuleDetailsModel> modulesList = _masterDataManagementRepository.GetModulesList(moduleDetailsModel, loggedInContext, validationMessages).ToList();
            return modulesList;
        }

        public List<ModuleDetailsModel> GetCompanyModulesList(ModuleDetailsModel moduleDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? importConfiguration = false)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserStoryTypeDropDown", "searchText", moduleDetailsModel.SearchText, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetEducationLevelsCommandId, moduleDetailsModel.SearchText, loggedInContext);
            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            List<ModuleDetailsModel> modulesList = _masterDataManagementRepository.GetCompanyModulesList(moduleDetailsModel, loggedInContext, validationMessages).ToList();
            return modulesList;
        }

        public Guid? UpsertCompanyModule(ModuleDetailsModel moduleDetailsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Company Settings", "MasterDataManagement Service"));

            LoggingManager.Debug(moduleDetailsModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetJobCategoryDetailsCommandId, moduleDetailsModel, loggedInContext);

            if (moduleDetailsModel.ModuleIdsList != null && moduleDetailsModel.ModuleIds.Count == 0  && moduleDetailsModel.ModuleIdsList.Length > 0)
            {
                List<string> moduleIds = moduleDetailsModel.ModuleIdsList.Split(',').ToList();
                moduleDetailsModel.ModuleIds = moduleIds.ConvertAll(Guid.Parse);
            }

            moduleDetailsModel.ModuleIdXml = Utilities.ConvertIntoListXml(moduleDetailsModel.ModuleIds);

            moduleDetailsModel.CompanyModuleId = _masterDataManagementRepository.UpsertCompanyModule(moduleDetailsModel, loggedInContext, validationMessages);

            return moduleDetailsModel.CompanyModuleId;
        }

        public string UpsertCompanyLogo(UploadProfileImageInputModel uploadProfileImageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Company Settings", "MasterDataManagement Service"));

            LoggingManager.Debug(uploadProfileImageInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetJobCategoryDetailsCommandId, uploadProfileImageInputModel, loggedInContext);

            var result = ApiWrapper.PostentityToApi(RouteConstants.ASUpsertCompanyLogo, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], uploadProfileImageInputModel, loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            var profileImage = JsonConvert.SerializeObject(responseJson.Data);
            if (responseJson.Success && (profileImage != null && profileImage != "null"))
            {
                uploadProfileImageInputModel.ProfileImage = _masterDataManagementRepository.UpsertCompanyLogo(uploadProfileImageInputModel, loggedInContext, validationMessages);

                return uploadProfileImageInputModel.ProfileImage;
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

        public List<RateSheetOutputModel> GetRateSheets(RateSheetSearchCriteriaInputModel rateSheetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Rate Sheets", "rateSheetSearchCriteriaInputModel", rateSheetSearchCriteriaInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetAllRateSheetsCommandId, rateSheetSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                rateSheetSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting rate sheet list ");
            List<RateSheetOutputModel> rateSheetList = _masterDataManagementRepository.GetRateSheets(rateSheetSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return rateSheetList;
        }

        public List<RateSheetForOutputModel> GetRateSheetForNames(RateSheetForSearchCriteriaInputModel rateSheetForSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Rate Sheet for", "rateSheetSearchCriteriaInputModel", rateSheetForSearchCriteriaInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetAllRateSheetForCommandId, rateSheetForSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                rateSheetForSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting rate sheet for list ");
            List<RateSheetForOutputModel> rateSheetForList = _masterDataManagementRepository.GetRateSheetForNames(rateSheetForSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return rateSheetForList;
        }

        public Guid? UpsertRateSheet(RateSheetInputModel rateSheetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertRateSheet", "Master Data Management Service"));

            LoggingManager.Debug(rateSheetInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertRateSheetValidation(rateSheetInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            rateSheetInputModel.RateSheetId = _masterDataManagementRepository.UpsertRateSheet(rateSheetInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertRateSheetCommandId, rateSheetInputModel, loggedInContext);

            LoggingManager.Debug(rateSheetInputModel.RateSheetId?.ToString());

            return rateSheetInputModel.RateSheetId;
        }

        public List<PeakHourOutputModel> GetPeakHours(PeakHourSearchCriteriaInputModel peakHourSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Peak Hours", "peakHourSearchCriteriaInputModel", peakHourSearchCriteriaInputModel, "Master Data Management Service"));
            _auditService.SaveAudit(AppCommandConstants.GetAllPeakHoursCommandId, peakHourSearchCriteriaInputModel, loggedInContext);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext,
                peakHourSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting rate sheet list ");
            List<PeakHourOutputModel> peakHourList = _masterDataManagementRepository.GetPeakHours(peakHourSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return peakHourList;
        }

        public Guid? UpsertPeakHour(PeakHourInputModel peakHourInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertPeakHour", "Master Data Management Service"));

            LoggingManager.Debug(peakHourInputModel.ToString());

            if (!MasterDataValidationHelper.UpsertPeakHourValidation(peakHourInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            peakHourInputModel.PeakHourId = _masterDataManagementRepository.UpsertPeakHour(peakHourInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertPeakHourCommandId, peakHourInputModel, loggedInContext);

            LoggingManager.Debug(peakHourInputModel.PeakHourId?.ToString());

            return peakHourInputModel.PeakHourId;
        }

        public List<WeekdayOutputModel> GetWeekdays(WeekdaySearchCriteriaInputModel weekdaySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetWeekdays", "MasterDataManagement Service"));
            LoggingManager.Debug(weekdaySearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetWeekdaysCommandId, weekdaySearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<WeekdayOutputModel> weekdaysList = _masterDataManagementRepository.GetWeekdays(weekdaySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();
            return weekdaysList;
        }

        public List<ProfessionalTaxRange> GetProfessionalTaxRanges(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<ProfessionalTaxRange> taxSlabList = _masterDataManagementRepository.GetProfessionalTaxRanges(loggedInContext, validationMessages).ToList();
            return taxSlabList;
        }

        public List<TaxSlabs> GetTaxSlabs(TaxSlabs taxSlabs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<TaxSlabs> taxSlabList = _masterDataManagementRepository.GetTaxSlabs(taxSlabs, loggedInContext, validationMessages).ToList();
            return taxSlabList;
        }

        public Guid? UpsertProfessionalTaxRanges(ProfessionalTaxRange professionalTaxRange, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Language", "Master Data Management Service"));

            LoggingManager.Debug(professionalTaxRange.ToString());

            //if (!MasterDataValidationHelper.UpsertJobCategoriesValidation(ProfessionalTaxRange, loggedInContext, validationMessages))
            //{
            //    return null;
            //}

            var result = _masterDataManagementRepository.UpsertProfessionalTaxRanges(professionalTaxRange, loggedInContext, validationMessages);



            return result;
        }

        public Guid? UpsertTaxSlabs(TaxSlabsUpsertInputModel taxSlabs, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Language", "Master Data Management Service"));

            LoggingManager.Debug(taxSlabs.ToString());

            if (taxSlabs.PayRollTemplateIds != null)
            {
                taxSlabs.PayRollTempalteXml = Utilities.ConvertIntoListXml(taxSlabs.PayRollTemplateIds);
            }

            //if (!MasterDataValidationHelper.UpsertJobCategoriesValidation(ProfessionalTaxRange, loggedInContext, validationMessages))
            //{
            //    return null;
            //}

            var result = _masterDataManagementRepository.UpsertTaxSlabs(taxSlabs, loggedInContext, validationMessages);



            return result;
        }

        public bool GetCompanyWorkItemStartFunctionalityRequired(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanyWorkItemStartFunctionalityRequired", "Master Data Management Service"));
            bool value = _masterDataManagementRepository.GetCompanyWorkItemStartFunctionalityRequired(loggedInContext, validationMessages);
            return value;
        }
        public bool GetAddOrEditCustomAppIsRequired(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAddOrEditCustomAppIsRequired", "Master Data Management Service"));
            var isAllowAddOrEditCustomApp = ConfigurationManager.AppSettings["IsAllowAddOrEditCustomApp"];
            if (isAllowAddOrEditCustomApp == "false")
                return false;
            else
                return _masterDataManagementRepository.GetAddOrEditCustomAppIsRequired(loggedInContext, validationMessages);
        }

        public Guid? UpsertSpecificDay(SpecificDayInputModel holidayInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSpecificDay", "MasterDataManagement Service"));

            if (!MasterDataValidationHelper.UpsertSpecificDayValidation(holidayInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            holidayInputModel.SpecificDayId = _masterDataManagementRepository.UpsertSpecificDay(holidayInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertSpecificDayCommandId, holidayInputModel, loggedInContext);

            LoggingManager.Debug(holidayInputModel.SpecificDayId?.ToString());

            return holidayInputModel.SpecificDayId;
        }

        public List<SpecificDayOutPutModel> GetSpecificDays(SpecificDaySearchCriteriaInputModel holidaySearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSpecificDays", "MasterDataManagement Service"));
            LoggingManager.Debug(holidaySearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetSpecificDayCommandId, holidaySearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<SpecificDayOutPutModel> specificDaysList = _masterDataManagementRepository.GetSpecificDays(holidaySearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return specificDaysList;
        }

        public DocumentSettingsSearchOutputModel GetDocumentStorageSettings(CompanySettingsSearchInputModel companySettingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDocumentStorageSettings", "MasterDataManagement Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCompetenciesCommandId, companySettingsSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            DocumentSettingsSearchOutputModel companySettings = _masterDataManagementRepository.GetDocumentStorageSettings(companySettingsSearchInputModel, loggedInContext, validationMessages);
            return companySettings;
        }

        public List<CompanyHierarchyModel> GetCompanyHierarchicalStructure(CompanyHierarchyModel companyHierarchyModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanyHierarchicalStructure", "MasterDataManagement Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCompetenciesCommandId, companyHierarchyModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<CompanyHierarchyModel> companyStructure = _masterDataManagementRepository.GetCompanyHierarchicalStructure(companyHierarchyModel, loggedInContext, validationMessages).ToList();

            return companyStructure;
        }

        public Guid? UpsertCompanyStructure(CompanyHierarchyModel companyHierarchyModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCompanyStructure", "MasterDataManagement Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCompetenciesCommandId, companyHierarchyModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            companyHierarchyModel.Address = Utilities.ConvertObjectToJSON(new Address
            {
                City = companyHierarchyModel.City,
                PostalCode = companyHierarchyModel.PostalCode,
                Street = companyHierarchyModel.Street,
                State = companyHierarchyModel.State
            });

            Guid? companyStructure = _masterDataManagementRepository.UpsertCompanyStructure(companyHierarchyModel, loggedInContext, validationMessages);

            return companyStructure;
        }

        public Guid? UpsertBusinessUnit(BusinessUnitModel businessUnitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertBusinessUnit", "MasterDataManagement Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCompetenciesCommandId, businessUnitModel, loggedInContext);

            Guid? businessUnitId;
            if (businessUnitModel != null && businessUnitModel.IsArchive == true)
            {
                businessUnitId = _masterDataManagementRepository.DeleteBusinessUnit(businessUnitModel, loggedInContext, validationMessages);
            }
            else
            {
                if (businessUnitModel != null && businessUnitModel.EmployeeIds != null && businessUnitModel.EmployeeIds.Count > 0)
                {
                    businessUnitModel.EmployeeIdsXML = Utilities.ConvertIntoListXml(businessUnitModel.EmployeeIds);
                }
                else
                {
                    businessUnitModel.EmployeeIdsXML = null;
                }
                businessUnitId = _masterDataManagementRepository.UpsertBusinessUnit(businessUnitModel, loggedInContext, validationMessages);
            }

            return businessUnitId;
        }

        public string SearchEntities(Guid? entityId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchEntities", "MasterDataManagement Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCompetenciesCommandId, entityId, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<SearchEntityApiOutputModel> companyStructure = _masterDataManagementRepository.SearchEntities(entityId, loggedInContext, validationMessages).ToList();

            foreach (SearchEntityApiOutputModel entity in companyStructure.Where(x => x.IsBranch == true).ToList())
            {
                if (!string.IsNullOrEmpty(entity.Address))
                {
                    Address result = JsonConvert.DeserializeObject<Address>(entity.Address);
                    entity.State = result.State;
                    entity.Street = result.Street;
                    entity.PostalCode = result.PostalCode;
                    entity.City = result.City;
                }

            }

            List<SearchEntityApiOutputModel> searchEntityApiOutput = GenerateHierarchy(companyStructure, null, 0);

            JsonSerializerSettings settings = new JsonSerializerSettings
            {
                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore
            };

            var entitiesJson = "";

            entitiesJson = JsonConvert.SerializeObject(searchEntityApiOutput, settings);

            return entitiesJson;
        }

        public string SearchBusinessUnits(BusinessUnitModel businessUnitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchBusinessUnits", "MasterDataManagement Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCompetenciesCommandId, businessUnitModel.BusinessUnitId, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<SearchBusinessUnitApiOutputModel> businessUnits = _masterDataManagementRepository.SearchBusinessUnits(businessUnitModel, loggedInContext, validationMessages).ToList();

            foreach (SearchBusinessUnitApiOutputModel businessUnit in businessUnits)
            {
                if (!string.IsNullOrEmpty(businessUnit.EmployeeIdsJson))
                {
                    List<EmployeeIdsModel> selectedEmployeeIds = JsonConvert.DeserializeObject<List<EmployeeIdsModel>>(businessUnit.EmployeeIdsJson);
                    businessUnit.EmployeeIds = selectedEmployeeIds.Select(x => x.EmployeeId).ToList();
                }
            }

            List<SearchBusinessUnitApiOutputModel> searchBusinessUnitsApiOutput = GenerateBusinessUnitsHierarchy(businessUnits, null, 0);

            JsonSerializerSettings settings = new JsonSerializerSettings
            {
                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore
            };

            var businessUnitJson = "";

            businessUnitJson = JsonConvert.SerializeObject(searchBusinessUnitsApiOutput, settings);

            return businessUnitJson;
        }

        public List<BusinessUnitDropDownModel> GetBusinessUnitDropDown(BusinessUnitDropDownModel businessUnitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBusinessUnitDropDown", "MasterDataManagement Service"));

            _auditService.SaveAudit(AppCommandConstants.GetCompetenciesCommandId, businessUnitModel.BusinessUnitId, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<BusinessUnitDropDownModel> businessUnits = _masterDataManagementRepository.GetBusinessUnitDropDown(businessUnitModel, loggedInContext, validationMessages).ToList();

            return businessUnits;

        }
        private List<SearchEntityApiOutputModel> GenerateHierarchy(List<SearchEntityApiOutputModel> entityApiOutputModels, Guid? parentSectionId, int sectionLevel)
        {
            return entityApiOutputModels.Where(x => x.ParentEntityId.Equals(parentSectionId)).Select(sectionDetails => new SearchEntityApiOutputModel
            {
                Description = sectionDetails.Description,
                EntityId = sectionDetails.EntityId,
                IsBranch = sectionDetails.IsBranch,
                IsCountry = sectionDetails.IsCountry,
                IsGroup = sectionDetails.IsGroup,
                IsEntity = sectionDetails.IsEntity,
                ParentEntityId = sectionDetails.ParentEntityId,
                EntityName = sectionDetails.EntityName,
                TimeZoneId = sectionDetails.TimeZoneId,
                TimeZoneName = sectionDetails.TimeZoneName,
                IsHeadOffice = sectionDetails.IsHeadOffice,
                Address = sectionDetails.Address,
                CurrencyId = sectionDetails.CurrencyId,
                CurrencyCode = sectionDetails.CurrencyCode,
                CurrencyName = sectionDetails.CurrencyName,
                DefaultPayrollTemplateId = sectionDetails.DefaultPayrollTemplateId,
                PayrollName = sectionDetails.PayrollName,
                PayrollShortName = sectionDetails.PayrollShortName,
                TimeStamp = sectionDetails.TimeStamp,
                State = sectionDetails.State,
                City = sectionDetails.City,
                Street = sectionDetails.Street,
                PostalCode = sectionDetails.PostalCode,
                CountryId = sectionDetails.CountryId,
                CountryName = sectionDetails.CountryName,
                Children = GenerateHierarchy(entityApiOutputModels, sectionDetails.EntityId, sectionLevel + 1)
            }).ToList();
        }

        private List<SearchBusinessUnitApiOutputModel> GenerateBusinessUnitsHierarchy(List<SearchBusinessUnitApiOutputModel> businessUnitApiOutputModels, Guid? parentSectionId, int sectionLevel)
        {
            return businessUnitApiOutputModels.Where(x => x.ParentBusinessUnitId.Equals(parentSectionId)).Select(sectionDetails => new SearchBusinessUnitApiOutputModel
            {
                BusinessUnitName = sectionDetails.BusinessUnitName,
                BusinessUnitId = sectionDetails.BusinessUnitId,
                ParentBusinessUnitId = sectionDetails.ParentBusinessUnitId,
                TimeStamp = sectionDetails.TimeStamp,
                EmployeeIds = sectionDetails.EmployeeIds,
                EmployeeNames = sectionDetails.EmployeeNames,
                CanAddEmployee = sectionDetails.CanAddEmployee,
                Children = GenerateBusinessUnitsHierarchy(businessUnitApiOutputModels, sectionDetails.BusinessUnitId, sectionLevel + 1)
            }).ToList();
        }
    }
}