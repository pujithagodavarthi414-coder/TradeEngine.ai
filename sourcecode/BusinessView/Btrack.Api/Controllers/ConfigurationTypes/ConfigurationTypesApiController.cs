using Btrak.Models;
using Btrak.Services.ConfigurationTypes;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models.ConfigurationType;

namespace BTrak.Api.Controllers.ConfigurationTypes
{
    public class ConfigurationTypesApiController : AuthTokenApiController
    {
        private readonly IConfigurationTypeService _configurationTypeService;

        public ConfigurationTypesApiController(IConfigurationTypeService configurationTypeService)
        {
            _configurationTypeService = configurationTypeService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertConfigurationType)]
        public JsonResult<BtrakJsonResult> UpsertConfigurationType(ConfigurationTypeUpsertInputModel configurationTypeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertConfigurationType", "ConfigurationTypes Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? configurationTypeIdReturned = _configurationTypeService.UpsertConfigurationType(configurationTypeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertConfigurationType", "ConfigurationTypes Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertConfigurationType", "ConfigurationTypes Api"));

                return Json(new BtrakJsonResult { Data = configurationTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertConfigurationType", "ConfigurationTypesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllConfigurationTypes)]
        public JsonResult<BtrakJsonResult> GetAllConfigurationTypes(ConfigurationTypeInputModel configurationTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllConfigurationTypes", "ConfigurationTypes Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ConfigurationTypeApiReturnModel> configurationTypes = _configurationTypeService.GetAllConfigurationTypes(configurationTypeInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllConfigurationTypes", "ConfigurationTypes Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllConfigurationTypes", "ConfigurationTypes Api"));

                return Json(new BtrakJsonResult { Data = configurationTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllConfigurationTypes", "ConfigurationTypesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetConfigurationTypeById)]
        public JsonResult<BtrakJsonResult> GetConfigurationTypeById(Guid? configurationTypeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConfigurationTypeById", "ConfigurationTypes Api"));

                var validationMessages = new List<ValidationMessage>();

                ConfigurationTypeApiReturnModel configurationTypeApiReturnModel = _configurationTypeService.GetConfigurationTypeById(configurationTypeId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetConfigurationTypeById", "ConfigurationTypes Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetConfigurationTypeById", "ConfigurationTypes Api"));

                return Json(new BtrakJsonResult { Data = configurationTypeApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetConfigurationTypeById", "ConfigurationTypesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
