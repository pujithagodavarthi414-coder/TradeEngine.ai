using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.LeaveSessions;
using Btrak.Services.LeaveSessions;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.LeaveSessions
{
    public class LeaveSessionsApiController : AuthTokenApiController
    {
        private readonly ILeaveSessionsService _leaveSessionsService;

        public LeaveSessionsApiController(ILeaveSessionsService leaveSessionsService)
        {
            _leaveSessionsService = leaveSessionsService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertLeaveSession)]
        public JsonResult<BtrakJsonResult> UpsertLeaveSession(LeaveSessionsInputModel leaveSessionInput)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertLeaveSession", "leaveSessionInput", leaveSessionInput, "LeaveSessions Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? leaveTypeIdReturned = _leaveSessionsService.UpsertLeaveSession(leaveSessionInput, LoggedInContext, validationMessages);
                BtrakJsonResult btrakApiResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                                { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertLeaveSession Test Suite", "LeaveType Api"));
                return Json(new BtrakJsonResult { Data = leaveTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaveSession", "LeaveSessionsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllLeaveSessions)]
        public JsonResult<BtrakJsonResult> GetAllLeaveSessions(LeaveSessionsInputModel leaveSessionsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllLeaveSessions", "LeaveSessions Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var leaveSessions = _leaveSessionsService.GetAllLeaveSessions(leaveSessionsInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllLeaveSessions", "LeaveSessions Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllLeaveSessions", "LeaveSessions Api"));
                return Json(new BtrakJsonResult { Data = leaveSessions, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllLeaveSessions", "LeaveSessionsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetLeaveSessionsById)]
        public JsonResult<BtrakJsonResult> GetLeaveSessionsById(Guid? leaveSessionsId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLeaveSessionsById", "LeaveSessions Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var leaveTypeModel = _leaveSessionsService.GetLeaveSessionsById(leaveSessionsId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    if (btrakJsonResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                                { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLeaveSessionsById Test Suite", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = leaveTypeModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveSessionsById", "LeaveSessionsApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
