using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Goals;
using Btrak.Models.Sprints;
using Btrak.Models.UserStory;
using Btrak.Services.UserStory;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.UserStory
{
    public class UserStoryReplanApiController : AuthTokenApiController
    {
        private readonly IUserStoryReplanService _userStoryReplanService;

        public UserStoryReplanApiController(IUserStoryReplanService userStoryReplanService)
        {
            _userStoryReplanService = userStoryReplanService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertUserStoryReplan)]
        public JsonResult<BtrakJsonResult> InsertUserStoryReplan(UserStoryReplanUpsertInputModel userStoryReplanUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertUserStoryReplan", "UserStoryReplan Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? userStoryReplanId = _userStoryReplanService.InsertUserStoryReplan(userStoryReplanUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertUserStoryReplan", "UserStoryReplan Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertUserStoryReplan", "UserStoryReplan Api"));

                return Json(new BtrakJsonResult { Data = userStoryReplanId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertUserStoryReplan", "UserStoryReplanApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GoalReplanHistory)]
        public JsonResult<BtrakJsonResult> GoalReplanHistory(GoalSearchCriteriaInputModel goalSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GoalReplanHistory", "UserStoryReplan Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<GoalReplanHistoryApiReturnModel> goalReplanHistory = _userStoryReplanService.GoalReplanHistory(goalSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GoalReplanHistory", "UserStoryReplan Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GoalReplanHistory", "UserStoryReplan Api"));

                return Json(new BtrakJsonResult { Data = goalReplanHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                              LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GoalReplanHistory", "UserStoryReplanApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

       
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUserStoryReplan)]
        public JsonResult<BtrakJsonResult> UpsertUserStoryReplan(UserStoryReplanInputModel userStoryReplanInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertUserStoryReplan", "UserStoryReplan Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<Guid?> userStoryReplanId = _userStoryReplanService.UpsertUserStoryReplan(userStoryReplanInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserStoryReplan", "UserStoryReplan Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserStoryReplan", "UserStoryReplan Api"));

                return Json(new BtrakJsonResult { Data = userStoryReplanId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryReplan", "UserStoryReplanApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetGoalReplanHistory)]
        public JsonResult<BtrakJsonResult> GetGoalReplanHistory(Guid? goalId,int? goalReplanValue)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGoalReplanHistory", "UserStoryReplan Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<GoalReplanHistoryOutputModel> goalReplanHistory = _userStoryReplanService.GetGoalReplanHistory(goalId, goalReplanValue, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGoalReplanHistory", "UserStoryReplan Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetGoalReplanHistory", "UserStoryReplan Api"));

                return Json(new BtrakJsonResult { Data = goalReplanHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalReplanHistory", "UserStoryReplanApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetSprintReplanHistory)]
        public JsonResult<BtrakJsonResult> GetSprintReplanHistory(Guid? sprintId, int? goalReplanValue)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSprintReplanHistory", "UserStoryReplan Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<GoalReplanHistoryOutputModel> goalReplanHistory = _userStoryReplanService.GetSprintReplanHistory(sprintId, goalReplanValue, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSprintReplanHistory", "UserStoryReplan Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSprintReplanHistory", "UserStoryReplan Api"));

                return Json(new BtrakJsonResult { Data = goalReplanHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSprintReplanHistory", "UserStoryReplanApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
