using BTrak.Api.Controllers.Api;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.UserStory;
using Btrak.Services.UserStory;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.UserStory
{
    public class UserStoryPriorityApiController : AuthTokenApiController
    {
        private readonly IUserStoryPriorityService _userStoryPriorityService;

        public UserStoryPriorityApiController(IUserStoryPriorityService userStoryPriorityService)
        {
            _userStoryPriorityService = userStoryPriorityService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchUserStoryPriorities)]
        public JsonResult<BtrakJsonResult> SearchUserStoryPriorities(UserStoryPriorityInputModel userStoryPriorityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchUserStoryPriorities", "UserStoryPriority Api"));

                if (userStoryPriorityInputModel == null)
                {
                    userStoryPriorityInputModel = new UserStoryPriorityInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<UserStoryPriorityApiReturnModel> userStoryPriorities = _userStoryPriorityService.SearchUserStoryPriorities(userStoryPriorityInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchUserStoryPriorities", "UserStoryPriority Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchUserStoryPriorities", "UserStoryPriority Api"));

                return Json(new BtrakJsonResult { Data = userStoryPriorities, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchUserStoryPriorities", "UserStoryPriorityApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}