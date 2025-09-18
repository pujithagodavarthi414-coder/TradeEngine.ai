using Btrak.Services.Role;
using BTrak.Api.Controllers.Api;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.Role;
using BTrak.Api.Helpers;
using BTrak.Api.Models;

namespace BTrak.Api.Controllers.Roles
{
    public class RoleFeatureApiController : AuthTokenApiController
    {
        private readonly IRoleFeatureService _roleFeatureService;

        public RoleFeatureApiController(IRoleFeatureService roleFeatureService)
        {
            _roleFeatureService = roleFeatureService;
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAllPermittedRoleFeatures)]
        public JsonResult<BtrakJsonResult> GetAllPermittedRoleFeatures()
        {           
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPermittedRoleFeatures", "RoleFeature Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<RoleFeatureApiReturnModel> roleFeatures = _roleFeatureService.GetAllPermittedRoleFeatures(LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPermittedRoleFeatures", "RoleFeature Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPermittedRoleFeatures", "Goal Status Api"));

                return Json(new BtrakJsonResult { Data = roleFeatures, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllPermittedRoleFeatures ", " RoleFeatureApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchRoleFeatures)]
        public JsonResult<BtrakJsonResult> SearchRoleFeatures(Guid? roleId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchRoleFeatures", "RoleFeature Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<RoleFeatureApiReturnModel> roleFeatures = _roleFeatureService.SearchRoleFeatures(roleId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchRoleFeatures", "RoleFeature Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchRoleFeatures", "Goal Status Api"));

                return Json(new BtrakJsonResult { Data = roleFeatures, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchRoleFeatures ", " RoleFeatureApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
