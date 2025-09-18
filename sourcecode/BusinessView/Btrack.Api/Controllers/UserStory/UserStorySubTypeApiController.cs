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
    public class UserStorySubTypeApiController : AuthTokenApiController
    {
        private readonly IUserStorySubTypeService _userStorySubTypeService;

        public UserStorySubTypeApiController(IUserStorySubTypeService userStorySubTypeService)
        {
            _userStorySubTypeService = userStorySubTypeService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUserStorySubType)]
        public JsonResult<BtrakJsonResult> UpsertUserStorySubType(UserStorySubTypeUpsertInputModel userStorySubTypeUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertUserStorySubType", "UserStorySubType Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? userStorySubTypeIdReturned = _userStorySubTypeService.UpsertUserStorySubType(userStorySubTypeUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserStorySubType", "UserStorySubType Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserStorySubType", "UserStorySubType Api"));

                return Json(new BtrakJsonResult { Data = userStorySubTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStorySubType", "UserStorySubTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchUserStorySubTypes)]
        public JsonResult<BtrakJsonResult> SearchUserStorySubTypes(UserStorySubTypeSearchCriteriaInputModel userStorySubTypeSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchUserStorySubTypes", "UserStorySubType Api"));

                if (userStorySubTypeSearchCriteriaInputModel == null)
                {
                    userStorySubTypeSearchCriteriaInputModel = new UserStorySubTypeSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<UserStorySubTypeApiReturnModel> userStorySubTypes = _userStorySubTypeService.SearchUserStorySubTypes(userStorySubTypeSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchUserStorySubTypes", "UserStorySubType Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchUserStorySubTypes", "UserStorySubType Api"));

                return Json(new BtrakJsonResult { Data = userStorySubTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchUserStorySubTypes", "UserStorySubTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUserStorySubTypeById)]
        public JsonResult<BtrakJsonResult> GetUserStorySubTypeId(Guid? userStorySubTypeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStorySubTypeId", "UserStorySubType Api"));

                var validationMessages = new List<ValidationMessage>();

                UserStorySubTypeApiReturnModel userStorySubTypeApiReturnModel = _userStorySubTypeService.GetUserStorySubTypeById(userStorySubTypeId, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStorySubTypeId", "UserStorySubType Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStorySubTypeId", "UserStorySubType Api"));

                return Json(new BtrakJsonResult { Data = userStorySubTypeApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStorySubTypeId", "UserStorySubTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}