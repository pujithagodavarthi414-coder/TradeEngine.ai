using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Services.MasterData;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.MasterData
{
    public class LeaveStatusApiController : AuthTokenApiController
    {
        private readonly LeaveStatusService _leaveStatusService;

        public LeaveStatusApiController(LeaveStatusService leaveStatusService)
        {
            _leaveStatusService = leaveStatusService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertLeaveStatus)]
        public JsonResult<BtrakJsonResult> UpsertLeaveStatus(LeaveStatusUpsertModel leaveStatusUpsertModel)
        {
            BtrakJsonResult btrakJsonResult;
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Leave  status", "leaveStatusUpsertModel", leaveStatusUpsertModel, "Leave  status MasterData Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? leaveStatusIdReturned = _leaveStatusService.UpsertLeaveStatus(leaveStatusUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Leave  status", "Leave  status MasterData Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Leave  status", "Leave  status MasterData Api"));

                return Json(new BtrakJsonResult { Data = leaveStatusIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaveStatus", "LeaveStatusApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}