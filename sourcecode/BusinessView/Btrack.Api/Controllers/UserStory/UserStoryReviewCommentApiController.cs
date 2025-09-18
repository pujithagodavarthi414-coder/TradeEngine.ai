using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.UserStory;
using Btrak.Services.UserStory;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.UserStory
{
    public class UserStoryReviewCommentApiController : AuthTokenApiController
    {
        private readonly IUserStoryReviewCommentService _userStoryReviewCommentService;

        public UserStoryReviewCommentApiController(IUserStoryReviewCommentService userStoryReviewCommentService)
        {
            _userStoryReviewCommentService = userStoryReviewCommentService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUserStoryReviewComment)]
        public JsonResult<BtrakJsonResult> UpsertUserStoryReviewComment(UserStoryReviewCommentUpsertInputModel userStoryReviewCommentUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertUserStoryReviewComment", "UserStoryReviewComment Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? userStoryReviewCommentIdReturned = _userStoryReviewCommentService.UpsertUserStoryReviewComment(userStoryReviewCommentUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserStoryReviewComment", "UserStoryReviewComment Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserStoryReviewComment", "UserStoryReviewComment Api"));

                return Json(new BtrakJsonResult { Data = userStoryReviewCommentIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryReviewComment", "UserStoryReviewCommentApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}