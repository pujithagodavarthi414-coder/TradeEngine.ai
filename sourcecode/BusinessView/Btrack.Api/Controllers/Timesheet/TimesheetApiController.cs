using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.TimeSheet;
using Btrak.Services;
using Btrak.Services.TimeSheet;
using Btrak.Services.User;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Hangfire;
using Newtonsoft.Json;
using Btrak.Models.StatusReportingConfiguration;
using Btrak.Services.StatusReporting;
using Btrak.Services.TestRail;
using Btrak.Services.Features;
using Btrak.Services.PubNub;
using Btrak.Services.Chat;
using Btrak.Models.Chat;
using System.Threading.Tasks;
using Btrak.Services.ActivityTracker;
using Btrak.Models.MasterData;
using System.Web;
using Btrak.Services.ButtonType;
using Btrak.Models.ButtonType;
using Btrak.Models.TestRail;
using Btrak.Models.ActivityTracker;

namespace BTrak.Api.Controllers.TimeSheet
{
    public class TimeSheetApiController : AuthTokenApiController
    {
        private readonly ITimeSheetService _timeSheetService;
        private readonly IUserService _userService;
        private readonly IUpdateGoalService _updateGoalService;
        private readonly IStatusReportingService _statusReportingService;
        private readonly ITestRunService _testRunService;
        private readonly IFeatureService _featureService;
        private readonly IChatService _chatService;
        private readonly IActivityTrackerService _activityTrackerService;
        private readonly IPubNubService _pubNubService;
        private readonly IButtonTypeService _buttonTypeService;

