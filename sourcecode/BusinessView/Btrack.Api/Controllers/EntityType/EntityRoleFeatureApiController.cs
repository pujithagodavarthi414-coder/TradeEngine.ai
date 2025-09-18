using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.EntityRole;
using Btrak.Models.EntityType;
using Btrak.Models.Role;
using Btrak.Services.EntityType;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.EntityType
{
    public class EntityRoleFeatureApiController : AuthTokenApiController
    {
        private readonly IEntityRoleFeatureService _entityRoleFeatureService;

        public EntityRoleFeatureApiController(IEntityRoleFeatureService entityRoleFeatureService)
        {
            _entityRoleFeatureService = entityRoleFeatureService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEntityRoleFeature)]
        public JsonResult<BtrakJsonResult> UpsertEntityRoleFeature(EntityRoleFeatureUpsertInputModel entityRoleFeatureUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertEntityRoleFeature", "EntityRoleFeature Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                Guid? entityRoleFeatureIdReturned = _entityRoleFeatureService.UpsertEntityRoleFeature(entityRoleFeatureUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEntityRoleFeature", "EntityTypeRoleFeature Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertEntityRoleFeature", "EntityTypeRoleFeature Api"));

                return Json(new BtrakJsonResult { Data = entityRoleFeatureIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEntityRoleFeature", "EntityRoleFeatureApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllPermittedEntityRoleFeatures)]
        public JsonResult<BtrakJsonResult> GetAllPermittedEntityRoleFeatures(EntityRoleFeatureSearchInputModel entityRoleFeatureSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllPermittedEntityTypeRoleFeatures", "EntityTypeRoleFeature Api"));

                if (entityRoleFeatureSearchInputModel == null)
                {
                    entityRoleFeatureSearchInputModel = new EntityRoleFeatureSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EntityRoleFeatureApiReturnModel> entityRoleFeatureApiReturnModels = _entityRoleFeatureService.GetAllPermittedEntityRoleFeatures(entityRoleFeatureSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPermittedEntityTypeRoleFeatures", "EntityTypeRoleFeature Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllPermittedEntityTypeRoleFeatures", "EntityTypeRoleFeature Api"));

                return Json(new BtrakJsonResult { Data = entityRoleFeatureApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllPermittedEntityRoleFeatures", "EntityRoleFeatureApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllEntityRoleFeaturesByUserId)]
        public JsonResult<BtrakJsonResult> GetAllEntityRoleFeaturesByUserId(EntityRoleFeatureSearchInputModel entityRoleFeatureSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllEntityRoleFeaturesByUserId", "EntityTypeRoleFeature Api"));

                if (entityRoleFeatureSearchInputModel == null)
                {
                    entityRoleFeatureSearchInputModel = new EntityRoleFeatureSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EntityRoleFeatureApiReturnModel> entityRoleFeatureApiReturnModels = _entityRoleFeatureService.GetAllEntityRoleFeaturesByUserId(entityRoleFeatureSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllEntityRoleFeaturesByUserId", "EntityTypeRoleFeature Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllEntityRoleFeaturesByUserId", "EntityTypeRoleFeature Api"));

                return Json(new BtrakJsonResult { Data = entityRoleFeatureApiReturnModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllEntityRoleFeaturesByUserId", "EntityRoleFeatureApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEntityRolesWithFeatures)]
        public JsonResult<BtrakJsonResult> GetEntityRolesWithFeatures(EntityRoleFeatureSearchInputModel entityRoleFeatureSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEntityRolesWithFeatures", "EntityTypeRoleFeature Api"));

                if (entityRoleFeatureSearchInputModel == null)
                {
                    entityRoleFeatureSearchInputModel = new EntityRoleFeatureSearchInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                List<EntityRolesWithFeaturesApiReturnModel> entityRoleFeatures = _entityRoleFeatureService.GetEntityRolesWithFeatures(entityRoleFeatureSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEntityRolesWithFeatures", "EntityTypeRoleFeature Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEntityRolesWithFeatures", "EntityTypeRoleFeature Api"));

                return Json(new BtrakJsonResult { Data = entityRoleFeatures, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEntityRolesWithFeatures", "EntityRoleFeatureApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetEntityRolesByEntityFeatureId)]
        public JsonResult<BtrakJsonResult> GetEntityRolesByEntityFeatureId(Guid? entityFeatureId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEntityRolesByEntityFeatureId", "entityFeatureId", entityFeatureId, "EntityTypeRoleFeature Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<EntityRoleFeatureOutputModel> EntityRoleFeatureOutputModel = _entityRoleFeatureService.GetEntityRolesByEntityFeatureId(entityFeatureId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEntityRolesByEntityFeatureId", "EntityTypeRoleFeature Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetEntityRolesByEntityFeatureId", "EntityTypeRoleFeature Api"));
                return Json(new BtrakJsonResult { Data = EntityRoleFeatureOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEntityRolesByEntityFeatureId", "EntityRoleFeatureApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }

        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateEntityRoleFeature)]
        public JsonResult<BtrakJsonResult> UpdateEntityRoleFeature(UpdateEntityFeature updateEntityFeature)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateEntityRoleFeature", "updateEntityFeature", updateEntityFeature, "Role Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? roleFeatureId = _entityRoleFeatureService.UpdateEntityRoleFeature(updateEntityFeature, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateEntityRoleFeature", "EntityTypeRoleFeature Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateEntityRoleFeature", "EntityTypeRoleFeature Api"));
                return Json(new BtrakJsonResult { Data = roleFeatureId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateEntityRoleFeature", "EntityRoleFeatureApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
