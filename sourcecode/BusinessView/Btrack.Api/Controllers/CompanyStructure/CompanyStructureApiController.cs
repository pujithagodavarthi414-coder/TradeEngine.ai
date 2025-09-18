using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Net;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Services.CompanyStructure;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Btrak.Models.Widgets;
using Btrak.Services.SystemConfiguration;
using Hangfire;
using Newtonsoft.Json;
using BusinessView.Common;
using Newtonsoft.Json.Linq;
using ApiWrapper = BusinessView.Common.ApiWrapper;

namespace BTrak.Api.Controllers.CompanyStructure
{
    public class CompanyStructureApiController : AuthTokenApiController
    {
        private readonly ICompanyStructureService _companyStructureService;
        private readonly ISystemConfigurationService _systemConfigurationService;
        public string Siteaddress;
        private readonly UserAuthTokenFactory _userAuthTokenFactory;
        private readonly UserAuthTokenDbHelper _userAuthTokenDbHelper;
        public CompanyStructureApiController(ICompanyStructureService companyStructureService, ISystemConfigurationService systemConfigurationService)
        {
            _companyStructureService = companyStructureService;
            _systemConfigurationService = systemConfigurationService;
            _userAuthTokenFactory = new UserAuthTokenFactory();
            _userAuthTokenDbHelper = new UserAuthTokenDbHelper();
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.SearchIndustries)]
        public JsonResult<BtrakJsonResult> SearchIndustries(CompanyStructureSearchCriteriaInputModel companyStructureModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchIndustries", "companyStructureModel", companyStructureModel, "CompanyStructure Api"));
                if (companyStructureModel == null)
                {
                    companyStructureModel = new CompanyStructureSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Industries list ");
                List<CompanyStructureOutputModel> companyStructureList = _companyStructureService.SearchIndustries(companyStructureModel, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchIndustries", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchIndustries", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = companyStructureList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchCompanyStructure)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetIndustryById)]
        public JsonResult<BtrakJsonResult> GetIndustryById(Guid? industryId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetIndustryById", "industryId", industryId, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;
                CompanyStructureOutputModel industryDetails = _companyStructureService.GetIndustryById(industryId, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIndustryById", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIndustryById", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = industryDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionIndustryById)
                });
                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.SearchMainUseCases)]
        public JsonResult<BtrakJsonResult> SearchMainUseCases(MainUseCaseSearchCriteriaInputModel mainUseCaseSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchMainUseCases", "mainUseCaseSearchCriteriaInputModel", mainUseCaseSearchCriteriaInputModel, "CompanyStructure Api"));
                if (mainUseCaseSearchCriteriaInputModel == null)
                {
                    mainUseCaseSearchCriteriaInputModel = new MainUseCaseSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting MainUseCase list ");
                List<MainUseCaseOutputModel> mainUseCaseList = _companyStructureService.SearchMainUseCases(mainUseCaseSearchCriteriaInputModel, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchMainUseCases", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchMainUseCases", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = mainUseCaseList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchMainUseCases)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetMainUseCaseById)]
        public JsonResult<BtrakJsonResult> GetMainUseCaseById(Guid? mainUseCaseId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMainUseCaseById", "mainUseCaseId", mainUseCaseId, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;
                var mainUseCaseDetails = _companyStructureService.GetMainUseCaseById(mainUseCaseId, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIndustryById", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIndustryById", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = mainUseCaseDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionMainUseCaseById)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertIndustryModule)]
        public JsonResult<BtrakJsonResult> UpsertIndustryModule(IndustryModuleInputModel industryModuleInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertIndustryModule", "industryModuleInputModel", industryModuleInputModel, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;
                var industryModuleId = _companyStructureService.UpsertIndustryModule(industryModuleInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Upsert IndustryModule is completed. Return Guid is " + industryModuleId + ", source command is " + industryModuleInputModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertIndustryModule", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertIndustryModule", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = industryModuleId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionIndustryModule)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchIndustryModule)]
        public JsonResult<BtrakJsonResult> SearchIndustryModule(IndustryModuleSearchCriteriaInputModel industryModuleSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchIndustryModule", "industryModuleSearchCriteriaInputModel", industryModuleSearchCriteriaInputModel, "CompanyStructure Api"));
                if (industryModuleSearchCriteriaInputModel == null)
                {
                    industryModuleSearchCriteriaInputModel = new IndustryModuleSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting IndustryModule list ");
                List<IndustryModuleOutputModel> mainUseCaseList = _companyStructureService.SearchIndustryModule(industryModuleSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchIndustryModule", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchIndustryModule", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = mainUseCaseList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchIndustryModule)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetIndustryModuleById)]
        public JsonResult<BtrakJsonResult> GetIndustryModuleById(Guid? industryModuleId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetIndustryModuleById", "industryModuleId", industryModuleId, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;
                var industryModuleDetails = _companyStructureService.GetIndustryModuleById(industryModuleId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIndustryModuleById", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIndustryModuleById", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = industryModuleDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionIndustryModuleById)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.SearchNumberFormats)]
        public JsonResult<BtrakJsonResult> SearchNumberFormats(NumberFormatSearchCriteriaInputModel numberFormatSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchNumberFormats", "numberFormatSearchCriteriaInputModel", numberFormatSearchCriteriaInputModel, "CompanyStructure Api"));
                if (numberFormatSearchCriteriaInputModel == null)
                {
                    numberFormatSearchCriteriaInputModel = new NumberFormatSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting NumberFormat list ");
                List<NumberFormatOutputModel> mainUseCaseList = _companyStructureService.SearchNumberFormats(numberFormatSearchCriteriaInputModel, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchNumberFormats", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchNumberFormats", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = mainUseCaseList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchNumberFormats)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetNumberFormatById)]
        public JsonResult<BtrakJsonResult> GetNumberFormatById(Guid? numberFormatId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetNumberFormatById", "numberFormatId", numberFormatId, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;
                NumberFormatOutputModel numberFormatDetails = _companyStructureService.GetNumberFormatById(numberFormatId, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetNumberFormatById", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetNumberFormatById", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = numberFormatDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionNumberFormatById)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.SearchDateFormats)]
        public JsonResult<BtrakJsonResult> SearchDateFormats(DateFormatSearchCriteriaInputModel dateFormatSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchDateFormats", "dateFormatSearchCriteriaInputModel", dateFormatSearchCriteriaInputModel, "CompanyStructure Api"));
                if (dateFormatSearchCriteriaInputModel == null)
                {
                    dateFormatSearchCriteriaInputModel = new DateFormatSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting DateFormat list ");
                List<DateFormatOutputModel> dateFormatList = _companyStructureService.SearchDateFormats(dateFormatSearchCriteriaInputModel, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDateFormats", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDateFormats", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = dateFormatList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchDateFormats)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetDateFormatById)]
        public JsonResult<BtrakJsonResult> GetDateFormatById(Guid? dateFormatId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetDateFormatById", "dateFormatId", dateFormatId, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;
                DateFormatOutputModel dateFormatIdDetails = _companyStructureService.GetDateFormatById(dateFormatId, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDateFormatById", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDateFormatById", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = dateFormatIdDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionDateFormatById)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.SearchTimeFormats)]
        public JsonResult<BtrakJsonResult> SearchTimeFormats(TimeFormatSearchCriteriaInputModel timeFormatSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchTimeFormats", "timeFormatSearchCriteriaInputModel", timeFormatSearchCriteriaInputModel, "CompanyStructure Api"));
                if (timeFormatSearchCriteriaInputModel == null)
                {
                    timeFormatSearchCriteriaInputModel = new TimeFormatSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting TimeFormat list ");
                List<TimeFormatOutputModel> timeFormatList = _companyStructureService.SearchTimeFormats(timeFormatSearchCriteriaInputModel, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchTimeFormats", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchTimeFormats", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = timeFormatList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchTimeFormats)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetTimeFormatById)]
        public JsonResult<BtrakJsonResult> GetTimeFormatById(Guid? timeFormatId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTimeFormatById", "timeFormatId", timeFormatId, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;
                TimeFormatOutputModel timeFormatDetails = _companyStructureService.GetTimeFormatById(timeFormatId, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeFormatById", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeFormatById", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = timeFormatDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionTimeFormatById)
                });

                return null;
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompany)]
        public JsonResult<BtrakJsonResult> UpsertCompany(CompanyInputModel companyInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompany", "companyInputModel", companyInputModel, "CompanyStructure Api"));

                BtrakJsonResult btrakJsonResult;
                if (companyInputModel != null)
                {
                    companyInputModel.MainPassword = companyInputModel.Password;
                }

                //_companyStructureService.CheckUpsertCompanyValidations(companyInputModel, validationMessages);

                var result = ApiWrapper.AnnonymousPostentityToApi(RouteConstants.ASUpsertCompany, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], companyInputModel).Result;
                var responseJson = JsonConvert.DeserializeObject<BtrakJsonResult>(result);
                //JObject jObject = JObject.Parse(result);
                //var responseJson = jObject.ToObject<BtrakJsonResult>();
                if (!responseJson.Success)
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
                    if (UiHelper.CheckForValidationMessages(validationMessages, out responseJson))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompany", "CompanyStructure Api"));
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = responseJson.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                else
                {
                    string data = JsonConvert.SerializeObject(responseJson.Data);
                    //jObject["data"].ToString();
                    UpsertCompanyOutputModel companyDetails = JsonConvert.DeserializeObject<UpsertCompanyOutputModel>(data);
                    //(UpsertCompanyOutputModel)responseJson.Data;
                    companyInputModel.UserAuthenticationId = companyDetails.UserId;
                    companyInputModel.RoleId = companyDetails.RoleId;
                    companyInputModel.CompanyAuthenticationId = companyDetails.CompanyId;
                    if (companyInputModel != null && companyInputModel.IndustryId != null && companyInputModel.ConfigurationUrl != null)
                    {
                        CreateNewCompanyAndConfigurationInBackground(companyInputModel);
                        //BackgroundJob.Enqueue(() => CreateNewCompanyAndConfigurationInBackground(companyInputModel));
                    }
                    else
                    {
                        CreateNewCompanyInBackground(companyInputModel);
                        //BackgroundJob.Enqueue(() =>
                        //    CreateNewCompanyInBackground(companyInputModel));
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompany", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = null, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage =
                        string.Format(sqlEx.Message, ValidationMessages.ExceptionUpsertCompany)
                });

                return null;
            }
        }

        public void CreateNewCompanyAndConfigurationInBackground(CompanyInputModel companyInputModel)
        {
            UpsertCompanyOutputModel companyDetails = _companyStructureService.UpsertCompany(new LoggedInContext(), companyInputModel, new List<ValidationMessage>());

            if (companyDetails != null)
            {
                string configurationData = string.Empty;

                string configurationUrl = string.Empty;

                configurationUrl = companyInputModel.ConfigurationUrl;

                LoggedInContext loggedInContext = new LoggedInContext
                {
                    LoggedInUserId = (Guid)companyDetails.UserId,
                    CompanyGuid = (Guid)companyDetails.CompanyId
                };

                if (!string.IsNullOrWhiteSpace(configurationUrl))
                {
                    bool? result = _companyStructureService.UpsertCompanyConfigurationUrl(loggedInContext, companyInputModel, new List<ValidationMessage>());

                    

                    if (result == true)
                    {
                        using (WebClient wc = new WebClient())
                        {
                            wc.Encoding = System.Text.Encoding.UTF8;
                            configurationData = wc.DownloadString(configurationUrl);
                        }

                        if (!string.IsNullOrWhiteSpace(configurationData))
                        {
                            BtrakJsonResult configurationResult =
                                JsonConvert.DeserializeObject<BtrakJsonResult>(configurationData);

                            SystemConfigurationModel systemConfigurationModel = null;

                            if (configurationResult != null && configurationResult.Data != null &&
                                !string.IsNullOrWhiteSpace(configurationResult.Data.ToString()))
                            {
                                systemConfigurationModel =
                                    JsonConvert.DeserializeObject<SystemConfigurationModel>(configurationResult.Data.ToString());

                                if (systemConfigurationModel != null)
                                {
                                    _systemConfigurationService.ImportSystemConfiguration(
                                        systemConfigurationModel, loggedInContext, new List<ValidationMessage>());
                                }
                            }
                        }

                        if (companyInputModel.IsDemoData)
                        {
                            _companyStructureService.InsertCompanyTestData(companyDetails);
                        }

                    }
                    
                        bool? isInsert1 = _companyStructureService.UpdateCompanySettings(loggedInContext, companyInputModel, new List<ValidationMessage>());
                    
                }
            }
        }

        public void CreateNewCompanyInBackground(CompanyInputModel companyInputModel)
        {
            UpsertCompanyOutputModel companyDetails = _companyStructureService.UpsertCompany(new LoggedInContext(), companyInputModel, new List<ValidationMessage>());

            if (companyDetails != null)
            {
                if (companyInputModel.IsDemoData)
                {
                    _companyStructureService.InsertCompanyTestData(companyDetails);
                }
            }
        }

 
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendContactMail)]
        public JsonResult<BtrakJsonResult> SendContactMail(SendMailInputModel sendMailInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompany", "companyInputModel", sendMailInputModel, "CompanyStructure Api"));

                BtrakJsonResult btrakJsonResult;

                if (sendMailInputModel != null)
                {
                    _companyStructureService.SendEmailContact(sendMailInputModel);
                }
                return Json(new BtrakJsonResult { Data = null, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage =
                        string.Format(sqlEx.Message, ValidationMessages.ExceptionUpsertCompany)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchCompanies)]
        public JsonResult<BtrakJsonResult> SearchCompanies(CompanySearchCriteriaInputModel companySearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCompanies", "companySearchCriteriaInputModel", companySearchCriteriaInputModel, "CompanyStructure Api"));
                if (companySearchCriteriaInputModel == null)
                {
                    companySearchCriteriaInputModel = new CompanySearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;

                LoggingManager.Info("Getting Companies list ");
                List<CompanyOutputModel> companiesList = _companyStructureService.SearchCompanies(companySearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCompanies", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCompanies", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = companiesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchCompany)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCompanies)]
        public JsonResult<BtrakJsonResult> GetCompanies()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                
                CompanySearchCriteriaInputModel companySearchCriteriaInputModel = new CompanySearchCriteriaInputModel();
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCompanies", "companySearchCriteriaInputModel", companySearchCriteriaInputModel, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;

                LoggingManager.Info("Getting Companies list ");
                List<CompanyOutputModel> companiesList = _companyStructureService.SearchCompanies(companySearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCompanies", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchCompanies", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = companiesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchCompany)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCompanyById)]
        public JsonResult<BtrakJsonResult> GetCompanyById(Guid? companyId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyById", "companyId", companyId, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;
                CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(companyId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyById", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyById", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = companyDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionCompanyById)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchIntroducedByOptions)]
        public JsonResult<BtrakJsonResult> SearchIntroducedByOptions(IntroducedByOptionsSearchInputModel introducedByOptionsSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchIntroducedByOptions", "introducedByOptionsSearchInputModel", introducedByOptionsSearchInputModel, "CompanyStructure Api"));
                if (introducedByOptionsSearchInputModel == null)
                {
                    introducedByOptionsSearchInputModel = new IntroducedByOptionsSearchInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting Introduced By Options list");
                List<IntroducedByOptionsOutputModel> introducedByOptionsList = _companyStructureService.SearchIntroducedByOptions(introducedByOptionsSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Introduced By Options", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Introduced By Options", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = introducedByOptionsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchIntroducedByOptions)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetIntroducedByOptionById)]
        public JsonResult<BtrakJsonResult> GetIntroducedByOptionById(Guid? introducedByOptionId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetIntroducedByOptionById", "introducedByOptionId", introducedByOptionId, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;
                IntroducedByOptionsOutputModel introducedByOptionDetails = _companyStructureService.GetIntroducedByOptionById(introducedByOptionId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIntroducedByOptionById", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetIntroducedByOptionById", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = introducedByOptionDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionIntroducedByOptionById)
                });

                return null;
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteCompanyModule)]
        public JsonResult<BtrakJsonResult> DeleteCompanyModule(DeleteCompanyModuleModel deleteCompanyModuleModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteCompanyModule", "deleteCompanyModuleModel", deleteCompanyModuleModel, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;
                var companyModuleId = _companyStructureService.DeleteCompanyModule(deleteCompanyModuleModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Delete Company Module is completed. Return Guid is " + companyModuleId + ", source command is " + deleteCompanyModuleModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteCompanyModule", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteCompanyModule", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = companyModuleId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionDeleteCompanyModule)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteCompanyTestData)]
        public JsonResult<BtrakJsonResult> DeleteCompanyTestData(DeleteCompanyTestDataModel deleteCompanyTestDataModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteCompanyTestData", "deleteCompanyTestDataModel", deleteCompanyTestDataModel, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;
                var companyId = _companyStructureService.DeleteCompanyTestData(deleteCompanyTestDataModel, LoggedInContext, validationMessages);

                LoggingManager.Info("Delete Company test data is completed. Return Guid is " + companyId + ", source command is " + deleteCompanyTestDataModel);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteCompanyTestDate", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                var configurationUrl = _companyStructureService.GetCompanyConfigurationUrl(LoggedInContext, new List<ValidationMessage>());
                string configuredData = string.Empty;
                string systemConfigurationJson = string.Empty;

                if (!string.IsNullOrWhiteSpace(configurationUrl))
                {
                    using (WebClient wc = new WebClient())
                    {
                        wc.Encoding = System.Text.Encoding.UTF8;
                        configuredData = wc.DownloadString(configurationUrl);
                    }

                    if (!string.IsNullOrWhiteSpace(configuredData))
                    {
                        BtrakJsonResult configurationResult =
                            JsonConvert.DeserializeObject<BtrakJsonResult>(configuredData);

                        SystemConfigurationModel systemConfigurationModel = null;

                        if (configurationResult != null && configurationResult.Data != null &&
                            !string.IsNullOrWhiteSpace(configurationResult.Data.ToString()))
                        {
                            systemConfigurationModel = JsonConvert.DeserializeObject<SystemConfigurationModel>(configurationResult.Data.ToString());

                            if (systemConfigurationModel != null)
                            {
                                systemConfigurationJson = _systemConfigurationService.ImportSystemConfiguration(systemConfigurationModel, LoggedInContext, validationMessages);
                            }
                        }
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteCompanyTestDate", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = companyId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteCompanyTestData", "CompanyStructureApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }



        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanyDetails)]
        public JsonResult<BtrakJsonResult> UpsertCompanyDetails(CompanyInputModel companyInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyDetails", "companyInputModel", LoggedInContext, "CompanyStructure Api"));
                
                var result = ApiWrapper.PutentityToApi(RouteConstants.ASUpsertCompanyDetails, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], companyInputModel, LoggedInContext.AccessToken).Result;
                var responseJson = JsonConvert.DeserializeObject<BtrakJsonResult>(result);
                if (responseJson.Success)
                {
                    string data = JsonConvert.SerializeObject(responseJson.Data);
                    Guid companyDetails = JsonConvert.DeserializeObject<Guid>(data);
                    companyInputModel.CompanyAuthenticationId = companyDetails;
                    if (companyInputModel.Key == null)
                    {
                        Guid? companyId = _companyStructureService.UpsertCompanyDetails(companyInputModel, LoggedInContext, validationMessages);
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanyDetails", "CompanyStructure Api"));
                        return Json(new BtrakJsonResult { Data = companyId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                    else
                    {
                        var companyId = _companyStructureService.UpdateCompanyDetails(companyInputModel, LoggedInContext, validationMessages);
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateCompanyDetails", "CompanyStructure Api"));
                        return Json(new BtrakJsonResult { Data = companyId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                else
                {
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = responseJson.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyDetails", "CompanyStructureApiController", exception.Message), exception);
                         
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CompanyDetails)]
        public JsonResult<BtrakJsonResult> GetCompanyDetails()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyDetails", "GetCompanyDetailsModel", LoggedInContext, "CompanyStructure Api"));
                BtrakJsonResult btrakJsonResult;
                var companyDetails = _companyStructureService.GetCompanyDetails(LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteCompanyTestDate", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteCompanyTestDate", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = companyDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyDetails", "CompanyStructureApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetCompanyTheme)]
        public JsonResult<BtrakJsonResult> GetTheme(CompaniesList companiesList)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                BtrakJsonResult btrakJsonResult;

                CompanyThemeModel companyTheme = new CompanyThemeModel();
                var ah = Request.Headers.Authorization;
                if (ah != null && ah.Scheme.ToLower() == "bearer")
                {
                    var jwtToken = ah.Parameter;

                    var decodeJwt = jwtToken != "null" ? _userAuthTokenDbHelper.ValidateClientRequest(jwtToken, RouteConstants.GetCompanyTheme).GetAwaiter().GetResult() : null;
                    if (decodeJwt != null)
                    {
                        var loggedInUserId = decodeJwt.Id;
                        companyTheme = _companyStructureService.GetCompanyTheme(loggedInUserId);
                    }
                    else
                        companyTheme = _companyStructureService.GetCompanyTheme(null);
                }
                else
                {
                    companyTheme = _companyStructureService.GetCompanyTheme(null);
                }
                if (companyTheme != null && !string.IsNullOrWhiteSpace(companyTheme.CompanyThemeString))
                {
                    companyTheme.CompanyThemeId = new Guid(companyTheme.CompanyThemeString);
                }


                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyTheme", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetCompanyTheme", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = companyTheme, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTheme", "CompanyStructureApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.IsCompanyExists)]
        public JsonResult<BtrakJsonResult> IsCompanyExists()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                BtrakJsonResult btrakJsonResult;

                bool? exists = _companyStructureService.IsCompanyExists(validationMessages);


                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "IsCompanyExists", "CompanyStructure Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "IsCompanyExists", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = exists, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "IsCompanyExists", "CompanyStructureApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertCompanySignUpDetails)]
        public JsonResult<BtrakJsonResult> UpsertCompanySignUpDetails(CompanyInputModel companyInputModel)
        {

            var validationMessages = new List<ValidationMessage>();
            try
            {

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanySignUpDetails", "companyInputModel", companyInputModel, "CompanyStructure Api"));

                BtrakJsonResult btrakJsonResult;
                if (companyInputModel != null)
                {
                    int verificationCode = 0;
                    Random ra = new Random();
                    verificationCode = ra.Next(100000, 999999);
                    companyInputModel.VerificationCode = verificationCode;
                    string result = _companyStructureService.UpsertCompanySignUpDetails(companyInputModel, validationMessages);
                    Siteaddress = result;

                    if (result != null && companyInputModel.IsVerify != true && companyInputModel.IsOtpVerify != true && !result.Contains("siteaddress"))
                    {
                        companyInputModel.RegistorId = Guid.Parse(result);

                        _companyStructureService.SendVerificationEmail(companyInputModel);
                    }
                    if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanySignUpDetails", "CompanyStructure Api"));
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertCompanySignUpDetails", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = Siteaddress, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanySignUpDetails", "CompanyStructureApicontroller", exception.Message), exception);
                return null;
            }
        }

        [AllowAnonymous]
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmailVerifyDetails)]
        public JsonResult<BtrakJsonResult> UpsertEmailVerifyDetails(CompanyInputModel companyInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmailVerifyDetails", "companyInputModel", companyInputModel, "CompanyStructure Api"));

                BtrakJsonResult btrakJsonResult;
                if (companyInputModel != null)
                {
                    bool? result = _companyStructureService.UpsertEmailVerifyDetails(companyInputModel, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmailVerifyDetails", "CompanyStructure Api"));
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmailVerifyDetails", "CompanyStructure Api"));
                return Json(new BtrakJsonResult { Data = null, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmailVerifyDetails", "CompanyStructureApiController", exception.Message), exception);
                return null;
            }
        }

        
    }
}
