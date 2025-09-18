using Btrak.Models;
using Btrak.Models.UserStory;
using Btrak.Services.UserStory;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.UserStory
{
    public class UserStoryLinkApiController : AuthTokenApiController
    {
       private readonly IUserStoryLinkService _userStoryLinkService;

        public UserStoryLinkApiController(IUserStoryLinkService userStoryLinkService)
        {
            _userStoryLinkService = userStoryLinkService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserStoryLinkTypes)]
        public JsonResult<BtrakJsonResult> GetUserStoryLinkTypes(UserStoryLinkTypesSearchCriteriaInputModel userStoryLinkTypesSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserStoryLinkTypes", "user story link Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<UserStoryLinkTypeOutputModel> userStoryTypeList = _userStoryLinkService.GetUserStoryLinkTypes(userStoryLinkTypesSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryLinkTypes", "user story link Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserStoryLinkTypes ", "user story link Api"));
                return Json(new BtrakJsonResult { Data = userStoryTypeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryLinkTypes", " UserStoryLinkApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUserStoryLinks)]
        public JsonResult<BtrakJsonResult> GetUserStoriesLinks(UserStoryLinksSearchCriteriaModel userStoryLinkSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get UserStories Links", "user story link Api"));

                if (userStoryLinkSearchCriteriaInputModel == null)
                {
                    userStoryLinkSearchCriteriaInputModel = new UserStoryLinksSearchCriteriaModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<UserStoryLinksOutputModel> userStories = _userStoryLinkService.SearchUserStoriesLinks(userStoryLinkSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get UserStories Links", "user story link Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get UserStories Links", "user story link Api"));

                return Json(new BtrakJsonResult { Data = userStories, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoriesLinks", " UserStoryLinkApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUserStoryLink)]
        public JsonResult<BtrakJsonResult> UpsertUserStoryLink(UserStoryLinkUpsertModel userStoryLinkUpsertModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertUserStoryLink", "UserStoryLink Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? userStoryIdReturned = _userStoryLinkService.UpsertUserStoryLink(userStoryLinkUpsertModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserStoryLink", "UserStoryLink Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserStoryLink", "UserStoryLink Api"));

                return Json(new BtrakJsonResult { Data = userStoryIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryLink", " UserStoryLinkApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ArchiveUserStoryLink)]
        public JsonResult<BtrakJsonResult> ArchiveUserStoryLink(ArchivedUserStoryLinkInputModel archivedUserStoryLinkInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ArchiveUserStoryLink", "UserStoryLink Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? userStoryIdReturned = _userStoryLinkService.ArchiveUserStoryLink(archivedUserStoryLinkInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveUserStoryLink", "UserStoryLink Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveUserStoryLink", "UserStoryLink Api"));

                return Json(new BtrakJsonResult { Data = userStoryIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ArchiveUserStoryLink", " UserStoryLinkApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

         [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetLinksCountForUserStory)]
        public JsonResult<BtrakJsonResult> GetLinksCountForUserStory(Guid? userStoryId, bool? isSprintUserStories)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetLinksCountForUserStory", "userStoryId", userStoryId, "User Story Link Api"));
                BtrakJsonResult btrakJsonResult;
                int? LinkCount = _userStoryLinkService.GetLinksCountForUserStory(userStoryId, isSprintUserStories,LoggedInContext, validationMessages);
                LoggingManager.Info("GetLinksCountForUserStory " + LinkCount + ", source command is " + userStoryId);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLinksCountForUserStory", "User Story Link Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLinksCountForUserStory", "User Story Link Api"));
                return Json(new BtrakJsonResult { Data = LinkCount, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(exception.Message, ValidationMessages.ExceptionGetBugsCountForUserStory)
                });

                return null;
            }
        }
    }
}
