using System;
using System.Collections.Generic;
using System.Web.Http.Results;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.Widgets;
using System.Web.Http;
using Btrak.Services.SystemConfiguration;
using Btrak.Services.Widgets;
using Newtonsoft.Json;
using System.Net;

namespace BTrak.Api.Controllers.SystemConfiguration
{
    public class SystemConfigurationApiController : AuthTokenApiController
    {
        private readonly ISystemConfigurationService _systemConfigurationService;

        public SystemConfigurationApiController(ISystemConfigurationService systemConfigurationService)
        {
            _systemConfigurationService = systemConfigurationService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ExportSystemConfiguration)]
        public JsonResult<BtrakJsonResult> ExportSystemConfiguration(SystemExportInputModel systemExportInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ExportSystemConfiguration", "Widgets Api"));

                BtrakJsonResult btrakJsonResult;

                var validationMessages = new List<ValidationMessage>();

                var systemConfigurationJson = _systemConfigurationService.ExportSystemConfiguration(systemExportInputModel,LoggedInContext, validationMessages, null);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ExportSystemConfiguration", "Widgets Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ExportSystemConfiguration", "Widgets Api"));
                return Json(new BtrakJsonResult { Data = systemConfigurationJson, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ExportSystemConfiguration", "SystemConfigurationApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ImportSystemConfiguration)]
        public JsonResult<BtrakJsonResult> ImportSystemConfiguration(SystemImportConfigurationInputModel configurationData)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ImportSystemConfiguration", "Widgets Api"));

                BtrakJsonResult btrakJsonResult;
                var validationMessages = new List<ValidationMessage>();

                var configurationUrl = configurationData.ConfigurationUrl;
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
                            systemConfigurationModel =JsonConvert.DeserializeObject<SystemConfigurationModel>(configurationResult.Data.ToString());

                            if (systemConfigurationModel != null)
                            {
                                systemConfigurationJson = _systemConfigurationService.ImportSystemConfiguration(systemConfigurationModel, LoggedInContext, validationMessages);
                            }
                        }
                    }
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ImportSystemConfiguration", "Widgets Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ImportSystemConfiguration", "Widgets Api"));
                return Json(new BtrakJsonResult { Data = systemConfigurationJson, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ImportSystemConfiguration", "SystemConfigurationApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}