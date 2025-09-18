using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Goals;
using Btrak.Services.Goals;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Goals
{
    public class GoalReplanApiController : AuthTokenApiController
    {
        private readonly IGoalReplanService _goalReplanService;

        public GoalReplanApiController(IGoalReplanService goalReplanService)
        {
            _goalReplanService = goalReplanService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertGoalReplan)]
        public JsonResult<BtrakJsonResult> InsertGoalReplan(GoalReplanUpsertInputModel goalReplanUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertGoalReplan", "GoalReplan Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? goalReplanId = _goalReplanService.InsertGoalReplan(goalReplanUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertGoalReplan", "GoalReplan Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertGoalReplan", "GoalReplan Api"));

                return Json(new BtrakJsonResult { Data = goalReplanId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertGoalReplan", "GoalReplanApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
