using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.SystemManagement;
using Btrak.Services.SystemManagement;

namespace BTrak.Api.Controllers.SystemManagement
{
    public class SystemManagementApiController : AuthTokenApiController
    {
        private readonly ISystemManagementService _systemManagementService;

        public SystemManagementApiController(ISystemManagementService systemManagementService)
        {
            _systemManagementService = systemManagementService;
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.SearchSystemCurrencies)]
        public JsonResult<BtrakJsonResult> SearchSystemCurrencies(SystemCurrencySearchCriteriaInputModel systemCurrencySearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchSystemCurrencies", "systemCurrencySearchCriteriaInputModel", systemCurrencySearchCriteriaInputModel, "SystemManagement Api"));

                if (systemCurrencySearchCriteriaInputModel == null)
                {
                    systemCurrencySearchCriteriaInputModel = new SystemCurrencySearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<SystemCurrencyApiReturnModel> systemCurrencies = _systemManagementService.SearchSystemCurrencies(systemCurrencySearchCriteriaInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchSystemCurrencies", "SystemManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchSystemCurrencies", "SystemManagement Api"));

                return Json(new BtrakJsonResult { Data = systemCurrencies, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSystemCurrencies", " SystemManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost,HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.SearchSystemCountries)]
        public JsonResult<BtrakJsonResult> SearchSystemCountries([FromBody]SystemCountrySearchCriteriaInputModel systemCountrySearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchSystemCountries", "systemCountrySearchCriteriaInputModel", systemCountrySearchCriteriaInputModel, "SystemManagement Api"));

                if (systemCountrySearchCriteriaInputModel == null)
                {
                    systemCountrySearchCriteriaInputModel = new SystemCountrySearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<SystemCountryApiReturnModel> systemCountries = _systemManagementService.SearchSystemCountries(systemCountrySearchCriteriaInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchSystemCountries", "SystemManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchSystemCountries", "SystemManagement Api"));

                return Json(new BtrakJsonResult { Data = systemCountries, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSystemCountries", " SystemManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.SearchSystemRoles)]
        public JsonResult<BtrakJsonResult> SearchSystemRoles(SystemRoleSearchCriteriaInputModel systemRoleSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchSystemRoles", "systemRoleSearchCriteriaInputModel", systemRoleSearchCriteriaInputModel, "SystemManagement Api"));

                if (systemRoleSearchCriteriaInputModel == null)
                {
                    systemRoleSearchCriteriaInputModel = new SystemRoleSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<SystemRoleApiReturnModel> systemRoles = _systemManagementService.SearchSystemRoles(systemRoleSearchCriteriaInputModel, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchSystemRoles", "SystemManagement Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchSystemRoles", "SystemManagement Api"));

                return Json(new BtrakJsonResult { Data = systemRoles, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSystemRoles", " SystemManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
