using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Services.Access;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Access
{
    public class AccessibilityApiController : AuthTokenApiController
    {
        private readonly IAccessibilityService _accessibilityService;

        public AccessibilityApiController(IAccessibilityService accessibilityService)
        {
            _accessibilityService = accessibilityService;
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.IsUserAccessibleToFeature)]
        public JsonResult<BtrakJsonResult> IsUserAccessibleToFeature(Guid userId, Guid featureId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "IsUserAccessibleToFeature", "AccessibilityApi"));
                LoggingManager.Info("with parameters userId : " +userId + " and featureId : " + featureId);
                var validationMessages = new List<ValidationMessage>();
               var isUserAccessible = _accessibilityService.GetIfUserAccessibleToFeature(userId, featureId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "IsUserAccessibleToFeature", "AccessibilityApi"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "IsUserAccessibleToFeature", "AccessibilityApi"));
                return Json(new BtrakJsonResult { Data = isUserAccessible, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "IsUserAccessibleToFeature", "AccessibilityApiController", exception.Message),exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
