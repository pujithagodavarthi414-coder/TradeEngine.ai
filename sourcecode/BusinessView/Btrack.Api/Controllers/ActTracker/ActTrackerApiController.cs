using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.ActTracker;
using Btrak.Services.ActTracker;
using Btrak.Models.ActivityTracker;
using Btrak.Services.ActivityTracker;
using System.Configuration;

namespace BTrak.Api.Controllers.ActTracker
{
    public class ActTrackerApiController : AuthTokenApiController
    {
        private readonly IActTrackerService _actTrackerService;
        private readonly IActivityTrackerService _activityTrackerService;
        private readonly UserAuthTokenFactory _userAuthTokenFactory = new UserAuthTokenFactory();

        public ActTrackerApiController(IActTrackerService actTrackerService, IActivityTrackerService activityTrackerService)
        {
            _actTrackerService = actTrackerService;
            _activityTrackerService = activityTrackerService;
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertActTrackerRoleConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertActTrackerRoleConfiguration(ActTrackerRoleConfigurationUpsertInputModel actTrackerRoleConfigurationUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertActTrackerRoleConfiguration", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<Guid?> configuredRoleIds = _actTrackerService.UpsertActTrackerRoleConfiguration(actTrackerRoleConfigurationUpsertInputModel, LoggedInContext, validationMessages);

                _activityTrackerService.GetChatActivityTrackerRecorder(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActTrackerRoleConfiguration", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActTrackerRoleConfiguration", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = configuredRoleIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActTrackerRoleConfiguration", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerAppUrlType)]
        public JsonResult<BtrakJsonResult> GetActTrackerAppUrlType()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerAppUrl", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ActTrackerAppUrlOutputModel> actTrackerAppUrls = _actTrackerService.GetActTrackerAppUrlType(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerAppUrl", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerAppUrl", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = actTrackerAppUrls, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerAppUrlType", "ActTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertActTrackerScreenShotFrequency)]
        public JsonResult<BtrakJsonResult> UpsertActTrackerScreenShotFrequency(ActTrackerScreenShotFrequencyUpsertInputModel actTrackerScreenShotFrequencyUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertActTrackerScreenSHotFrequency", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<Guid?> configuredRoleIds = _actTrackerService.UpsertActTrackerScreenSHotFrequency(actTrackerScreenShotFrequencyUpsertInputModel, LoggedInContext, validationMessages);

                _activityTrackerService.GetChatActivityTrackerRecorder(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActTrackerScreenSHotFrequency", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActTrackerScreenSHotFrequency", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = configuredRoleIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActTrackerScreenShotFrequency", "ActTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerRoleDropDown)]
        public JsonResult<BtrakJsonResult> GetActTrackerRoleDropDown()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerRoleDropDown", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ActTrackerRoleDropOutputModel> roleDropDown = _actTrackerService.GetActTrackerRoleDropDown(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerRoleDropDown", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerRoleDropDown", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = roleDropDown, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerRoleDropDown", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertActTrackerRolePermission)]
        public JsonResult<BtrakJsonResult> UpsertActTrackerRolePermission(ActTrackerRolePermissionUpsertInputModel actTrackerRolePermissionUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertActTrackerRolePermission", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<Guid?> configuredRoleIds = _actTrackerService.UpsertActTrackerRolePermission(actTrackerRolePermissionUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActTrackerRolePermission", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActTrackerRolePermission", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = configuredRoleIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActTrackerRolePermission", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerRoleDeleteDropDown)]
        public JsonResult<BtrakJsonResult> GetActTrackerRoleDeleteDropDown()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerRoleDeleteDropDown", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ActTrackerRoleDropOutputModel> roleDropDown = _actTrackerService.GetActTrackerRoleDeleteDropDown(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerRoleDeleteDropDown", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerRoleDeleteDropDown", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = roleDropDown, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerRoleDeleteDropDown", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertActTrackerAppUrls)]
        public JsonResult<BtrakJsonResult> UpsertActTrackerAppUrls(ActTrackerAppUrlsUpsertInputModel actTrackerAppUrlsUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertActTrackerAppUrls", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<Guid?> configuredIds = _actTrackerService.UpsertActTrackerAppUrls(actTrackerAppUrlsUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActTrackerAppUrls", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActTrackerAppUrls", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = configuredIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActTrackerAppUrls", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetActTrackerAppUrlsForTracker)]
        public JsonResult<BtrakJsonResult> GetActTrackerAppUrlsForTracker(ActTrackerAppUrlsSearchInputModel actTrackerAppUrlsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerAppUrlsForTracker", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ActTrackerAppUrlApiOutputModel> appUrlsList = appUrlsList = _actTrackerService.GetActTrackerAppUrls(actTrackerAppUrlsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerAppUrls", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerAppUrlsForTracker", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = appUrlsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerAppUrlsForTracker", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerAppUrls)]
        public JsonResult<BtrakJsonResult> GetActTrackerAppUrls(ActTrackerAppUrlsSearchInputModel actTrackerAppUrlsSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerAppUrls", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;
                List<ActTrackerAppUrlApiOutputModel> appUrlsList = appUrlsList = _actTrackerService.GetActTrackerAppUrls(actTrackerAppUrlsSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerAppUrls", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerAppUrls", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = appUrlsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerAppUrls", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerAppReportUsage)]
        public JsonResult<BtrakJsonResult> GetActTrackerAppReportUsage(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerAppReportUsage", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ActTrackerAppReportUsageSearchOutputModel> appReportUsageList = _actTrackerService.GetActTrackerAppReportUsage(employeeWebAppUsageTimeSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerAppReportUsage", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerAppReportUsage", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = appReportUsageList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerAppReportUsage", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerAppReportUsageForChart)]
        public JsonResult<BtrakJsonResult> GetActTrackerAppReportUsageForChart(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerAppReportUsageForChart", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ActTrackerAppReportUsageSearchOutputModel> appReportUsageList = _actTrackerService.GetActTrackerAppReportUsageForChart(employeeWebAppUsageTimeSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerAppReportUsageForChart", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerAppReportUsageForChart", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = appReportUsageList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerAppReportUsageForChart", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetActTrackerUserScreenshotFrequency)]
        public JsonResult<BtrakJsonResult> GetActTrackerUserScreenshotFrequency(ActTrackerScreenshotFrequencySearchInputModel actTrackerScreenshotFrequencySearchInputModel)
        {
            try
            {
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult _btrakJsonResult;

                var headers = Request.Headers.Authorization;
                Guid? loggedInUserId = null;

                if (headers != null && headers.Scheme.ToLower() == "bearer")
                {
                    var jwtToken = headers.Parameter;

                    var decodeJwt = jwtToken != "null" ? _userAuthTokenFactory.DecodeUserAuthToken(jwtToken) : null;
                    if (decodeJwt != null)
                    {
                        loggedInUserId = decodeJwt.UserId;
                    }
                }

                ActTrackerScreenshotFrequencySearchOutputModel actTrackerScreenshotFrequencySearchOutputModel = _actTrackerService.GetActTrackerUserScreenshotFrequency(actTrackerScreenshotFrequencySearchInputModel, validationMessages, loggedInUserId);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Insert User Activity Time", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Insert User Activity Time", "ActivityTracker Api"));

                if (actTrackerScreenshotFrequencySearchOutputModel == null)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                return Json(new BtrakJsonResult { Data = actTrackerScreenshotFrequencySearchOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerUserScreenshotFrequency", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerUserActivityScreenshots)]
        public JsonResult<BtrakJsonResult> GetActTrackerUserActivityScreenshots(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Act Tracker User Activity Screenshots", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ActTrackerScreenshotsApiOutputModel> getActTrackerUserActivityScreenshotsOutputModel = _actTrackerService.GetActTrackerUserActivityScreenshots(employeeWebAppUsageTimeSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Act Tracker User Activity Screenshots", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Act Tracker User Activity Screenshots", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = getActTrackerUserActivityScreenshotsOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerUserActivityScreenshots", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerRolePermissionRoles)]
        public JsonResult<BtrakJsonResult> GetActTrackerRolePermissionRoles(ActTrackerRolePermissionRolesInputModel actTrackerRolePermissionRolesInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerRolePermissionRoles", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                PermissionRoles permissionRoles = _actTrackerService.GetActTrackerRolePermissionRoles(actTrackerRolePermissionRolesInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerRolePermissionRoles", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerRolePermissionRoles", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = permissionRoles, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerRolePermissionRoles", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerRoleConfigurationRoles)]
        public JsonResult<BtrakJsonResult> GetActTrackerRoleConfigurationRoles()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerRoleConfigurationRoles", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                ActTrackerRoleConfiguration roleDropDown = _actTrackerService.GetActTrackerRoleConfigurationRoles(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerRoleConfigurationRoles", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerRoleConfigurationRoles", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = roleDropDown, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerRoleConfigurationRoles", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerScreenShotFrequencyRoles)]
        public JsonResult<BtrakJsonResult> GetActTrackerScreenShotFrequencyRoles()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerRoleConfigurationRoles", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                ActTrackerScreenShotFrequency roleDropDown = _actTrackerService.GetActTrackerScreenShotFrequencyRoles(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerRoleConfigurationRoles", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerRoleConfigurationRoles", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = roleDropDown, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerScreenShotFrequencyRoles", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.MultipleDeleteScreenShot)]
        public JsonResult<BtrakJsonResult> MultipleDeleteScreenShot(ActTrackerScreenshotDeleteInputModel actTrackerScreenshotDeleteInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerRolePermissionRoles", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var result = _actTrackerService.MultipleDeleteScreenShot(actTrackerScreenshotDeleteInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Act Tracker User Activity Screenshots", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MultipleDeleteScreenShot", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerRecorder)]
        public JsonResult<BtrakJsonResult> GetActTrackerRecorder()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerRolePermissionRoles", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var result = _actTrackerService.GetActTrackerRecorder(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Act Tracker User Activity Screenshots", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerRecorder", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertActivityTrackerConfigurationState)]
        public JsonResult<BtrakJsonResult> UpsertActivityTrackerConfigurationState(ActivityTrackerConfigurationStateInputModel activityTrackerConfigurationStateInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertActivityTrackerConfigurationState", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var result = _actTrackerService.UpsertActivityTrackerConfigurationState(activityTrackerConfigurationStateInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActivityTrackerConfigurationState", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActivityTrackerConfigurationState", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetActivityTrackerHistory)]
        public JsonResult<BtrakJsonResult> GetActivityTrackerHistory(ActivityTrackerHistoryModel activityTrackerHistoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActivityTrackerHistory", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var result = _actTrackerService.GetActivityTrackerHistory(activityTrackerHistoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActivityTrackerHistory", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetActTrackerRoleDropDown, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertActivityTrackerUserConfiguration)]
        public JsonResult<BtrakJsonResult> UpsertActivityTrackerUserConfiguration(ActivityTrackerUserConfigurationInputModel activityTrackerUserConfigurationInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertActivityTrackerUserConfiguration", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var result = _actTrackerService.UpsertActivityTrackerUserConfiguration(activityTrackerUserConfigurationInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActivityTrackerUserConfiguration", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActivityTrackerUserConfiguration", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetActivityTrackerConfigurationState)]
        public JsonResult<BtrakJsonResult> GetActivityTrackerConfigurationState()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActivityTrackerConfigurationState", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var result = _actTrackerService.GetActivityTrackerConfigurationState(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActivityTrackerConfigurationState", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityTrackerConfigurationState", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerUserStatus)]
        public JsonResult<BtrakJsonResult> GetActTrackerUserStatus(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerUserStatus", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                var result = _actTrackerService.GetActTrackerUserStatus(employeeWebAppUsageTimeSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerUserStatus", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerUserStatus", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetActTrackerRecorderForTracker)]
        public JsonResult<BtrakJsonResult> GetActTrackerRecorderForTracker(ActivityTrackerInsertStatusInputModel activityTrackerInsertStatusInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActTrackerRecorderForTracker", "Act Tracker Api"));

                var headers = Request.Headers.Authorization;
                Guid? loggedInUserId = null;

                bool isLatestVersion = false;
                string versionName = string.Empty;

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (headers != null && headers.Scheme.ToLower() == "bearer")
                {
                    var jwtToken = headers.Parameter;

                    var decodeJwt = jwtToken != "null" ? _userAuthTokenFactory.DecodeUserAuthToken(jwtToken) : null;
                    if (decodeJwt != null)
                    {
                        loggedInUserId = decodeJwt.UserId;
                    }
                }

                //_activityTrackerService.UpsertActivityTrackerStatus(activityTrackerInsertStatusInputModel.DeviceId, validationMessages, loggedInUserId, null, null);

                var result = _actTrackerService.GetActTrackerRecorderForTracker(activityTrackerInsertStatusInputModel, validationMessages, loggedInUserId);

                // ReSharper disable once InvalidXmlDocComment
                /**
                 * Added UpsertActivityTrackerStatus to update tracker hearbeat. hits for every minute from the tracker
                 */
                var userIpAddress = HttpContext.Current.Request.UserHostAddress;

                string timeZone = null;
                int offset = 0;

                if (!string.Equals(userIpAddress, result.IpAddress) || string.IsNullOrEmpty(result.TimeZone))
                {
                    if (!string.IsNullOrEmpty(userIpAddress) && userIpAddress != "::1")
                    {
                        var timeZoneDetails = TimeZoneHelper.GetUserTimeZoneByIp(userIpAddress);
                        timeZone = timeZoneDetails?.TimeZone ?? null;
                        offset = timeZoneDetails?.OffsetMinutes ?? 0;
                    }
                    else
                    {
                        var timeZoneDetails = TimeZoneHelper.GetIstTime();
                        timeZone = timeZoneDetails?.TimeZone ?? null;
                        offset = timeZoneDetails?.OffsetMinutes ?? 0;
                    }
                    result.TimeZone = timeZone;
                    result.OffSet = offset;
                }
                else
                {
                    timeZone = result.TimeZone;
                }

                _activityTrackerService.UpsertActivityTrackerStatus(activityTrackerInsertStatusInputModel.DeviceId, validationMessages, loggedInUserId, userIpAddress, timeZone);

                //Version checking
                if (!string.IsNullOrEmpty(activityTrackerInsertStatusInputModel.MobileVersionNumber))
                {
                    isLatestVersion = activityTrackerInsertStatusInputModel.MobileVersionNumber.Equals(ConfigurationManager.AppSettings["MobileAppVersion"]);
                    versionName = ConfigurationManager.AppSettings["MobileAppVersion"];
                }
                if (!string.IsNullOrEmpty(activityTrackerInsertStatusInputModel.WindowsVersionNumber))
                {
                    isLatestVersion = activityTrackerInsertStatusInputModel.WindowsVersionNumber.Equals(ConfigurationManager.AppSettings["WindowsAppVersion"]);
                    versionName = ConfigurationManager.AppSettings["WindowsAppVersion"];
                }
                if (!string.IsNullOrEmpty(activityTrackerInsertStatusInputModel.LinuxVersionNumber))
                {
                    isLatestVersion = activityTrackerInsertStatusInputModel.LinuxVersionNumber.Equals(ConfigurationManager.AppSettings["LinuxAppVersion"]);
                    versionName = ConfigurationManager.AppSettings["LinuxAppVersion"];
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActTrackerRecorderForTracker", "Act Tracker Api"));
                }

                return Json(new BtrakJsonResult { VersionNumber = versionName, IsLatestVersion = isLatestVersion, Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActTrackerRecorderForTracker", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetUtcTime)]
        public JsonResult<BtrakJsonResult> GetUtcTime()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,
                    "GetUtcTime", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = DateTime.UtcNow, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUtcTime", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult { Data = DateTime.UtcNow, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.CheckSiteAddressExist)]
        public JsonResult<BtrakJsonResult> CheckSiteAddressExist()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,
                    "CheckSiteAddressExist", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = "SUCCESS", Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CheckSiteAddressExist", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult { Data = "SUCCESS", Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetActTrackerUserActivityScreenshotsBasedOnId)]
        public JsonResult<BtrakJsonResult> GetActTrackerUserActivityScreenshotsBasedOnId(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Act Tracker User Activity Screenshots", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<ActTrackerScreenshotsApiOutputModel> getActTrackerUserActivityScreenshotsOutputModel = _actTrackerService.GetActTrackerUserActivityScreenshotsBasedOnId(employeeWebAppUsageTimeSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Act Tracker User Activity Screenshots", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Act Tracker User Activity Screenshots", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = getActTrackerUserActivityScreenshotsOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetActTrackerRoleDropDown, exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMostProductiveUsers)]
        public JsonResult<BtrakJsonResult> GetMostProductiveUsers(MostProductiveUsersInputModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMostProductiveUsers", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<MostProductiveUsersOutputModel> data = _actTrackerService.GetMostProductiveUsers(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMostProductiveUsers", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMostProductiveUsers", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMostProductiveUsers", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTrackingUsers)]
        public JsonResult<BtrakJsonResult> GetTrackingUsers(TrackingUserModel inputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTrackingUsers", "Act Tracker Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<TrackingUserModel> data = _actTrackerService.GetTrackingUsers(inputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTrackingUsers", "Act Tracker Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTrackingUsers", "Act Tracker Api"));

                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTrackingUsers", "ActTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

    }
}