        public TimeSheetApiController(UserService userService, UpdateGoalService updateGoalService, IStatusReportingService statusReportingService, ITestRunService testRunService, IFeatureService featureService , IChatService chatService, IActivityTrackerService activityTrackerService,IPubNubService pubNubservice, ITimeSheetService timeSheetService, IButtonTypeService buttonTypeService)
        {
            _timeSheetService = timeSheetService;
            _userService = userService;
            _updateGoalService = updateGoalService;
            _statusReportingService = statusReportingService;
            _testRunService = testRunService;
            _featureService = featureService;
            _chatService = chatService;
            _activityTrackerService = activityTrackerService;
            _pubNubService = pubNubservice;
            _buttonTypeService = buttonTypeService;
        }
    
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTimeSheet)]
        public JsonResult<BtrakJsonResult> UpsertTimeSheet(TimeSheetManagementInputModel timeSheetModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeSheet", "timeSheetModel", timeSheetModel, "TimeSheet Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? timeSheetIdReturned = _timeSheetService.UpsertTimeSheet(timeSheetModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeSheet", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                _activityTrackerService.GetChatActivityTrackerRecorder(LoggedInContext, validationMessages);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeSheet", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = timeSheetIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeSheet ", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEnableOrDisableTimeSheetButtonDetails)]
        public JsonResult<BtrakJsonResult> GetEnableOrDisableTimeSheetButtonDetails(Guid? userId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEnableOrDisableTimeSheetButtonDetails", "userId", userId, "TimeSheet Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                TimeSheetManagementButtonDetails enableOrDisableDetails = _timeSheetService.GetEnableOrDisableTimeSheetButtonDetails(userId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEnableOrDisableTimeSheetButtonDetails", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEnableOrDisableTimeSheetButtonDetails", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = enableOrDisableDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, " GetEnableOrDisableTimeSheetButtonDetails", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTimeSheetDetails)]
        public JsonResult<BtrakJsonResult> GetTimeSheetDetails(TimeSheetManagementSearchInputModel getTimeSheetDetails)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTimeSheetDetails", "getTimeSheetDetails", getTimeSheetDetails, "TimeSheet Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                List<TimeSheetManagementApiOutputModel> timeSheetDetails = _timeSheetService.GetTimeSheetDetails(getTimeSheetDetails, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetDetails", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetDetails", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = timeSheetDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, " GetTimeSheetDetails", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTimeSheetDetailsUploadTemplate)]
        public JsonResult<BtrakJsonResult> GetTimeSheetDetailsUploadTemplate(TimeSheetManagementSearchInputModel getTimeSheetDetails)
        {
            try
            {
                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                PdfGenerationOutputModel file = _timeSheetService.GetTimeSheetDetailsUploadTemplate(getTimeSheetDetails, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetDetailsUploadTemplate", "Timesheet Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetDetailsUploadTemplate", "Timesheet Api"));

                return Json(new BtrakJsonResult { Data = file, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeSheetDetailsUploadTemplate", "TimeSheetApiController", exception.Message),exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUserBreakDetails)]
        public JsonResult<BtrakJsonResult> UpsertUserBreakDetails(UserBreakDetailsInputModel userBreakModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserBreakDetails", "userBreakModel", userBreakModel, "TimeSheet Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? timeSheetIdReturned = _timeSheetService.UpsertUserBreakDetails(userBreakModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserBreakDetails", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserBreakDetails", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = timeSheetIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, " UpsertUserBreakDetails", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserBreakDetails)]
        public JsonResult<BtrakJsonResult> GetUserBreakDetails(GetUserBreakDetailsInputModel getUserBreakDetails)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserBreakDeatils", "getUserBreakDetails", getUserBreakDetails, "TimeSheet Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                List<UserBreakDetailsOutputModel> userBreakDetails = _timeSheetService.GetUserBreakDetails(getUserBreakDetails, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserBreakDeatils", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserBreakDeatils", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = userBreakDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserBreakDetails ", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetMyTimeSheetDetails)]
        public JsonResult<BtrakJsonResult> GetMyTimeSheetDetails(TimeSheetManagementSearchInputModel getTimeSheetDetails)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetMyTimeSheetDetails", "getTimeSheetDetails", getTimeSheetDetails, "TimeSheet Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                if (getTimeSheetDetails == null)
                {
                    getTimeSheetDetails = new TimeSheetManagementSearchInputModel();
                }

                //getTimeSheetDetails.UserId = LoggedInContext.LoggedInUserId;

                List<TimeSheetManagementApiOutputModel> timeSheetDetails = _timeSheetService.GetTimeSheetDetails(getTimeSheetDetails, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMyTimeSheetDetails", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetMyTimeSheetDetails", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = timeSheetDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMyTimeSheetDetails ", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTimeSheetHistoryDetails)]
        public JsonResult<BtrakJsonResult> GetTimeSheetHistoryDetails(TimeSheetManagementSearchInputModel getTimeSheetDetails)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTimeSheetHistoryDetails", "getTimeSheetDetails", getTimeSheetDetails, "TimeSheet Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                List<TimeSheetManagementApiOutputModel> getTimeSheetHistoryDetails = _timeSheetService.GetTimeSheetHistoryDetails(getTimeSheetDetails, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetHistoryDetails", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetHistoryDetails", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = getTimeSheetHistoryDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, " GetTimeSheetHistoryDetails", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTimeSheetPermissions)]
        public JsonResult<BtrakJsonResult> UpsertTimeSheetPermissions(TimeSheetManagementPermissionInputModel timeSheetPermissionsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeSheetPermissions", "timeSheetPermissionsModel", timeSheetPermissionsModel, "TimeSheet Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? timeSheetIdReturned = _timeSheetService.UpsertTimeSheetPermissions(timeSheetPermissionsModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeSheetPermissions", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeSheetPermissions", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = timeSheetIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeSheetPermissions ", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTimeSheetPermissions)]
        public JsonResult<BtrakJsonResult> GetTimeSheetPermissions(TimeSheetManagementPermissionInputModel timeSheetPermissionsModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTimeSheetPermissions", "timeSheetPermissionsModel", timeSheetPermissionsModel, "TimeSheet Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                List<TimeSheetManagementPermissionOutputModel> getTimeSheetPermissions = _timeSheetService.GetTimeSheetPermissions(timeSheetPermissionsModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetPermissions", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetPermissions", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = getTimeSheetPermissions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeSheetPermissions ", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTimeSheetPermissionReasons)]
        public JsonResult<BtrakJsonResult> UpsertTimeSheetPermissionReasons(TimeSheetPermissionReasonInputModel timeSheetPermissionReasonInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeSheetPermissionReasons", "timeSheetPermissionReasonInputModel", timeSheetPermissionReasonInputModel, "TimeSheet Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? timeSheetPermissionReasonsIdReturned = _timeSheetService.UpsertTimeSheetPermissionReasons(timeSheetPermissionReasonInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeSheetPermissionReasons", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeSheetPermissionReasons", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = timeSheetPermissionReasonsIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeSheetPermissionReasons ", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllPermissionReasons)]
        public JsonResult<BtrakJsonResult> GetAllPermissionReasons(GetPermissionReasonModel getPermissionReasonModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPermissionReasons", "TimeSheet Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                List<TimeSheetPermissionReasonOutputModel> permissionReasons = _timeSheetService.GetAllPermissionReasons(getPermissionReasonModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPermissionReasons", "TimeSheet Api"));
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPermissions Test Suite", "Permission Api"));
                return Json(new BtrakJsonResult { Data = permissionReasons, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllPermissionReasons ", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUserPunchCard)]
        public JsonResult<BtrakJsonResult> UpsertUserPunchCard(UpsertUserPunchCardInputModel upsertUserPunchCardInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserPunchCard", "upsertUserPunchCardInputModel", upsertUserPunchCardInputModel, "TimeSheet Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;
                bool? userPunchCardResult = _timeSheetService.UpsertUserPunchCard(upsertUserPunchCardInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserPunchCardInputModel", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                string hostAddress = HttpContext.Current.Request.UserHostAddress;

                ButtonTypeByIdOutputModel buttonTypeDetails = _buttonTypeService.GetButtonTypeDetailsById(upsertUserPunchCardInputModel.ButtonTypeId, LoggedInContext, validationMessages);

                if (buttonTypeDetails != null && buttonTypeDetails.IsFinish == true)
                {
                    _pubNubService.PublishFinishStatusOfUser(LoggedInContext, hostAddress);
                    
                    PostUpdatesToBtrakChat();
                }
                else if (buttonTypeDetails != null && buttonTypeDetails.IsBreakIn == true)
                {
                    _pubNubService.PublishBreakStartStatusOfUser(LoggedInContext, hostAddress);
                }
                else if (buttonTypeDetails != null && buttonTypeDetails.BreakOut == true)
                {
                    _pubNubService.PublishBreakEndStatusOfUser(LoggedInContext, hostAddress);
                }
                else if (buttonTypeDetails != null && buttonTypeDetails.IsLunchStart == true)
                {
                    _pubNubService.PublishLunchStartStatusOfUser(LoggedInContext, hostAddress);
                }
                else if (buttonTypeDetails != null && buttonTypeDetails.IsLunchEnd == true)
                {
                   _pubNubService.PublishLunchEndStatusOfUser(LoggedInContext, hostAddress);
                }
                else if (buttonTypeDetails != null && buttonTypeDetails.IsStart == true)
                {
                    _pubNubService.PublishStartStatusOfUser(LoggedInContext, hostAddress);
                }

                _activityTrackerService.GetChatActivityTrackerRecorder(LoggedInContext, validationMessages);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserPunchCardInputModel", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = userPunchCardResult, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserPunchCard ", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ValidateUserLocation)]
        public JsonResult<BtrakJsonResult> ValidateUserLocation(UserLocationInputModel userLocationInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ValidateUserLocation", "userLocationInputModel", userLocationInputModel, "TimeSheet Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                bool? userLocationResult = _timeSheetService.ValidateUserLocation(userLocationInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ValidateUserLocation", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ValidateUserLocation", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = userLocationResult, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateUserLocation ", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetFeedTimeHistory)]
        public JsonResult<BtrakJsonResult> GetFeedTimeHistory(GetFeedTimeHistoryInputModel getFeedTimeHistoryInputModel)
        {
            List<ValidationMessage> validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Feed Time History", "getFeedTimeHistoryInputModel", getFeedTimeHistoryInputModel, "TimeSheet Api"));
                BtrakJsonResult btrakJsonResult;
                List<TimeFeedHistoryApiReturnModel> getFeedTimeHistory = _timeSheetService.GetFeedTimeHistory(getFeedTimeHistoryInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Feed Time History", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Feed Time History", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = getFeedTimeHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetFeedTimeHistory)
                });

                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserFeedTimeHistory)]
        public JsonResult<BtrakJsonResult> GetUserFeedTimeHistory(GetFeedTimeHistoryInputModel getFeedTimeHistoryInputModel)
        {
            List<ValidationMessage> validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserFeedTimeHistory", "getFeedTimeHistoryInputModel", getFeedTimeHistoryInputModel, "TimeSheet Api"));
                BtrakJsonResult btrakJsonResult;
                if (getFeedTimeHistoryInputModel == null)
                {
                    getFeedTimeHistoryInputModel = new GetFeedTimeHistoryInputModel();
                }

                //getFeedTimeHistoryInputModel.UserId = LoggedInContext.LoggedInUserId;
                List<TimeFeedHistoryApiReturnModel> getFeedTimeHistory = _timeSheetService.GetFeedTimeHistory(getFeedTimeHistoryInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserFeedTimeHistory", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserFeedTimeHistory", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = getFeedTimeHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.ExceptionGetUserFeedTimeHistory)
                });

                return null;
            }
        }
        
        private void PostUpdatesToBtrakChat()
        {
            try
            {
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var userWebHooks = _userService.GetUserWebHooksById(LoggedInContext.LoggedInUserId, LoggedInContext, validationMessages);

                if (userWebHooks != null && userWebHooks.WebHooksList.Count > 0)
                {
                    SendMessagesToUserWebhooks(userWebHooks.WebHooksList);
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PostUpdatesToBtrakChat ", " TimeSheetApiController", ex.Message), ex);

            }
        }

        private void SendMessagesToUserWebhooks(List<string> webHooksList)
        {
            try
            {
                if (webHooksList != null)
                {
                    List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                    foreach (var webHook in webHooksList)
                    {
                        Guid? featureId = _featureService.GetAllUserPermittedFeatures(LoggedInContext, validationMessages).FirstOrDefault(x => x.FeatureId == AppConstants.ViewTestrepoReports)?.FeatureId;

                        if (featureId != null)
                        {
                            BackgroundJob.Enqueue(() => _testRunService.PushSplitBarToWebHook(webHook, LoggedInContext));
                        }

                        BackgroundJob.Enqueue(() => _timeSheetService.PushMessageToUserWebHook(LoggedInContext, webHook));
                        BackgroundJob.Enqueue(() => _updateGoalService.PostProcessDashboardToWebHook(LoggedInContext, webHook));
                        BackgroundJob.Enqueue(() => _updateGoalService.PostLeastPerformingGoalBurndownToWebHook(LoggedInContext, webHook));
                        BackgroundJob.Enqueue(() => _updateGoalService.PostBurndownToWebHook(LoggedInContext, webHook, 110, "EXEC [USP_GetEmployeeExpectedBurndownDetail] \'" + LoggedInContext.LoggedInUserId + "\'"));
                        BackgroundJob.Enqueue(() => _updateGoalService.PullDataToWebHook("EXEC [dbo].[USP_GetRemainingWorkAllocatedForAnEmployee] @OperationsPerformedBy=\'" + LoggedInContext.LoggedInUserId + "\'", "Remaining work allocated", "Remaining work allocated", webHook, LoggedInContext));
                    }
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendMessagesToUserWebhooks ", " TimeSheetApiController", ex.Message), ex);

            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEnableorDisableTimesheetButtons)]
        public string GetEnableorDisableTimesheetButtons()
        {
            return JsonConvert.SerializeObject(_timeSheetService.GetEnableorDisableTimesheetButtons(LoggedInContext));
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTimesheetHistoryDetails)]
        public IList<AuditJsonModel> GetTimesheetHistoryDetails()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get history Details", "Timesheet Api"));

                DateTime currentDate = DateTime.Now.Date;
                DateTime dateFrom = currentDate; DateTime dateTo = currentDate;
                return _timeSheetService.GetTimesheetHistoryDetails(Guid.Empty, dateFrom, dateTo);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimesheetHistoryDetails ", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchPermissionRegister)]
        public JsonResult<BtrakJsonResult> SearchPermissionRegister(PermissionRegisterSearchInputModel permissionRegisterSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "search permission register", "time sheet  Api"));
                LoggingManager.Info("EmployeeId :- " + permissionRegisterSearchInputModel.EmployeeId);

                BtrakJsonResult btrakJsonResult;

                List<PermissionRegisterReturnOutputModel> permissionRegisterReturnOutputModelList = _timeSheetService.SearchPermissionRegister(permissionRegisterSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "search permission register", "time sheet  Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "search permission register", "time sheet  Api"));
                return Json(new BtrakJsonResult { Data = permissionRegisterReturnOutputModelList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.SearchPermissionRegister)
                });

                return null;
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetLoggingCompliance)]
        public JsonResult<BtrakJsonResult> GetLoggingCompliance()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Logging Compliance", "Timesheet Api"));

                var validationMessages = new List<ValidationMessage>();
                
                BtrakJsonResult btrakJsonResult;

                LoggingComplainceOutputModel loggingComplianceDetails =
                    _timeSheetService.GetLoggingCompliance(LoggedInContext, validationMessages);

                List<StatusReportingConfigurationFormApiReturnModel> statusReportingConfigurationForms = _statusReportingService.GetStatusReportingConfigurationForms(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Logging Compliance", "Timesheet Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Logging Compliance", "Timesheet Api"));

                return Json(new BtrakJsonResult { Data = new {loggingComplianceDetails, statusReportingConfigurationForms}  , Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
               LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, " GetLoggingCompliance", " TimeSheetApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
           [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetTimeSheetSubmissionTypes)]
        public JsonResult<BtrakJsonResult> GetTimeSheetSubmissionTypes(string searchText)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetTimeSheetSubmissionTypes");
                List<TimeSheetSubmissionFrequencyOutputModel> timeSheetSubmissionFrequencies = _timeSheetService.GetTimeSheetSubmissionTypes(searchText,LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetSubmissionTypes", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetSubmissionTypes", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = timeSheetSubmissionFrequencies, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTimeSheetSubmission)]
        public JsonResult<BtrakJsonResult> UpsertTimeSheetSubmission(TimeSheetSubmissionUpsertInputModel timeSheetSubmissionUpsertInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeSheetSubmission", "weekdaySearchCriteriaInputModel", timeSheetSubmissionUpsertInputModel, "Master Data Management Api"));

                if (timeSheetSubmissionUpsertInputModel == null)
                {
                    timeSheetSubmissionUpsertInputModel = new TimeSheetSubmissionUpsertInputModel();
                }

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("UpsertTimeSheetSubmission");
                var timeSheetSubmissionId = _timeSheetService.UpsertTimeSheetSubmission(timeSheetSubmissionUpsertInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeSheetSubmission", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeSheetSubmission", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = timeSheetSubmissionId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEmployeeShiftWeekDays)]
        public JsonResult<BtrakJsonResult> GetEmployeeShiftWeekDays(TimeSheetSubmissionSearchInputModel timeSheetSubmissionSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeShiftWeekDays", "timeSheetSubmissionSearchInputModel", timeSheetSubmissionSearchInputModel, "Master Data Management Api"));

                if (timeSheetSubmissionSearchInputModel == null)
                {
                    timeSheetSubmissionSearchInputModel = new TimeSheetSubmissionSearchInputModel();
                }

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetEmployeeShiftWeekDays");
                List<TimeSheetSubmissionModel> weekDays = _timeSheetService.GetEmployeeShiftWeekTimeSheets(timeSheetSubmissionSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeShiftWeekDays", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeShiftWeekDays", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = weekDays, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTimeSheetSubmissions)]
        public JsonResult<BtrakJsonResult> GetTimeSheetSubmissions(TimeSheetSubmissionSearchInputModel timeSheetSubmissionSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                if (timeSheetSubmissionSearchInputModel == null)
                {
                    timeSheetSubmissionSearchInputModel = new TimeSheetSubmissionSearchInputModel();
                }

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetTimeSheetSubmissions");
                List<TimeSheetSubmissionSearchOutputModel> timeSheetSubmissions = _timeSheetService.GetTimeSheetSubmissions(timeSheetSubmissionSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetSubmissions", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetSubmissions", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = timeSheetSubmissions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTimeSheetInterval)]
        public JsonResult<BtrakJsonResult> UpsertTimeSheetInterval(TimeSheetSubmissionUpsertInputModel timeSheetIntervalUpsertInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeSheetInterval", "timeSheetIntervalUpsertInputModel", timeSheetIntervalUpsertInputModel, "Master Data Management Api"));

                if (timeSheetIntervalUpsertInputModel == null)
                {
                    timeSheetIntervalUpsertInputModel = new TimeSheetSubmissionUpsertInputModel();
                }

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("UpsertTimeSheetSubmission");
                var timeSheetSubmissionId = _timeSheetService.UpsertTimeSheetInterval(timeSheetIntervalUpsertInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeSheetSubmission", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeSheetSubmission", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = timeSheetSubmissionId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetTimeSheetInterval)]
        public JsonResult<BtrakJsonResult> GetTimeSheetInterval(TimeSheetSubmissionSearchInputModel timeSheetIntervalSearchInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                if (timeSheetIntervalSearchInputModel == null)
                {
                    timeSheetIntervalSearchInputModel = new TimeSheetSubmissionSearchInputModel();
                }

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetTimeSheetIntervals");
                List<TimeSheetSubmissionSearchOutputModel> timeSheetSubmissions = _timeSheetService.GetTimeSheetInterval(timeSheetIntervalSearchInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetIntervals", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetIntervals", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = timeSheetSubmissions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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
        [Route(RouteConstants.GetStatus)]
        public JsonResult<BtrakJsonResult> GetStatus()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
               
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetStatus");
                List<StatusOutputModel> statuses = _timeSheetService.GetStatus( LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatus", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStatus", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = statuses, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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
        [Route(RouteConstants.GetTimeSheetApproveLineManagers)]
        public JsonResult<BtrakJsonResult> GetTimeSheetApproveLineManagers()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetTimeSheetApproveLineManagers");
                List<TimeSheetApproveLineManagersOutputModel> lineManagers = _timeSheetService.GetTimeSheetApproveLineManagers(LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetApproveLineManagers", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetApproveLineManagers", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = lineManagers, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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
        [Route(RouteConstants.GetApproverUsers)]
        public JsonResult<BtrakJsonResult> GetApproverUsers()
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetTimeSheetApproveLineManagers");
                List<TimeSheetApproveLineManagersOutputModel> lineManagers = _timeSheetService.GetApproverUsers(LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetApproveLineManagers", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetTimeSheetApproveLineManagers", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = lineManagers, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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
        [Route(RouteConstants.GetEmployeeTimeSheetPunchCardDetails)]
        public JsonResult<BtrakJsonResult> GetEmployeeTimeSheetPunchCardDetails(string date,Guid? UserId)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetEmployeeTimeSheetPunchCardDetails");
                EmployeeTimeSheetPunchCardDetailsOutputModel punchCardDetails = _timeSheetService.GetEmployeeTimeSheetPunchCardDetails(date,UserId,LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeTimeSheetPunchCardDetails", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEmployeeTimeSheetPunchCardDetails", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = punchCardDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEmployeeTimeSheetPunchCard)]
        public JsonResult<BtrakJsonResult> UpsertEmployeeTimeSheetPunchCard(EmployeeTimeSheetPunchCardUpsertInputModel employeeTimeSheetPunchCardUpsertInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                if(employeeTimeSheetPunchCardUpsertInputModel == null)
                {
                    employeeTimeSheetPunchCardUpsertInputModel =new  EmployeeTimeSheetPunchCardUpsertInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("UpsertEmployeeTimeSheetPunchCard");
                employeeTimeSheetPunchCardUpsertInputModel.TimeSheetPunchCardId = _timeSheetService.UpsertEmployeeTimeSheetPunchCard(employeeTimeSheetPunchCardUpsertInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeTimeSheetPunchCard", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeTimeSheetPunchCard", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = employeeTimeSheetPunchCardUpsertInputModel.TimeSheetPunchCardId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertApproverEditTimeSheet)]
        public JsonResult<BtrakJsonResult> UpsertApproverEditTimeSheet(EmployeeTimeSheetPunchCardUpsertInputModel employeeTimeSheetPunchCardUpsertInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                if (employeeTimeSheetPunchCardUpsertInputModel == null)
                {
                    employeeTimeSheetPunchCardUpsertInputModel = new EmployeeTimeSheetPunchCardUpsertInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("UpsertEmployeeTimeSheetPunchCard");
                employeeTimeSheetPunchCardUpsertInputModel.TimeSheetPunchCardId = _timeSheetService.UpsertApproverEditTimeSheet(employeeTimeSheetPunchCardUpsertInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeTimeSheetPunchCard", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEmployeeTimeSheetPunchCard", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = employeeTimeSheetPunchCardUpsertInputModel.TimeSheetPunchCardId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateEmployeeTimeSheetPunchCard)]
        public JsonResult<BtrakJsonResult> UpdateEmployeeTimeSheetPunchCard(TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                if (timeSheetPunchCardUpDateInputModel == null)
                {
                    timeSheetPunchCardUpDateInputModel = new TimeSheetPunchCardUpDateInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("UpdateEmployeeTimeSheetPunchCard");
                bool? value = _timeSheetService.UpdateEmployeeTimeSheetPunchCard(timeSheetPunchCardUpDateInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateEmployeeTimeSheetPunchCard", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateEmployeeTimeSheetPunchCard", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = value, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetApproverTimeSheetSubmissions)]
        public JsonResult<BtrakJsonResult> GetApproverTimeSheetSubmissions(ApproverTimeSheetSubmissionsGetInputModel approverTimeSheetSubmissionsGetInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                if (approverTimeSheetSubmissionsGetInputModel == null)
                {
                    approverTimeSheetSubmissionsGetInputModel = new ApproverTimeSheetSubmissionsGetInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("GetApproverTimeSheetSubmissions");
               List< TimeSheetSubmissionModel > timeSheetSubmissions = _timeSheetService.GetApproverTimeSheetSubmissions(approverTimeSheetSubmissionsGetInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetApproverTimeSheetSubmissions", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetApproverTimeSheetSubmissions", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = timeSheetSubmissions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllLateUsers)]
        public JsonResult<BtrakJsonResult> GetAllLateUsers(ActivityKpiSearchModel activityKpiSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllLateUsers", "TimeSheet Api"));
                
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<TimeSheetModel> data = _timeSheetService.GetAllLateUsers(activityKpiSearchModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllLateUsers", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllLateUsers", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, " GetAllLateUsers", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllAbsenceUsers)]
        public JsonResult<BtrakJsonResult> GetAllAbsenceUsers(ActivityKpiSearchModel activityKpiSearchModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllAbsenceUsers", "TimeSheet Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<TimeSheetModel> data = _timeSheetService.GetAllAbsenceUsers(activityKpiSearchModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllAbsenceUsers", "TimeSheet Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllAbsenceUsers", "TimeSheet Api"));
                return Json(new BtrakJsonResult { Data = data, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, " GetAllAbsenceUsers", " TimeSheetApiController", exception.Message), exception);

                throw;
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertTimeSheetStatus)]
        public JsonResult<BtrakJsonResult> UpsertTimeSheetStatus(TimesheetStatusModel timesheetStatusModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeSheetStatus", "timesheetStatusModel", timesheetStatusModel, "Master Data Management Api"));

                if (timesheetStatusModel == null)
                {
                    timesheetStatusModel = new TimesheetStatusModel();
                }

                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("UpsertTimeSheetStatus");
                var StatusId = _timeSheetService.UpsertTimeSheetStatus(timesheetStatusModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeSheetStatus", "Master Data Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertTimeSheetStatus", "Master Data Management Api"));
                return Json(new BtrakJsonResult { Data = StatusId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
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

    }
}
