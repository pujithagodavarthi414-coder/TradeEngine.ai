using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.EntityRole;
using Btrak.Services.EntityRole;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.EntityRole
{
    public class EntityRoleApiController : AuthTokenApiController
    {
        private readonly IEntityRoleService _entityRoleService;

        public EntityRoleApiController(IEntityRoleService entityRoleService)
        {
            _entityRoleService = entityRoleService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteEntityRole)]
        public JsonResult<BtrakJsonResult> DeleteEntityRole(EntityRoleInputModel entityRoleInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Delete Entity Role", "entityRoleInputModel", entityRoleInputModel, "EntityRole Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? entityRoleIdReturned = _entityRoleService.DeleteEntityRole(entityRoleInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out var btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Entity Role", "EntityRole Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Delete Entity Role", "EntityRole Api"));

                return Json(new BtrakJsonResult { Data = entityRoleIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteEntityRole", "EntityRoleApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertEntityRole)]
        public JsonResult<BtrakJsonResult> UpsertEntityRole(EntityRoleInputModel entityRoleInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Entity Role", "entityRoleInputModel", entityRoleInputModel, "EntityRole Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                Guid? entityRoleIdReturned = _entityRoleService.UpsertEntityRole(entityRoleInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Entity Role", "EntityRole Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Entity Role", "EntityRole Api"));
                return Json(new BtrakJsonResult { Data = entityRoleIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEntityRole", "EntityRoleApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetEntityRole)]
        public JsonResult<BtrakJsonResult> GetEntityRole(EntityRoleSearchCriteriaInputModel entityRoleSearchCriteriaInputModel)
        {
            var validationMessages = new List<ValidationMessage>();
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get EntityRole", "entityRoleSearchCriteriaInputModel", entityRoleSearchCriteriaInputModel, "Entity Role Api"));
                if (entityRoleSearchCriteriaInputModel == null)
                {
                    entityRoleSearchCriteriaInputModel = new EntityRoleSearchCriteriaInputModel();
                }
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Getting entityRole list");
                List<EntityRoleOutputModel> entityRoleList = _entityRoleService.GetEntityRole(entityRoleSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get EntityRole", "Entity Role Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get EntityRole", "Entity Role Api"));
                return Json(new BtrakJsonResult { Data = entityRoleList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (SqlException sqlEx)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(sqlEx.Message, ValidationMessages.GetEntityRole)
                });

                return null;
            }
        }
    }
}
