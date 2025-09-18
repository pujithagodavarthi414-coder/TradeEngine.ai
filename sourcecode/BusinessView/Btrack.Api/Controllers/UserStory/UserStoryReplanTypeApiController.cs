using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Status;
using Btrak.Models.UserStory;
using Btrak.Services.UserStory;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using BTrak.Api.Controllers.Api;
using Btrak.Models.MasterData;

namespace BTrak.Api.Controllers.UserStory
{
    public class UserStoryReplanTypeApiController : AuthTokenApiController
    {
        private readonly IUserStoryReplanTypeService _userStoryReplanTypeService;

        public UserStoryReplanTypeApiController(IUserStoryReplanTypeService userStoryReplanTypeService)
        {
            _userStoryReplanTypeService = userStoryReplanTypeService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserStoryReplanTypes)]
        public JsonResult<BtrakJsonResult> GetUserStoryReplanTypes(UserStoryReplanTypeSearchCriteriaInputModel userStoryReplanTypeSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllBugPriorities", "User Story Replan Type Api"));

                if (userStoryReplanTypeSearchCriteriaInputModel == null)
                {
                    userStoryReplanTypeSearchCriteriaInputModel = new UserStoryReplanTypeSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<UserStoryReplanTypeOutputModel> userStoryReplanTypes = _userStoryReplanTypeService.GetUserStoryReplanTypes(userStoryReplanTypeSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryReplanTypes", "User Story Replan Type Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryReplanTypes", "User Story Replan Type Api"));

                return Json(new BtrakJsonResult { Data = userStoryReplanTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryReplanTypes", "UserStoryReplanTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUserStoryReplanType)]
        public JsonResult<BtrakJsonResult> UpsertUserStoryReplanType(UpsertUserStoryReplanTypeInputModel upsertUserStoryReplanTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert UserStory Replan Type", "upsertUserStoryReplanTypeInputModel", upsertUserStoryReplanTypeInputModel, "User Story Replan Type Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? userStoryReplanTypeIdReturned = _userStoryReplanTypeService.UpsertUserStoryReplanType(upsertUserStoryReplanTypeInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert User Story Replan Type", "User Story Replan Type Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert User Story Replan Type", "User Story Replan Type Api"));
                return Json(new BtrakJsonResult { Data = userStoryReplanTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryReplanType", "UserStoryReplanTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUserStoryType)]
        public JsonResult<BtrakJsonResult> UpsertUserStoryType(UpsertUserStoryTypeInputModel upsertUserStoryTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert UserStory Type", "upsertUserStoryTypeInputModel", upsertUserStoryTypeInputModel, "User Story Replan Type Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? userStoryTypeIdReturned = _userStoryReplanTypeService.UpsertUserStoryType(upsertUserStoryTypeInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert User Story Type", "User Story Type Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert User Story Type", "User Story Type Api"));
                return Json(new BtrakJsonResult { Data = userStoryTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryType", "UserStoryReplanTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserStoryTypes)]
        public JsonResult<BtrakJsonResult> GetUserStoryTypes(UserStoryTypeSearchInputModel userStoryTypeSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllBugPriorities", "User Story Replan Type Api"));

                if (userStoryTypeSearchCriteriaInputModel == null)
                {
                    userStoryTypeSearchCriteriaInputModel = new UserStoryTypeSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<UserStoryTypeSearchInputModel> userStoryReplanTypes = _userStoryReplanTypeService.GetUserStoryTypes(userStoryTypeSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryReplanTypes", "User Story Replan Type Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryReplanTypes", "User Story Replan Type Api"));

                return Json(new BtrakJsonResult { Data = userStoryReplanTypes, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryTypes", "UserStoryReplanTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteUserStoryType)]
        public JsonResult<BtrakJsonResult> DeleteUserStoryType(UpsertUserStoryTypeInputModel upsertUserStoryTypeInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete UserStory Type", "upsertUserStoryTypeInputModel", upsertUserStoryTypeInputModel, "User Story Replan Type Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? userStoryTypeIdReturned = _userStoryReplanTypeService.DeleteUserStoryType(upsertUserStoryTypeInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete UserStory Type", "User Story Type Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete UserStory Type", "User Story Type Api"));
                return Json(new BtrakJsonResult { Data = userStoryTypeIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteUserStoryTypes", "UserStoryReplanTypeApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
