using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using Btrak.Models.MasterData;
using Btrak.Models.User;
using Btrak.Models.SoftLabelConfigurations;
using Btrak.Services.MasterData;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.MasterData
{
    public class MasterDataManagementApiController : AuthTokenApiController
    {
        private readonly IMasterDataManagementService _masterDataManagementService;
        public MasterDataManagementApiController(IMasterDataManagementService masterDataManagementService)
        {
            _masterDataManagementService = masterDataManagementService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetStates)]
        public JsonResult<BtrakJsonResult> GetStates(GetStatesSearchCriteriaInputModel getStatesSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get States", "getStatesSearchCriteriaInputModel", getStatesSearchCriteriaInputModel, "Master Data Management Api"));
                if (getStatesSearchCriteriaInputModel == null)
                {
                    getStatesSearchCriteriaInputModel = new GetStatesSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting States list");
                List<GetStatesOutputModel> statesList = _masterDataManagementService.GetStates(getStatesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get States", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get States", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = statesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetStates)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmploymentStatus)]
        public JsonResult<BtrakJsonResult> GetEmploymentStatus(EmploymentStatusSearchCriteriaInputModel getEmploymentStatusSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Employment Status", "getEmploymentStatusSearchCriteriaInputModel", getEmploymentStatusSearchCriteriaInputModel, "Master Data Management Api"));
                if (getEmploymentStatusSearchCriteriaInputModel == null)
                {
                    getEmploymentStatusSearchCriteriaInputModel = new EmploymentStatusSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Employment Status list");
                List<EmploymentStatusOutputModel> employmentStatusList = _masterDataManagementService.GetEmploymentStatus(getEmploymentStatusSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employment Status", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employment Status", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = employmentStatusList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetEmploymentStatus)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLicenceTypes)]
        public JsonResult<BtrakJsonResult> GetLicenceTypes(GetLicenceTypesSearchCriteriaInputModel getLicenceTypesSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Licence Types", "getLicenceTypesSearchCriteriaInputModel", getLicenceTypesSearchCriteriaInputModel, "Master Data Management Api"));
                if (getLicenceTypesSearchCriteriaInputModel == null)
                {
                    getLicenceTypesSearchCriteriaInputModel = new GetLicenceTypesSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Licence Types list");
                List<GetLicenceTypesOutputModel> licenceTypesList = _masterDataManagementService.GetLicenceTypes(getLicenceTypesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Licence Types", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Licence Types", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = licenceTypesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetLicenceTypes)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetNationalities)]
        public JsonResult<BtrakJsonResult> GetNationalities(NationalitySearchInputModel nationalitySearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetNationalities", "MasterDataManagement Api"));

                if (nationalitySearchInputModel == null)
                {
                    nationalitySearchInputModel = new NationalitySearchInputModel {IsArchived = false};
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<NationalityApiReturnModel> nationalities = _masterDataManagementService.GetNationalities(nationalitySearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetNationalities", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetNationalities", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = nationalities, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetNationalities", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetReportingMethods)]
        public JsonResult<BtrakJsonResult> GetReportingMethods(ReportingMethodsSearchCriteriaInputModel getReportingMethodsSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Reporting Methods", "getReportingMethodsSearchCriteriaInputModel", getReportingMethodsSearchCriteriaInputModel, "Master Data Management Api"));
                if (getReportingMethodsSearchCriteriaInputModel == null)
                {
                    getReportingMethodsSearchCriteriaInputModel = new ReportingMethodsSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Reporting Methods list");
                List<ReportingMethodsOutputModel> reportingMethodsList = _masterDataManagementService.GetReportingMethods(getReportingMethodsSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Reporting Methods", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Reporting Methods", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = reportingMethodsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetReportingMethods)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPayFrequency)]
        public JsonResult<BtrakJsonResult> GetPayFrequency(PayFrequencySearchCriteriaInputModel payFrequencySearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPayFrequency", "payFrequencySearchCriteriaInputModel", payFrequencySearchCriteriaInputModel, "Master Data Management Api"));
                if (payFrequencySearchCriteriaInputModel == null)
                {
                    payFrequencySearchCriteriaInputModel = new PayFrequencySearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Pay Frequency list");
                List<PayFrequencyOutputModel> payFrequencyList = _masterDataManagementService.GetPayFrequency(payFrequencySearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayFrequency", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetPayFrequency", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = payFrequencyList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetPayFrequency)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEducationLevels)]
        public JsonResult<BtrakJsonResult> GetEducationLevels(EducationLevelSearchInputModel educationLevelSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Education Levels", "getEducationLevelsSearchCriteriaInputModel", educationLevelSearchInputModel, "Master Data Management Api"));
                if (educationLevelSearchInputModel == null)
                {
                    educationLevelSearchInputModel = new EducationLevelSearchInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Education Level list");
                List<EducationLevelsOutputModel> educationLevelList = _masterDataManagementService.GetEducationLevels(educationLevelSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Education Levels", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Education Levels", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = educationLevelList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetEducationLevels)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEducationLevelsDropDown)]
        public JsonResult<BtrakJsonResult> GetEducationLevelsDropDown(string searchText)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEducationLevelsDropDown", "master data management Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<EducationLevelsDropDownOutputModel> educationLevelsDropDownList = _masterDataManagementService.GetEducationLevelsDropDown(searchText, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEducationLevelsDropDown", "master data management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEducationLevelsDropDown ", "master data management Api"));
                return Json(new BtrakJsonResult { Data = educationLevelsDropDownList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEducationLevelsDropDown", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertSkills)]
        public JsonResult<BtrakJsonResult> UpsertSkills(SkillsInputModel skillsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Skills", "skillsInputModel", skillsInputModel, "MasterDataManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? skillsIdReturned = _masterDataManagementService.UpsertSkills(skillsInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Skills", "MasterDataManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Skills", "MasterDataManagement Api"));
                return Json(new BtrakJsonResult { Data = skillsIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSkills", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSkills)]
        public JsonResult<BtrakJsonResult> GetSkills(SkillsSearchCriteriaInputModel skillsSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetSkills", "skillsSearchCriteriaInputModel", skillsSearchCriteriaInputModel, "Master Data Management Api"));
                if (skillsSearchCriteriaInputModel == null)
                {
                    skillsSearchCriteriaInputModel = new SkillsSearchCriteriaInputModel {IsArchived = false};
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Pay Frequency list");
                List<SkillsOutputModel> skillsList = _masterDataManagementService.GetSkills(skillsSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSkills", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSkills", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = skillsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetSkills)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCompetencies)]
        public JsonResult<BtrakJsonResult> GetCompetencies(GetCompetenciesSearchCriteriaInputModel getCompetenciesSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Competencies", "getCompetenciesSearchCriteriaInputModel", getCompetenciesSearchCriteriaInputModel, "Master Data Management Api"));
                if (getCompetenciesSearchCriteriaInputModel == null)
                {
                    getCompetenciesSearchCriteriaInputModel = new GetCompetenciesSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Competencies list");
                List<CompetenciesOutputModel> competenciesList = _masterDataManagementService.GetCompetencies(getCompetenciesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Competencies", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Competencies", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = competenciesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetCompetencies)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLanguageFluencies)]
        public JsonResult<BtrakJsonResult> GetLanguageFluencies(GetLanguageFluenciesSearchCriteriaInputModel getLanguageFluenciesSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Language Fluencies", "getLanguageFluenciesSearchCriteriaInputModel", getLanguageFluenciesSearchCriteriaInputModel, "Master Data Management Api"));
                if (getLanguageFluenciesSearchCriteriaInputModel == null)
                {
                    getLanguageFluenciesSearchCriteriaInputModel = new GetLanguageFluenciesSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Language Fluencies list");
                List<LanguageFluenciesOutputModel> languageFluenciesList = _masterDataManagementService.GetLanguageFluencies(getLanguageFluenciesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Language Fluencies", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Language Fluencies", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = languageFluenciesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetLanguageFluencies)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLanguages)]
        public JsonResult<BtrakJsonResult> GetLanguages(GetLanguagesSearchCriteriaInputModel getLanguagesSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Languages", "getLanguagesSearchCriteriaInputModel", getLanguagesSearchCriteriaInputModel, "Master Data Management Api"));
                if (getLanguagesSearchCriteriaInputModel == null)
                {
                    getLanguagesSearchCriteriaInputModel = new GetLanguagesSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Languages list");
                List<LanguagesOutputModel> languagesList = _masterDataManagementService.GetLanguages(getLanguagesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Languages", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Languages", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = languagesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetLanguages)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertSubscriptionPaidByOption)]
        public JsonResult<BtrakJsonResult> UpsertSubscriptionPaidByOption(SubscriptionPaidByUpsertInputModel subscriptionPaidByUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSubscriptionPaidByOption", "Master Data Management Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? subscriptionPaidByIdReturned = _masterDataManagementService.UpsertSubscriptionPaidByOption(subscriptionPaidByUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSubscriptionPaidByOption", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSubscriptionPaidByOption", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = subscriptionPaidByIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSubscriptionPaidByOption", "MasterDataManagementApiController ", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSubscriptionPaidByOptions)]
        public JsonResult<BtrakJsonResult> GetSubscriptionPaidByOptions(SubscriptionPaidBySearchCriteriaInputModel subscriptionPaidBySearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSubscriptionPaidByOptions", "Master Data Management Api"));

                if (subscriptionPaidBySearchCriteriaInputModel == null)
                {
                    subscriptionPaidBySearchCriteriaInputModel = new SubscriptionPaidBySearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<SubscriptionPaidByApiReturnModel> subscriptionPaidByApiReturnModels = _masterDataManagementService.GetSubscriptionPaidByOptions(subscriptionPaidBySearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSubscriptionPaidByOptions", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSubscriptionPaidByOptions", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = subscriptionPaidByApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSubscriptionPaidByOptions", "MasterDataManagementApiController ", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMemberships)]
        public JsonResult<BtrakJsonResult> GetMemberships(MembershipSearchCriteriaInputModel membershipSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMemberships", "MasterDataManagement Api"));

                if (membershipSearchCriteriaInputModel == null)
                {
                    membershipSearchCriteriaInputModel = new MembershipSearchCriteriaInputModel { IsArchived = false };
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<MembershipApiReturnModel> memberships = _masterDataManagementService.GetMemberships(membershipSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMemberships", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMemberships", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = memberships, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMemberships", "MasterDataManagementApiController ", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTimeFormat)]
        public JsonResult<BtrakJsonResult> UpsertTimeFormat(TimeFormatInputModel timeFormatInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeFormat", "timeFormatInputModel", timeFormatInputModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? timeFormatIdReturned = _masterDataManagementService.UpsertTimeFormat(timeFormatInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeFormat", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeFormat", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = timeFormatIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeFormat", "MasterDataManagementApiController ", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertDateFormat)]
        public JsonResult<BtrakJsonResult> UpsertDateFormat(DateFormatInputModel dateFormatInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertDateFormat", "dateFormatInputModel", dateFormatInputModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? dateFormatIdReturned = _masterDataManagementService.UpsertDateFormat(dateFormatInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDateFormat", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertDateFormat", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = dateFormatIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertDateFormat", "MasterDataManagementApiController ", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertMainUseCase)]
        public JsonResult<BtrakJsonResult> UpsertMainUseCase(MainUseCaseInputModel mainUseCaseInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Main UseCase", "mainUseCaseInputModel", mainUseCaseInputModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? mainUseCaseIdReturned = _masterDataManagementService.UpsertMainUseCase(mainUseCaseInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Main UseCase", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Main UseCase", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = mainUseCaseIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMainUseCase", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAccessibleIpAddresses)]
        public JsonResult<BtrakJsonResult> GetAccessibleIpAddresses(GetAccessibleIpAddressesSearchCriteriaInputModel getAccessibleIpAddressesSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAccessibleIpAddresses", "getAccessibleIpAddressesSearchCriteriaInputModel", getAccessibleIpAddressesSearchCriteriaInputModel, "Master Data Management Api"));
                if (getAccessibleIpAddressesSearchCriteriaInputModel == null)
                {
                    getAccessibleIpAddressesSearchCriteriaInputModel = new GetAccessibleIpAddressesSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Accessible Ip Addresses");
                List<GetAccessibleIpAddressesOutputModel> accessibleIpAddressesList = _masterDataManagementService.GetAccessibleIpAddresses(getAccessibleIpAddressesSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAccessibleIpAddresses", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAccessibleIpAddresses", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = accessibleIpAddressesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetAccessibleIpAddresses)
                });

                return null;
            }
        }
        
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertNumberFormat)]
        public JsonResult<BtrakJsonResult> UpsertNumberFormat(NumberFormatInputModel numberFormatInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Number Format", "numberFormatInputModel", numberFormatInputModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? numberFormatIdReturned = _masterDataManagementService.UpsertNumberFormat(numberFormatInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Number Format", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Number Format", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = numberFormatIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertNumberFormat", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanyIntroducedByOption)]
        public JsonResult<BtrakJsonResult> UpsertCompanyIntroducedByOption(CompanyIntroducedByOptionInputModel companyIntroducedByOptionInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Company Introduced By Option", "companyIntroducedByOptionInputModel", companyIntroducedByOptionInputModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? companyIntroducedByOptionIdReturned = _masterDataManagementService.UpsertCompanyIntroducedByOption(companyIntroducedByOptionInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Company Introduced By Option", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Company Introduced By Option", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = companyIntroducedByOptionIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyIntroducedByOption", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertState)]
        public JsonResult<BtrakJsonResult> UpsertState(StateInputModel stateInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert States", "stateInputModel", stateInputModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? stateIdReturned = _masterDataManagementService.UpsertState(stateInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert States", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert States", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = stateIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertState", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertReferenceType)]
        public JsonResult<BtrakJsonResult> UpsertReferenceType(ReferenceTypeInputModel referenceTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Reference Type", "referenceTypeInputModel", referenceTypeInputModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? referenceTypeIdReturned = _masterDataManagementService.UpsertReferenceType(referenceTypeInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Reference Type", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Reference Type", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = referenceTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertReferenceType", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetReferenceTypes)]
        public JsonResult<BtrakJsonResult> GetReferenceTypes(ReferenceTypeSearchCriteriaInputModel referenceTypeSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Reference Types", "referenceTypeSearchCriteriaInputModel", referenceTypeSearchCriteriaInputModel, "Master Data Management Api"));
                if (referenceTypeSearchCriteriaInputModel == null)
                {
                    referenceTypeSearchCriteriaInputModel = new ReferenceTypeSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Reference Types");
                List<ReferenceTypeOutputModel> referenceTypesList = _masterDataManagementService.GetReferenceTypes(referenceTypeSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Reference Types", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Reference Types", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = referenceTypesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetReferenceTypes)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertLicenseType)]
        public JsonResult<BtrakJsonResult> UpsertLicenseType(LicenseTypeInputModel licenseTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert License Type", "licenseTypeInputModel", licenseTypeInputModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? licenseTypeIdReturned = _masterDataManagementService.UpsertLicenseType(licenseTypeInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert License Type", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert License Type", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = licenseTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLicenseType", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertHoliday)]
        public JsonResult<BtrakJsonResult> UpsertHoliday(HolidayInputModel holidayInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Holiday", "holidayInputModel", holidayInputModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? licenseTypeIdReturned = _masterDataManagementService.UpsertHoliday(holidayInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Holiday", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Holiday", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = licenseTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertHoliday", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetHolidays)]
        public JsonResult<BtrakJsonResult> GetHolidays(HolidaySearchCriteriaInputModel holidaySearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetHolidays", "holidaySearchCriteriaInputModel", holidaySearchCriteriaInputModel, "Master Data Management Api"));
                if (holidaySearchCriteriaInputModel == null)
                {
                    holidaySearchCriteriaInputModel = new HolidaySearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Holidays");
                List<HolidaysOutputModel> holidaysList = _masterDataManagementService.GetHolidays(holidaySearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHolidays", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHolidays", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = holidaysList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetHolidays)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllNationalities)]
        public JsonResult<BtrakJsonResult> GetAllNationalities(GetAllNationalitiesSearchCriteriaInputModel getAllNationalitiesSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllNationalities", "MasterDataManagement Api"));

                if (getAllNationalitiesSearchCriteriaInputModel == null)
                {
                    getAllNationalitiesSearchCriteriaInputModel = new GetAllNationalitiesSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<GetAllNationalitiesOutputModel> allNationalities = _masterDataManagementService.GetAllNationalities(getAllNationalitiesSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllNationalities", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllNationalities", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = allNationalities, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllNationalities", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetGenders)]
        public JsonResult<BtrakJsonResult> GetGenders(GendersSearchCriteriaInputModel gendersSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Genders", "MasterDataManagement Api"));

                if (gendersSearchCriteriaInputModel == null)
                {
                    gendersSearchCriteriaInputModel = new GendersSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<GendersOutputModel> gendersList = _masterDataManagementService.GetGenders(gendersSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Genders", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Genders", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = gendersList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGenders", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMaritalStatuses)]
        public JsonResult<BtrakJsonResult> GetMaritalStatuses(MaritalStatusesSearchCriteriaInputModel maritalStatusesSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Marital Statuses", "MasterDataManagement Api"));

                if (maritalStatusesSearchCriteriaInputModel == null)
                {
                    maritalStatusesSearchCriteriaInputModel = new MaritalStatusesSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<MaritalStatusesOutputModel> maritalStatusesList = _masterDataManagementService.GetMaritalStatuses(maritalStatusesSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Marital Statuses", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Marital Statuses", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = maritalStatusesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMaritalStatuses", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEducationLevel)]
        public JsonResult<BtrakJsonResult> UpsertEducationLevel(EducationLevelUpsertModel educationLevelUpsertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Education level", "EducationLevelUpsertModel", educationLevelUpsertModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? educationLevelIdReturned = _masterDataManagementService.UpsertEducationLevel(educationLevelUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Education", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Education", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = educationLevelIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEducationLevel", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertReportingMethod)]
        public JsonResult<BtrakJsonResult> UpsertReportingMethod(ReportingMethodUpsertModel reportingMethodUpsertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Reporting method", "reportingMethodUpsertModel", reportingMethodUpsertModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? reportingMethodIdReturned = _masterDataManagementService.UpsertReportingMethod(reportingMethodUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert report method", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert report method", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = reportingMethodIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertReportingMethod", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertMembership)]
        public JsonResult<BtrakJsonResult> UpsertMembership(MembershipUpsertModel membershipUpsertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Membership", "reportingMethodUpsertModel", membershipUpsertModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? membershipIdReturned = _masterDataManagementService.UpsertMembership(membershipUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Membership", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Membership", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = membershipIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMembership", "MasterDataManagementApiController ", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmploymentStatus)]
        public JsonResult<BtrakJsonResult> UpsertEmploymentStatus(EmploymentStatusInputModel employmentStatusInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Employment Status", "Master Data Management Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? employmentStatusIdReturned = _masterDataManagementService.UpsertEmploymentStatus(employmentStatusInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employment Status", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Employment Status", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = employmentStatusIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmploymentStatus", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPayFrequency)]
        public JsonResult<BtrakJsonResult> UpsertPayFrequency(PayFrequencyUpsertModel payFrequencyUpsertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Pay Frequency", "Master Data Management Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? payFrequencyIdReturned = _masterDataManagementService.UpsertPayFrequency(payFrequencyUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Pay Frequency", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Pay Frequency", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = payFrequencyIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayFrequency", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertNationality)]
        public JsonResult<BtrakJsonResult> UpsertNationality(NationalityUpsertModel nationalityUpsertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Nationality", "Master Data Management Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? nationalityIdReturned = _masterDataManagementService.UpsertNationality(nationalityUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Nationality", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Nationality", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = nationalityIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertNationality", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertLanguage)]
        public JsonResult<BtrakJsonResult> UpsertLanguage(LanguageUpsertModel languageUpsertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Language", "Master Data Management Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? languageIdReturned = _masterDataManagementService.UpsertLanguage(languageUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Language", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Language", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = languageIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLanguage", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertJobCategories)]
        public JsonResult<BtrakJsonResult> UpsertJobCategories(JobCategoriesUpsertModel jobCategoriesUpsertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Job category", "Master Data Management Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? jobCategoryIdReturned = _masterDataManagementService.UpsertJobCategories(jobCategoriesUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert job category", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert job category", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = jobCategoryIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertJobCategories", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetJobCategoryDetails)]
        public JsonResult<BtrakJsonResult> GetJobCategoryDetails(JobCategorySearchInputModel jobCategorySearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get job categories", "MasterDataManagement Api"));

                if (jobCategorySearchInputModel == null)
                {
                    jobCategorySearchInputModel = new JobCategorySearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<JobCategorySearchOutputModel> jobCategoriesList = _masterDataManagementService.SearchJobCategoryDetails(jobCategorySearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get job categories", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Marital Statuses", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = jobCategoriesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetJobCategoryDetails", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAppsettings)]
        public JsonResult<BtrakJsonResult> GetAppsettings(Appsettings appSettingSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAppsettings", "MasterDataManagement Api"));

                if (appSettingSearchInputModel == null)
                {
                    appSettingSearchInputModel = new Appsettings();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<AppSettingsOutputModel> appsettings = _masterDataManagementService.GetAppsettings(appSettingSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAppsettings", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAppsettings", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = appsettings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAppsettings", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertAppSetting)]
        public JsonResult<BtrakJsonResult> UpsertAppSetting(AppSettingsUpsertInputModel appSettingSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAppSetting", "MasterDataManagement Api"));
                
                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? appSettingsId = _masterDataManagementService.UpsertAppSettings(appSettingSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAppSetting", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertAppSetting", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = appSettingsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAppSetting", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCompanySettingsDetails)]
        public JsonResult<BtrakJsonResult> GetCompanysettingsDetails(CompanySettingsSearchInputModel companySettingsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanySettingsDetails", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                companySettingsSearchInputModel = companySettingsSearchInputModel ?? new CompanySettingsSearchInputModel();

                List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementService.GetCompanySettings(companySettingsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanySettingsDetails", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanySettingsDetails", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = companySettings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanysettingsDetails", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUsersInitialData)]
        public JsonResult<BtrakJsonResult> GetUsersInitialData(CompanySettingsSearchInputModel companySettingsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUsersInitialData", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                UsersInitialDataModel companySettings = _masterDataManagementService.GetUsersInitialData(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUsersInitialData", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUsersInitialData", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = companySettings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersInitialData", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCompanysettings)]
        public JsonResult<BtrakJsonResult> GetCompanysettings(CompanySettingsSearchInputModel companySettingsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanysettings", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<CompanySettingsSearchOutputModel> companySettings = _masterDataManagementService.GetCompanySettings(companySettingsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanysettings", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanysettings", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = companySettings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanysettings", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanysettings)]
        public JsonResult<BtrakJsonResult> UpsertCompanySettings(CompanySettingsUpsertInputModel companySettingsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAppSetting", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? companySettingsId = _masterDataManagementService.UpsertCompanySettings(companySettingsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanySetting", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanySetting", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = companySettingsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanySettings", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

    [HttpGet]
    [HttpOptions]
    [Route(RouteConstants.GetCompanyWorkItemStartFunctionalityRequired)]
    public JsonResult<BtrakJsonResult> GetCompanyWorkItemStartFunctionalityRequired()
    {
      try
      {
        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanyWorkItemStartFunctionalityRequired", "master data management Api"));
        List<ValidationMessage> validationMessages = new List<ValidationMessage>();
        BtrakJsonResult btrakApiResult;
        //var userModel = new ValidUserOutputmodel()
        //{
        //  //UserName = AuthorisedUser.UserName,
        //  Id = AuthorisedUser.Id,
        //  //IsActive = AuthorisedUser.IsActive,
        //  IsAdmin = AuthorisedUser.IsAdmin,
        //  CompanyId = AuthorisedUser.CompanyId,
        //  //OriginalId = AuthorisedUser.OriginalId
        //};
        bool startEnabled = _masterDataManagementService.GetCompanyWorkItemStartFunctionalityRequired(LoggedInContext, validationMessages);        
        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryTypeDropDown ", "master data management Api"));
        return Json(new BtrakJsonResult { Data = startEnabled, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
      }
      catch (Exception exception)
      {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyWorkItemStartFunctionalityRequired", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
      }
    }

    [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUserStoryTypeDropDown)]
        public JsonResult<BtrakJsonResult> GetUserStoryTypeDropDown(bool? isArchived, string searchText)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStoryTypeDropDown", "master data management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;
                if (searchText == "undefined" || searchText == "null")
                {
                    searchText = null;
                }
                List<UserStoryTypeDropDownOutputModel> userStoryTypeList = _masterDataManagementService.GetUserStoryTypeDropDown(isArchived, searchText, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryTypeDropDown", "master data management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryTypeDropDown ", "master data management Api"));
                return Json(new BtrakJsonResult { Data = userStoryTypeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryTypeDropDown", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetModulesList)]
        public JsonResult<BtrakJsonResult> GetModulesList(ModuleDetailsModel moduleDetailsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStoryTypeDropDown", "master data management Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<ModuleDetailsModel> modulesList = _masterDataManagementService.GetModulesList(moduleDetailsModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryTypeDropDown", "master data management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryTypeDropDown ", "master data management Api"));
                return Json(new BtrakJsonResult { Data = modulesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetModulesList", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCompanyModulesList)]
        public JsonResult<BtrakJsonResult> GetCompanyModulesList(ModuleDetailsModel moduleDetailsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStoryTypeDropDown", "master data management Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<ModuleDetailsModel> modulesList = _masterDataManagementService.GetCompanyModulesList(moduleDetailsModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryTypeDropDown", "master data management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryTypeDropDown ", "master data management Api"));
                return Json(new BtrakJsonResult { Data = modulesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyModulesList", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanyModule)]
        public JsonResult<BtrakJsonResult> UpsertCompanyModule(ModuleDetailsModel moduleDetailsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAppSetting", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? companySettingsId = _masterDataManagementService.UpsertCompanyModule(moduleDetailsModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanySetting", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanySetting", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = companySettingsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyModule", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanyLogo)]
        public JsonResult<BtrakJsonResult> UpsertCompanyLogo(UploadProfileImageInputModel uploadProfileImageInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertAppSetting", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                string companySettingsId = _masterDataManagementService.UpsertCompanyLogo(uploadProfileImageInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanySetting", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanySetting", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = companySettingsId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyLogo", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLeaveFrequencies)]
        public JsonResult<BtrakJsonResult> GetLeaveFrequencies(LeaveFrequencySearchInputModel leaveFrequencySearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeaveFrequencies", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<LeaveFrequencySearchOutputModel> companySettings = _masterDataManagementService.GetLeaveFrequencies(leaveFrequencySearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveFrequencies", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveFrequencies", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = companySettings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveFrequencies", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertLeaveFrequency)]
        public JsonResult<BtrakJsonResult> UpserLeaveFrequency(LeaveFrequencyUpsertInputModel leaveFrequencyUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertLeaveFrequency", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? LeaveFrequencyId = _masterDataManagementService.UpsertLeaveFrequency(leaveFrequencyUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaveFrequnecy", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaveFrequnecy", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = LeaveFrequencyId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpserLeaveFrequency", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertLeaveFormula)]
        public JsonResult<BtrakJsonResult> UpserLeaveFormula(LeaveFormulaUpsertInputModel leaveFormulaUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertLeaveFrequency", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? LeaveFormulaId = _masterDataManagementService.UpsertLeaveFormula(leaveFormulaUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaveFrequnecy", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaveFrequnecy", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = LeaveFormulaId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpserLeaveFormula", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLeaveFormula)]
        public JsonResult<BtrakJsonResult> GetLeaveFormula(LeaveFormulaSearchInputModel leaveFormulaSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeaveFormula", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<LeaveFormulSearchOutputModel> leaveFormula = _masterDataManagementService.GetLeaveFormula(leaveFormulaSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveFormula", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveFormula", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = leaveFormula, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveFormula", "MasterDataManagementApiController ", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEncashmentTypes)]
        public JsonResult<BtrakJsonResult> GetEncashmentTypes(SearchCriteriaInputModelBase searchCriteriaInputModelBase)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEncashmentTypes", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EncashmentTypeSearchOutputModel> encashmentTypes = _masterDataManagementService.GetEncashmentTypes(searchCriteriaInputModelBase, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEncashmentTypes", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEncashmentTypes", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = encashmentTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEncashmentTypes", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRestrictionTypes)]
        public JsonResult<BtrakJsonResult> GetRestrictiontypes(RestrictionTypeSearchInputModel restrictionTypeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRestrictionTypes", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<RestrictionTypeSearchOutputModel> restrictionTypes = _masterDataManagementService.GetRestrictionTypes(restrictionTypeSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRestrictionTypes", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRestrictionTypes", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = restrictionTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRestrictiontypes", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertRestrictionType)]
        public JsonResult<BtrakJsonResult> UpsertRestrictionType(RestrictionTypeUpsertInputModel restrictionTypeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertLeaveFrequency", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? RestrictionType = _masterDataManagementService.UpsertRestrictionType(restrictionTypeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertRestrictionType", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertRestrictionType", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = RestrictionType, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRestrictionType", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSoftLabelConfigurations)]
        public JsonResult<BtrakJsonResult> GetSoftLabelConfigurations(SoftLabelsSearchInputModel softLabelsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSoftLabelConfigurations", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                softLabelsSearchInputModel = softLabelsSearchInputModel ?? new SoftLabelsSearchInputModel();

                List<SoftLabelApiReturnModel> softLabelConfigurations = _masterDataManagementService.GetSoftLabelsConfigurationsList(softLabelsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSoftLabelConfigurations", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSoftLabelConfigurations", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = softLabelConfigurations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSoftLabelConfigurations", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertSoftLabelConfigurations)]
        public JsonResult<BtrakJsonResult> UpsertSoftLabelConfigurations(UpsertSoftLabelConfigurationsModel softLabelUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertSoftLabelConfigurations", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? softLabelConfigurationId = _masterDataManagementService.UpsertSoftLabelConfigurations(softLabelUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSoftLabelConfigurations", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertSoftLabelConfigurations", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = softLabelConfigurationId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSoftLabelConfigurations", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetSoftLabelById)]
        public JsonResult<BtrakJsonResult> GetSoftLabelById(Guid? softLabelId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSoftLabelById", "MasterDataManagement Api"));
                var validationMessages = new List<ValidationMessage>();
                SoftLabelApiReturnModel softLabelDetails = _masterDataManagementService.GetSoftLabelById(softLabelId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSoftLabelById", "MasterDataManagement Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSoftLabelById", "MasterDataManagement Api"));
                return Json(new BtrakJsonResult { Data = softLabelDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSoftLabelById", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRateSheets)]
        public JsonResult<BtrakJsonResult> GetRateSheets(RateSheetSearchCriteriaInputModel rateSheetSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Rate Sheet", "rateSheetSearchCriteriaInputModel", rateSheetSearchCriteriaInputModel, "Master Data Management Api"));
                if (rateSheetSearchCriteriaInputModel == null)
                {
                    rateSheetSearchCriteriaInputModel = new RateSheetSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting rate sheet list");
                List<RateSheetOutputModel> rateSheetList = _masterDataManagementService.GetRateSheets(rateSheetSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Rate Sheet", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Rate Sheet", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = rateSheetList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetRateSheets)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRateSheetForNames)]
        public JsonResult<BtrakJsonResult> GetRateSheetForNames(RateSheetForSearchCriteriaInputModel rateSheetForSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Rate Sheet", "rateSheetSearchCriteriaInputModel", rateSheetForSearchCriteriaInputModel, "Master Data Management Api"));
                if (rateSheetForSearchCriteriaInputModel == null)
                {
                    rateSheetForSearchCriteriaInputModel = new RateSheetForSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting rate sheet list");
                List<RateSheetForOutputModel> rateSheetForList = _masterDataManagementService.GetRateSheetForNames(rateSheetForSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Rate Sheet For", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Rate Sheet For", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = rateSheetForList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetRateSheetForNames)
                });

                return null;
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertRateSheet)]
        public JsonResult<BtrakJsonResult> UpsertRateSheet(RateSheetInputModel rateSheetInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert rate sheet", "Master Data Management Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? rateSheetIdReturned = _masterDataManagementService.UpsertRateSheet(rateSheetInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert rate sheet", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert rate sheet", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = rateSheetIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRateSheet", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPeakHours)]
        public JsonResult<BtrakJsonResult> GetPeakHours(PeakHourSearchCriteriaInputModel peakHourSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Peak Hour", "peakHourSearchCriteriaInputModel", peakHourSearchCriteriaInputModel, "Master Data Management Api"));
                if (peakHourSearchCriteriaInputModel == null)
                {
                    peakHourSearchCriteriaInputModel = new PeakHourSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting rate sheet list");
                List<PeakHourOutputModel> peakHourList = _masterDataManagementService.GetPeakHours(peakHourSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Peak Hour", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Peak Hour", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = peakHourList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetPeakHours)
                });

                return null;
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertPeakHour)]
        public JsonResult<BtrakJsonResult> UpsertPeakHour(PeakHourInputModel peakHourInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Upsert Peak Hour", "Master Data Management Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? peakHourIdReturned = _masterDataManagementService.UpsertPeakHour(peakHourInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Peak Hour", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Peak Hour", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = peakHourIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPeakHour", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWeekDays)]
        public JsonResult<BtrakJsonResult> GetWeekDays(WeekdaySearchCriteriaInputModel weekdaySearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWeekdays", "weekdaySearchCriteriaInputModel", weekdaySearchCriteriaInputModel, "Master Data Management Api"));
                if (weekdaySearchCriteriaInputModel == null)
                {
                    weekdaySearchCriteriaInputModel = new WeekdaySearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Weekdays");
                List<WeekdayOutputModel> weekdaysList = _masterDataManagementService.GetWeekdays(weekdaySearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWeekdays", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetWeekdays", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = weekdaysList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetWeekdays)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAddOrEditCustomAppIsRequired)]
        public JsonResult<BtrakJsonResult> GetAddOrEditCustomAppIsRequired()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAddOrEditCustomAppIsRequired", "master data management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;
               
                bool customAppAddOrEditEnabled = _masterDataManagementService.GetAddOrEditCustomAppIsRequired(LoggedInContext, validationMessages);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAddOrEditCustomAppIsRequired ", "master data management Api"));
                return Json(new BtrakJsonResult { Data = customAppAddOrEditEnabled, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAddOrEditCustomAppIsRequired", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertSpecificDay)]
        public JsonResult<BtrakJsonResult> UpsertSpecificDay(SpecificDayInputModel SpecificDayInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert SpecificDay", "SpecificDayInputModel", SpecificDayInputModel, "Master Data Management Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? licenseTypeIdReturned = _masterDataManagementService.UpsertSpecificDay(SpecificDayInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert SpecificDay", "Master Data Management Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert SpecificDay", "Master Data Management Api"));

                return Json(new BtrakJsonResult { Data = licenseTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSpecificDay", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetSpecificDays)]
        public JsonResult<BtrakJsonResult> GetSpecificDays(SpecificDaySearchCriteriaInputModel SpecificDaySearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetSpecificDays", "SpecificDaySearchCriteriaInputModel", SpecificDaySearchCriteriaInputModel, "Master Data Management Api"));
                if (SpecificDaySearchCriteriaInputModel == null)
                {   
                    SpecificDaySearchCriteriaInputModel = new SpecificDaySearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting SpecificDays");
                List<SpecificDayOutPutModel> SpecificDaysList = _masterDataManagementService.GetSpecificDays(SpecificDaySearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSpecificDays", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSpecificDays", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = SpecificDaysList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetSpecificDays)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDocumentStorageSettings)]
        public JsonResult<BtrakJsonResult> GetDocumentStorageSettings(CompanySettingsSearchInputModel companySettingsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDocumentStorageSettings", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                DocumentSettingsSearchOutputModel companySettings = _masterDataManagementService.GetDocumentStorageSettings(companySettingsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDocumentStorageSettings", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDocumentStorageSettings", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = companySettings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDocumentStorageSettings", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanyStructure)]
        public JsonResult<BtrakJsonResult> UpsertCompanyStructure(CompanyHierarchyModel companyHierarchyModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCompanyStructure", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? companySettings = _masterDataManagementService.UpsertCompanyStructure(companyHierarchyModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanyStructure", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanyStructure", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = companySettings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyStructure", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertBusinessUnit)]
        public JsonResult<BtrakJsonResult> UpsertBusinessUnit(BusinessUnitModel businessUnitModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertBusinessUnit", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? businessUnit = _masterDataManagementService.UpsertBusinessUnit(businessUnitModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBusinessUnit", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertBusinessUnit", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = businessUnit, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionInBusinessUnits, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetCompanyHierarchicalStructure)]
        public JsonResult<BtrakJsonResult> SearchEntities(CompanyHierarchyModel companyHierarchyModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchEntities", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                string entities = _masterDataManagementService.SearchEntities(companyHierarchyModel.EntityId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchEntities", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchEntities", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = entities, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEntities", "MasterDataManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchBusinessUnits)]
        public JsonResult<BtrakJsonResult> SearchBusinessUnits(BusinessUnitModel businessUnitModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchBusinessUnits", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                string businessUnits = _masterDataManagementService.SearchBusinessUnits(businessUnitModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchBusinessUnits", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchBusinessUnits", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = businessUnits, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionInBusinessUnits, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetBusinessUnitDropDown)]
        public JsonResult<BtrakJsonResult> GetBusinessUnitDropDown(BusinessUnitDropDownModel businessUnitModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBusinessUnitDropDown", "MasterDataManagement Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<BusinessUnitDropDownModel> businessUnits = _masterDataManagementService.GetBusinessUnitDropDown(businessUnitModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBusinessUnitDropDown", "MasterDataManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBusinessUnitDropDown", "MasterDataManagement Api"));

                return Json(new BtrakJsonResult { Data = businessUnits, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionInBusinessUnits, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
