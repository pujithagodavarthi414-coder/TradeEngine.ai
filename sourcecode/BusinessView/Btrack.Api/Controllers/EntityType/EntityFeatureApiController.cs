using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.EntityType;
using Btrak.Services.EntityType;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.EntityType
{
    public class EntityFeatureApiController : AuthTokenApiController
    {
        private readonly IEntityFeatureService _entityFeatureService;

        public EntityFeatureApiController(IEntityFeatureService entityFeatureService)
        {
            _entityFeatureService = entityFeatureService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllPermittedEntityFeatures)]
        public JsonResult<BtrakJsonResult> GetAllPermittedEntityFeatures(EntityFeatureSearchInputModel entityFeatureSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPermittedEntityFeatures", "EntityFeature Api"));

                if (entityFeatureSearchInputModel == null)
                {
                    entityFeatureSearchInputModel = new EntityFeatureSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EntityFeatureApiReturnModel> entityFeatureApiReturnModels = _entityFeatureService.GetAllPermittedEntityFeatures(entityFeatureSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPermittedEntityFeatures", "EntityFeature Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPermittedEntityFeatures", "EntityFeature Api"));

                return Json(new BtrakJsonResult { Data = entityFeatureApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllPermittedEntityFeatures", "EntityFeatureApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
