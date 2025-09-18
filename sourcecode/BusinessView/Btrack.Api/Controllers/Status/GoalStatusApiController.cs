using Btrak.Services.Status;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Status;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Api.Controllers.Api;

namespace BTrak.Api.Controllers.Status
{
    public class GoalStatusApiController : AuthTokenApiController
    {
        private readonly IGoalStatusService _goalStatusService;

        public GoalStatusApiController(IGoalStatusService goalStatusService)
        {
            _goalStatusService = goalStatusService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllGoalStatuses)]
        public JsonResult<BtrakJsonResult> GetAllGoalStatuses(GoalStatusInputModel goalStatusInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllGoalStatuses", "Goal Status Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<GoalStatusApiReturnModel> goalStatuses = _goalStatusService.GetAllGoalStatuses(goalStatusInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllGoalStatuses", "Goal Status Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllGoalStatuses", "Goal Status Api"));

                return Json(new BtrakJsonResult { Data = goalStatuses, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllGoalStatuses", "GoalStatusApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
