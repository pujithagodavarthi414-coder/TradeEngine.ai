using BTrak.Api.Controllers.Api;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Services.ConfigurationTypes;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Btrak.Models.ConfigurationType;

namespace BTrak.Api.Controllers.ConfigurationTypes
{
    public class ConfigurationSettingsApiController : AuthTokenApiController
    {
        private readonly IConfigurationSettingService _configurationSettingService;

        public ConfigurationSettingsApiController(IConfigurationSettingService configurationSettingService)
        {
            _configurationSettingService = configurationSettingService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertConfigurationSettings)]
        public JsonResult<BtrakJsonResult> UpsertConfigurationSettings([FromUri]Guid? configurationId, [FromBody]ConfigurationSettingUpsertInputModel configurationSettingUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertConfigurationSettings", "Configuration Settings Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? configurationIdReturned = _configurationSettingService.UpsertConfigurationSettings(configurationId, configurationSettingUpsertInputModel,  LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertConfigurationSettings", "Configuration Settings Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertConfigurationSettings", "Configuration Settings Api"));

                return Json(new BtrakJsonResult { Data = configurationIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertConfigurationSettings", "ConfigurationSettingsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllConfigurationSettings)]
        public JsonResult<BtrakJsonResult> GetAllConfigurationSettings(ConfigurationSettingInputModel configurationSettingInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllConfigurationSettings", "Configuration Settings Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ConfigurationSettingApiReturnModel> configurationSettings = _configurationSettingService.GetAllConfigurationSettings(configurationSettingInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllConfigurationSettings", "Configuration Settings Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllConfigurationSettings", "Configuration Settings Api"));

                return Json(new BtrakJsonResult { Data = configurationSettings, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllConfigurationSettings", "ConfigurationSettingsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetMandatoryFieldsBasedOnConfiguration)]
        public JsonResult<BtrakJsonResult> GetMandatoryFieldsBasedOnConfiguration(Guid? configurationId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMandatoryFieldsBasedOnConfiguration", "Configuration Settings Api"));

                var validationMessages = new List<ValidationMessage>();

                List<ConfigurationTypeApiReturnModel> configurationTypeApiReturnModels = _configurationSettingService.GetMandatoryFieldsBasedOnConfiguration(configurationId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMandatoryFieldsBasedOnConfiguration", "Configuration Settings Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMandatoryFieldsBasedOnConfiguration", "Configuration Settings Api"));

                return Json(new BtrakJsonResult { Data = configurationTypeApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMandatoryFieldsBasedOnConfiguration", "ConfigurationSettingsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
