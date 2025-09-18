using Btrak.Services.Status;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Status;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using BTrak.Api.Controllers.Api;

namespace BTrak.Api.Controllers.Status
{
    public class BugPriorityApiController : AuthTokenApiController
    {
        private readonly IBugPriorityService _bugPriorityService;

        public BugPriorityApiController(IBugPriorityService bugPriorityService)
        {
            _bugPriorityService = bugPriorityService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllBugPriorities)]
        public JsonResult<BtrakJsonResult> GetAllBugPriorities(BugPriorityInputModel bugPriorityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllBugPriorities", "BugPriority Api"));

                if (bugPriorityInputModel == null)
                {
                    bugPriorityInputModel= new BugPriorityInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<BugPriorityApiReturnModel> bugPriorities = _bugPriorityService.GetAllBugPriorities(bugPriorityInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllBugPriorities", "BugPriority Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllBugPriorities", "BugPriority Api"));

                return Json(new BtrakJsonResult { Data = bugPriorities, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllBugPriorities", "BugPriorityApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertBugPriority)]
        public JsonResult<BtrakJsonResult> UpsertBugPriority(UpsertBugPriorityInputModel upsertBugPriorityInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Bug Priority", "upsertBugPriorityInputModel", upsertBugPriorityInputModel, "BugPriority Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? bugPriorityIdReturned = _bugPriorityService.UpsertBugPriority(upsertBugPriorityInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Bug Priority", "BugPriority Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Bug Priority", "BugPriority Api"));
                return Json(new BtrakJsonResult { Data = bugPriorityIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBugPriority", "BugPriorityApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
