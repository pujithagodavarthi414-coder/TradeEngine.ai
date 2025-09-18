using Btrak.Models;
using Btrak.Models.ActivityTracker;
using Btrak.Models.ActTracker;
using Btrak.Models.TimeSheet;
using Btrak.Services.ActivityTracker;
using Btrak.Services.MSMQPublisher;
using Btrak.Services.TimeSheet;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.ActivityTracker
{
    public class ActivityTrackerApiController : AuthTokenApiController
    {
        private readonly UserAuthTokenFactory _userAuthTokenFactory = new UserAuthTokenFactory();
        private IActivityTrackerService _activityTrackerService;
        private ITrackerActivityPublisher _trackerActivityPublisher;
        private ITrackerScreenshotPublisher _trackerScreenshotPublisher;
        private readonly ITimeSheetService _timeSheetService;

        public ActivityTrackerApiController(
            IActivityTrackerService activityTrackerService,
            ITimeSheetService timeSheetService,
            ITrackerActivityPublisher trackerActivityPublisher,
            ITrackerScreenshotPublisher trackerScreenshotPublisher)
        {
            _activityTrackerService = activityTrackerService;
            _timeSheetService = timeSheetService;
            _trackerActivityPublisher = trackerActivityPublisher;
            _trackerScreenshotPublisher = trackerScreenshotPublisher;
        }

        //public JsonResult<BtrakJsonResult> InsertUserActivityTime(List<InsertUserActivityInputModel> insertUserActivityTimeInputModel)
        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.InsertUserActivityTime)]
        public JsonResult<BtrakJsonResult> InsertUserActivityTime(InsertUserActivityInputModel insertUserActivityTimeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Insert User Activity Time", "insertUserActivityTimeInputModel", insertUserActivityTimeInputModel, "ActivityTracker Api"));

                var headers = Request.Headers.Authorization;
                Guid? loggedInUserId = null;

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                if (headers != null && headers.Scheme.ToLower() == "bearer")
                {
                    var jwtToken = headers.Parameter;

                    var decodeJwt = jwtToken != "null" ? _userAuthTokenFactory.DecodeUserAuthToken(jwtToken) : null;
                    if (decodeJwt != null)
                    {
                        loggedInUserId = decodeJwt.UserId;
                    }
                }

                string status = _trackerActivityPublisher.InsertUserActivityTime(insertUserActivityTimeInputModel, validationMessages, loggedInUserId);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Insert User Activity Time", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Insert User Activity Time", "ActivityTracker Api"));
                if (status == null)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = status, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertUserActivityTime", "ActivityTrackerApiController", exception.Message) + " with data - " + JsonConvert.SerializeObject(insertUserActivityTimeInputModel, Formatting.Indented), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.InsertUserActivityScreenShot)]
        public JsonResult<BtrakJsonResult> InsertUserActivityScreenShot(InsertUserActivityScreenShotInputModel insertUserActivityScreenShotInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Insert User Activity ScreenShot", "insertUserActivityScreenShotInputModel", insertUserActivityScreenShotInputModel, "ActivityTracker Api"));

                var headers = Request.Headers.Authorization;
                Guid? loggedInUserId = null;

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                if (headers != null && headers.Scheme.ToLower() == "bearer")
                {
                    var jwtToken = headers.Parameter;

                    var decodeJwt = jwtToken != "null" ? _userAuthTokenFactory.DecodeUserAuthToken(jwtToken) : null;
                    if (decodeJwt != null)
                    {
                        loggedInUserId = decodeJwt.UserId;
                    }
                }

                var status = _trackerScreenshotPublisher.InsertUserActivityScreenShot(insertUserActivityScreenShotInputModel, validationMessages, loggedInUserId);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Insert User Activity ScreenShot", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Insert User Activity ScreenShot", "ActivityTracker Api"));
                if (status == null)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = status, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertUserActivityScreenShot", "ActivityTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.UpsertActivityTrackerStatus)]
        public JsonResult<BtrakJsonResult> UpsertActivityTrackerStatus([FromBody] string deviceId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertActivityTrackerStatus", "", " ", "ActivityTracker Api"));

                var userIpAddress = HttpContext.Current.Request.UserHostAddress;

                string timeZone = null;

                if (!string.IsNullOrEmpty(userIpAddress) && userIpAddress != "::1")
                {
                    timeZone = TimeZoneHelper.GetUserTimeZoneByIp(userIpAddress)?.TimeZone ?? null;
                }
                else
                {
                    timeZone = TimeZoneHelper.GetIstTime()?.TimeZone ?? null;
                }

                var headers = Request.Headers.Authorization;
                Guid? loggedInUserId = null;

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                if (headers != null && headers.Scheme.ToLower() == "bearer")
                {
                    var jwtToken = headers.Parameter;

                    var decodeJwt = jwtToken != "null" ? _userAuthTokenFactory.DecodeUserAuthToken(jwtToken) : null;
                    if (decodeJwt != null)
                    {
                        loggedInUserId = decodeJwt.UserId;
                    }
                }

                string status = _activityTrackerService.UpsertActivityTrackerStatus(deviceId, validationMessages, loggedInUserId, userIpAddress, timeZone);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Insert User Activity ScreenShot", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Insert User Activity ScreenShot", "ActivityTracker Api"));
                if (status == null)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = status, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActivityTrackerStatus", "ActivityTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTotalTimeUsageOfApplicationsByUsers)]
        public JsonResult<BtrakJsonResult> GetTotalTimeUsageOfApplicationsByUsers(TimeUsageOfApplicationSearchInputModel timeUsageOfApplicationSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Total Time Usage Of Applications By Users", "timeUsageOfApplicationSearchInputModel", timeUsageOfApplicationSearchInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                var totalTimeUsage = _activityTrackerService.GetTotalTimeUsageOfApplicationsByUsers(timeUsageOfApplicationSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Total Time Usage Of Applications By Users", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Total Time Usage Of Applications By Users", "ActivityTracker Api"));
                if (totalTimeUsage == null)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = totalTimeUsage, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTotalTimeUsageOfApplicationsByUsers", "ActivityTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTimeUsageDrillDown)]

        public JsonResult<BtrakJsonResult> GetTimeUsageDrillDown(TimeUsageDrillDownSearchInputModel timeUsageDrillDownSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Time Usage Drill Down", "timeUsageDrillDownSearchInputModel", timeUsageDrillDownSearchInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                var totalTimeUsage = _activityTrackerService.GetTimeUsageDrillDown(timeUsageDrillDownSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Time Usage Drill Down", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Time Usage Drill Down", "ActivityTracker Api"));
                if (totalTimeUsage == null)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = totalTimeUsage, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTotalTimeUsageDrillDown", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTotalTeamMembers)]
        public JsonResult<BtrakJsonResult> GetTotalTeamMembers(TimeUsageDrillDownSearchInputModel timeUsageDrillDownSearchInputModel)
        {
            try
            {
                //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Time Usage Drill Down", "timeUsageDrillDownSearchInputModel", timeUsageDrillDownSearchInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                var totalTeamMembers = _activityTrackerService.GetTotalTeamMembers(timeUsageDrillDownSearchInputModel, LoggedInContext, validationMessages);
                //if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                //{
                //    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                //    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Time Usage Drill Down", "ActivityTracker Api"));
                //    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                //}
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Time Usage Drill Down", "ActivityTracker Api"));
                if (totalTeamMembers == null)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = totalTeamMembers, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTotalTimeUsageDrillDown", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployees)]
        public JsonResult<BtrakJsonResult> GetEmployees(EmployeeSearchInputModel employeeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Employees By Roles", "EmployeeSearchInputModel", employeeSearchInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                List<EmployeeSearchOutputModel> employees = _activityTrackerService.GetEmployees(employeeSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employees By Roles", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employees By Roles", "ActivityTracker Api"));
                if (employees.Count == 0)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = employees, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployees", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetWebAppUsageTime)]
        public JsonResult<BtrakJsonResult> GetWebAppUsageTime(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Employees By Roles", "employeeWebAppUsageTimeSearchInputModel", employeeWebAppUsageTimeSearchInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                List<EmployeeWebAppUsageTimeOutputModel> employees = _activityTrackerService.GetWebAppUsageTime(employeeWebAppUsageTimeSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employees By Roles", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employees By Roles", "ActivityTracker Api"));
                if (employees == null || employees.Count == 0)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = employees, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetWebAppUsageTime", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetActivityTrackerInformation)]
        public JsonResult<BtrakJsonResult> GetActivityTrackerInformation(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Activity Tracker Information", "employeeWebAppUsageTimeSearchInputModel", employeeWebAppUsageTimeSearchInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                var employees = _activityTrackerService.GetActivityTrackerInformation(LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Activity Tracker Information", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Activity Tracker Information", "ActivityTracker Api"));
                if (employees == null)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = employees, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityTrackerInformation", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTrackedInformationOfUserStory)]
        public JsonResult<BtrakJsonResult> GetTrackedInformationOfUserStory(TrackedInformationOfUserStorySearchInputModel trackedInformationOfUserStorySearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Tracked Information Of UserStory", "trackedInformationOfUserStorySearchInputModel", trackedInformationOfUserStorySearchInputModel, "ActivityTracker Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult _btrakJsonResult;

                var result = _activityTrackerService.GetTrackedInformationOfUserStory(trackedInformationOfUserStorySearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Activity Tracker Information", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Tracked Information Of UserStory", "ActivityTracker Api"));

                if (result == null)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTrackedInformationOfUserStory", "ActivityTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAppUsageCompleteReport)]
        public JsonResult<BtrakJsonResult> GetAppUsageCompleteReport(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Employee Tracker Complete Report", "employeeTrackerSearchInputModel", employeeTrackerSearchInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                List<EmployeeTrackerOutputModel> employees = _activityTrackerService.GetAppUsageCompleteReport(employeeTrackerSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee Tracker Complete Report", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee Tracker Complete Report", "ActivityTracker Api"));
                if (employees == null || employees.Count == 0)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = employees, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAppUsageCompleteReport", "ActivityTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAppUsageUserStoryReport)]
        public JsonResult<BtrakJsonResult> GetAppUsageUserStoryReport(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Employee Tracker Complete Report", "employeeTrackerSearchInputModel", employeeTrackerSearchInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                List<EmployeeTrackerUserstoryOutputModel> employees = _activityTrackerService.GetAppUsageUserStoryReport(employeeTrackerSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee Tracker Complete Report", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee Tracker Complete Report", "ActivityTracker Api"));
                if (employees == null || employees.Count == 0)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = employees, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAppUsageUserStoryReport", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAppUsageTimesheetReport)]
        public JsonResult<BtrakJsonResult> GetAppUsageTimesheetReport(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Employee Tracker Complete Report", "employeeTrackerSearchInputModel", employeeTrackerSearchInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                List<EmployeeTrackerTimesheetOutputModel> employees = _activityTrackerService.GetAppUsageTimesheetReport(employeeTrackerSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee Tracker Complete Report", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Employee Tracker Complete Report", "ActivityTracker Api"));
                if (employees == null || employees.Count == 0)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = employees, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAppUsageTimesheetReport", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetActivityTrackerUsageTimeReport)]
        public JsonResult<BtrakJsonResult> GetActivityTrackerUsageTimeReport(ActivityTrackerUsageInputModel activityTrackerUsageInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserActivityTrackerUsageReport", "activityTrackerUsageInputModel", activityTrackerUsageInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                List<ActivityTrackerUsageOutputModel> activityTrackerUsageOutputModels =
                    _activityTrackerService.GetUserActivityTrackerUsageReport(activityTrackerUsageInputModel,
                        LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserActivityTrackerUsageReport", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserActivityTrackerUsageReport", "ActivityTracker Api"));

                return Json(new BtrakJsonResult { Data = activityTrackerUsageOutputModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityTrackerUsageTimeReport", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.UpsertUserActivityToken)]
        public JsonResult<BtrakJsonResult> UpsertUserActivityToken(ActivityTrackerTokenInputModel UpsertUserActivityToken)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserActivityToken", "UpsertUserActivityToken", UpsertUserActivityToken, "ActivityTracker Api"));

                var headers = Request.Headers.Authorization;
                Guid? loggedInUserId = null;

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                if (headers != null && headers.Scheme.ToLower() == "bearer")
                {
                    var jwtToken = headers.Parameter;

                    var decodeJwt = jwtToken != "null" ? _userAuthTokenFactory.DecodeUserAuthToken(jwtToken) : null;
                    if (decodeJwt != null)
                    {
                        loggedInUserId = decodeJwt.UserId;
                    }
                }

                var activityToken =
                    _activityTrackerService.UpsertUserActivityToken(UpsertUserActivityToken,
                        loggedInUserId, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserActivityToken", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserActivityToken", "ActivityTracker Api"));

                return Json(new BtrakJsonResult { Data = activityToken, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertuserActivityToken", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetIdleAndInactiveTimeForEmployee)]
        public JsonResult<BtrakJsonResult> GetIdleAndInactiveTimeForEmployee(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Idle And Inactive Time For Employee", "employeeTrackerSearchInputModel", employeeTrackerSearchInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;
                List<EmployeeTrackerOutputModel> employees = _activityTrackerService.GetIdleAndInactiveTimeForEmployee(employeeTrackerSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Idle And Inactive Time For Employee", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Idle And Inactive Time For Employee", "ActivityTracker Api"));
                if (employees == null || employees.Count == 0)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = employees, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIdleAndInactiveTimeForEmployee", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpserActivityTrackerUsage)]
        public JsonResult<BtrakJsonResult> UpserActivityTrackerUsage(InsertUserActivityInputModel insertUserActivityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpserActivityTrackerUsage", "UpsertUserActivityToken", insertUserActivityInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                var response =
                    _activityTrackerService.UpserActivityTrackerUsage(insertUserActivityInputModel,
                         validationMessages, LoggedInContext);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpserActivityTrackerUsage", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpserActivityTrackerUsage", "ActivityTracker Api"));

                return Json(new BtrakJsonResult { Data = response, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpserActivityTrackerUsage", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetActivityTrackerModes)]
        public JsonResult<BtrakJsonResult> GetActivityTrackerModes()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActivityTrackerModes", "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var response =
                    _activityTrackerService.GetActivityTrackerModes(validationMessages, LoggedInContext);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActivityTrackerModes", "ActivityTracker Api"));

                return Json(new BtrakJsonResult { Data = response, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityTrackerModes", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertActivityTrackerModeConfig)]
        public JsonResult<BtrakJsonResult> UpsertActivityTrackerModeConfig(ActivityTrackerModeConfigurationInputModel config)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertActivityTrackerModeConfig", "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var response =
                    _activityTrackerService.UpsertActivityTrackerModeConfig(config, validationMessages, LoggedInContext);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertActivityTrackerModeConfig", "ActivityTracker Api"));

                return Json(new BtrakJsonResult { Data = response, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertActivityTrackerModeConfig", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetActivityTrackerModeConfig)]
        public JsonResult<BtrakJsonResult> GetActivityTrackerModeConfig()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActivityTrackerModeConfig", "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var response =
                    _activityTrackerService.GetActivityTrackerModeConfig(validationMessages, LoggedInContext);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActivityTrackerModeConfig", "ActivityTracker Api"));

                return Json(new BtrakJsonResult { Data = response, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityTrackerModeConfig", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTrackerDesktops)]
        public JsonResult<BtrakJsonResult> GetTrackerDesktops(ActivityTrackerDesktopsModel activityTrackerDesktopModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTrackerDesktops", "ActivityTracker Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                var splits = HttpContext.Current.Request.Url.Authority.Split('.');

                activityTrackerDesktopModel.CompanyUrl = splits[0];

                var desktops = _activityTrackerService.GetTrackerDesktops(activityTrackerDesktopModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTrackerDesktops", "ActivityTracker Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTrackerDesktops", "ActivityTracker Api"));
                return Json(new BtrakJsonResult { Data = desktops, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTrackerDesktops", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetModeType)]
        public JsonResult<BtrakJsonResult> GetModeType(TrackerModeInputModel input)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetModeType", "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                TrackerModeOutputModel response = _activityTrackerService.GetModeType(input, validationMessages);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetModeType", "ActivityTracker Api"));

                return Json(new BtrakJsonResult { Data = response, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings); ;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetModeType", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserTrackerTimeline)]
        public JsonResult<BtrakJsonResult> GetUserTrackerTimeline(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserTrackerTimeline", "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                var timelineDetails = _activityTrackerService.GetUserTrackerTimeline(employeeTrackerSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserTrackerTimeline", "ActivityTracker Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserTrackerTimeline", "ActivityTracker Api"));
                return Json(new BtrakJsonResult { Data = timelineDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserTrackerTimeline", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetActivityReport)]
        public JsonResult<BtrakJsonResult> GetActivityReport(ActivityReportInputModel activityReportInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetActivityReport", "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ActivityReportOutputModel> data = _activityTrackerService.GetActivityReport(activityReportInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActivityReport", "ActivityTracker Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetActivityReport", "ActivityTracker Api"));
                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityReport", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.UploadScreenShotToServer)]
        public JsonResult<BtrakJsonResult> UploadScreenShotToServer([FromBody] string requestDataJson)
        {
            try
            {
                ScreenShotData.UploadScreenShot(requestDataJson);
                return Json(new BtrakJsonResult { Data = true, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Info($"UploadScreenShotToServer_error: {exception.Message} requestDataJson: {requestDataJson}");

                return Json(new BtrakJsonResult { Data = false, Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetApplicationCategory)]
        public JsonResult<BtrakJsonResult> GetApplicationCategory(ApplicationCategoryModel applicationCategoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetApplicationCategory", "employeeTrackerSearchInputModel", applicationCategoryModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                List<ApplicationCategoryModel> applicationCategories = _activityTrackerService.GetApplicationCategory(applicationCategoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetApplicationCategory", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetApplicationCategory", "ActivityTracker Api"));

                return Json(new BtrakJsonResult { Data = applicationCategories, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetApplicationCategory", "ActivityTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertApplicationCategory)]
        public JsonResult<BtrakJsonResult> UpsertApplicationCategory(ApplicationCategoryModel applicationCategoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertApplicationCategory", "employeeTrackerSearchInputModel", applicationCategoryModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                Guid? applicationCategoryId = _activityTrackerService.UpsertApplicationCategory(applicationCategoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertApplicationCategory", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertApplicationCategory", "ActivityTracker Api"));

                return Json(new BtrakJsonResult { Data = applicationCategoryId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertApplicationCategory", "ActivityTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTeamActivity)]
        public JsonResult<BtrakJsonResult> GetTeamActivity(TeamActivityInputModel activityReportInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetTeamActivity", "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<TeamActivityOutputModel> data = _activityTrackerService.GetTeamActivity(activityReportInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTeamActivity", "ActivityTracker Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTeamActivity", "ActivityTracker Api"));
                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetActivityReport", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserStartTime)]
        public JsonResult<BtrakJsonResult> GetUserStartTime(ActivityKpiSearchModel activityKpiSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserStartTime", "ActivityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                var startTime = _activityTrackerService.GetUserStartTime(activityKpiSearchModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Start Time", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Start Time", "ActivityTracker Api"));
                return Json(new BtrakJsonResult { Data = startTime, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Start Time", "ActivityTracker Api"), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserFinishTime)]
        public JsonResult<BtrakJsonResult> GetUserFinishTime(ActivityKpiSearchModel activityKpiSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserFinishTime", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                var finishTime = _activityTrackerService.GetUserFinishTime(activityKpiSearchModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Finish Time", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Finish Time", "ActivityTracker Api"));
                return Json(new BtrakJsonResult { Data = finishTime, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Finish Time", "ActivityTracker Api"), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetLateEmployees)]
        public JsonResult<BtrakJsonResult> GetLateEmployees(ActivityKpiSearchModel activityKpiSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLateEmployee", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                int result = _activityTrackerService.GetLateEmployees(activityKpiSearchModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Time Usage Drill Down", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Time Usage Drill Down", "ActivityTracker Api"));

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTotalTimeUsageDrillDown", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetPresentEmployees)]
        public JsonResult<BtrakJsonResult> GetPresentEmployees(ActivityKpiSearchModel activityKpiSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetpresentEmployee", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                int result = _activityTrackerService.GetPresentEmployees(activityKpiSearchModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Time Usage Drill Down", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Time Usage Drill Down", "ActivityTracker Api"));

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTotalTimeUsageDrillDown", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAbsentEmployees)]
        public JsonResult<BtrakJsonResult> GetAbsentEmployees(ActivityKpiSearchModel activityKpiSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAbsentEmployees", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                int result = _activityTrackerService.GetAbsentEmployees(activityKpiSearchModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAbsentEmployees", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAbsentEmployees", "ActivityTracker Api"));

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAbsentEmployees", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetProductiveTime)]
        public JsonResult<BtrakJsonResult> GetProductiveTime(ActivityKpiSearchModel activityKpiSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Productive Time", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                var productiveTime = _activityTrackerService.GetProductiveTime(activityKpiSearchModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Productive Time", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Productive Time", "ActivityTracker Api"));
                return Json(new BtrakJsonResult { Data = productiveTime, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Productive Time", "ActivityTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUnproductiveTime)]
        public JsonResult<BtrakJsonResult> GetUnproductiveTime(ActivityKpiSearchModel activityKpiSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Unproductive Time", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                var unproductiveTime = _activityTrackerService.GetUnproductiveTime(activityKpiSearchModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Unproductive Time", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Unproductive Time", "ActivityTracker Api"));
                return Json(new BtrakJsonResult { Data = unproductiveTime, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Unproductive Time", "ActivityTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetIdleTime)]
        public JsonResult<BtrakJsonResult> GetIdleTime(ActivityKpiSearchModel activityKpiSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Idle Time", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                var idleTime = _activityTrackerService.GetIdleTime(activityKpiSearchModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Idle Time", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Idle Time", "ActivityTracker Api"));
                return Json(new BtrakJsonResult { Data = idleTime, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Idle Time", "ActivityTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetNeutralTime)]
        public JsonResult<BtrakJsonResult> GetNeutralTime(ActivityKpiSearchModel activityKpiSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Neutral Time", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                string neutralTime = _activityTrackerService.GetNeutralTime(activityKpiSearchModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Neutral Time", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Neutral Time", "ActivityTracker Api"));
                return Json(new BtrakJsonResult { Data = neutralTime, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Neutral Time", "ActivityTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetDeskTime)]
        public JsonResult<BtrakJsonResult> GetDeskTime(ActivityKpiSearchModel activityKpiSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Desk Time", "activityKpiSearchModel", activityKpiSearchModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                var deskTime = _activityTrackerService.GetDeskTime(activityKpiSearchModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Desk Time", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Desk Time", "ActivityTracker Api"));
                return Json(new BtrakJsonResult { Data = deskTime, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Get Desk Time", "ActivityTrackerApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAvailabilityCalendar)]
        public JsonResult<BtrakJsonResult> GetAvailabilityCalendar(AvailabilityCalendarInputModel availabilityCalendarInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAvailabilityCalendar", "AvailabilityCalendarInputModel", availabilityCalendarInputModel, "ActivityTracker Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult _btrakJsonResult;

                List<AvailabilityCalendarOutputModel> result = _activityTrackerService.GetAvailabilityCalendar(availabilityCalendarInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAvailabilityCalendar", "ActivityTracker Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAvailabilityCalendar", "ActivityTracker Api"));
                if (result != null && result.Count == 0)
                {
                    return Json(new BtrakJsonResult { Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAvailabilityCalendar", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.UpdatePunchCardFromTracker)]
        public JsonResult<BtrakJsonResult> UpdatePunchCardFromTracker([FromBody] TrackerPunchCardInputModel trackerPunchCardData)
        {
            try
            {
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                var upsertUserPunchCardInputModel = new UpsertUserPunchCardInputModel
                {
                    DeviceId = trackerPunchCardData.DeviceId,
                    ButtonTypeId = trackerPunchCardData.ButtonTypeId,
                    AutoTimeSheet = true
                };
                bool? userPunchCardResult = _timeSheetService.UpsertUserPunchCard(upsertUserPunchCardInputModel, LoggedInContext, validationMessages);

                return Json(new BtrakJsonResult { Data = true, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdatePunchCard", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetCompanyStatus)]
        public JsonResult<BtrakJsonResult> GetCompanyStatus()
        {
            try
            {
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                CompanyStatus companyStatusModel = _activityTrackerService.GetCompanyStatus(LoggedInContext, validationMessages);

                return Json(new BtrakJsonResult { Data = companyStatusModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyStatus", "ActivityTrackerApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}