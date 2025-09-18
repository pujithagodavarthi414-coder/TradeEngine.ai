using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.StatusReportingConfiguration;
using Btrak.Services.StatusReporting;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.StatusReporting
{
    public class StatusReportingApiController : AuthTokenApiController
    {
        private readonly IStatusReportingService _statusReportingService;

        public StatusReportingApiController(IStatusReportingService statusReportingService)
        {
            _statusReportingService = statusReportingService;
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetStatusConfigurationOptions)]
        public JsonResult<BtrakJsonResult> GetStatusConfigurationOptions()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatusConfigurationOptions", "StatusReporting Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<StatusReportingOptionsApiReturnModel> configurationOptions = _statusReportingService.GetStatusConfigurationOptions(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatusConfigurationOptions", "StatusReporting Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatusConfigurationOptions", "StatusReporting Api"));

                return Json(new BtrakJsonResult { Data = configurationOptions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStatusConfigurationOptions", "StatusReportingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertStatusReportingConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertStatusReportingConfiguration(StatusReportingConfigurationUpsertInputModel statusReportingConfiguration)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertStatusReportingConfiguration", "StatusReporting Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                StatusReportingConfigurationApiReturnModel statusReportingConfigurations = _statusReportingService.UpsertStatusReportingConfiguration(statusReportingConfiguration, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertStatusReportingConfiguration", "StatusReporting Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertStatusReportingConfiguration", "StatusReporting Api"));

                return Json(new BtrakJsonResult { Data = statusReportingConfigurations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertStatusReportingConfiguration", "StatusReportingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetStatusReportingConfigurations)]
        public JsonResult<BtrakJsonResult> GetStatusReportingConfigurations(StatusReportingConfigurationSearchCriteriaInputModel statusReportingConfiguration)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatusReportingConfigurations", "StatusReporting Api"));

                statusReportingConfiguration.PageSize = 100;
                statusReportingConfiguration.PageNumber = 1;

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<StatusReportingConfigurationApiReturnModel> statusReportingConfigurations = _statusReportingService.GetStatusReportingConfigurations(statusReportingConfiguration,LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatusReportingConfigurations", "StatusReporting Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatusReportingConfigurations", "StatusReporting Api"));

                return Json(new BtrakJsonResult { Data = statusReportingConfigurations, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStatusReportingConfigurations", "StatusReportingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetStatusReportingConfigurationForms)]
        public JsonResult<BtrakJsonResult> GetStatusReportingConfigurationForms()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatusReportingConfigurationForms", "StatusReporting Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<StatusReportingConfigurationFormApiReturnModel> statusReportingConfigurationForms = _statusReportingService.GetStatusReportingConfigurationForms(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatusReportingConfigurationForms", "StatusReporting Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatusReportingConfigurationForms", "StatusReporting Api"));

                return Json(new BtrakJsonResult { Data = statusReportingConfigurationForms, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStatusReportingConfigurationForms", "StatusReportingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateStatusReport)]
        public JsonResult<BtrakJsonResult> CreateStatusReport(StatusReportUpsertInputModel statusReport)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateStatusReport", "StatusReporting Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                
                StatusReportApiReturnModel statusReporting = _statusReportingService.CreateStatusReport(statusReport, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateStatusReport", "StatusReporting Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateStatusReport", "StatusReporting Api"));

                return Json(new BtrakJsonResult { Data = statusReporting, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateStatusReport", "StatusReportingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertReportSeenStatus)]
        public JsonResult<BtrakJsonResult> UpsertReportSeenStatus(StatusReportSeenUpsertInputModel reportSeenUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertReportSeenStatus", "StatusReporting Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? statusId = _statusReportingService.UpsertReportSeenStatus(reportSeenUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertReportSeenStatus", "StatusReporting Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertReportSeenStatus", "StatusReporting Api"));

                return Json(new BtrakJsonResult { Data = statusId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertReportSeenStatus", "StatusReportingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetStatusReportings)]
        public JsonResult<BtrakJsonResult> GetStatusReportings(StatusReportSearchCriteriaInputModel statusReport)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStatusReportings", "StatusReporting Api"));

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<StatusReportApiReturnModel> statusReportings = _statusReportingService.GetStatusReportings(statusReport,LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatusReportings", "StatusReporting Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatusReportings", "StatusReporting Api"));

                return Json(new BtrakJsonResult { Data = statusReportings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStatusReportings", "StatusReportingApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
