using System;
using System.Collections.Generic;
using DocumentStorageService.Api.Helpers;
using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.AccessRights;
using DocumentStorageService.Repositories.AccessRights;
using DocumentStorageService.Services.AccessRights;
using Microsoft.AspNetCore.Mvc;

namespace DocumentStorageService.Api.Controllers
{

    [ApiController]
    public class AccessRightsApiController : AuthTokenApiController
    {
        private readonly IAccessService _accessService;

        public AccessRightsApiController(IAccessService accessService)
        {
            _accessService = accessService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertAccessRightPermissionForDocuments)]
        public JsonResult InsertAccessRightPermissionForDocuments(DocumentRightAccessModel accessRightsPermissionModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,
                    "InsertAccessRightPermissionForDocuments", "Access rights Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                List<Guid?> documentId = _accessService.InsertAccessRightsPrmissionToDocuments(accessRightsPermissionModel,
                    LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            {
                                Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages,
                                Data = documentId
                            }
                        );
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue,
                    "InsertAccessRightPermissionForDocuments", "Access rights Api"));

                return Json(new BtrakJsonResult {Data = documentId, Success = true});
            }
            catch (Exception exception)
            {
                LoggingManager.Error(
                    string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue,
                        "InsertAccessRightPermissionForDocuments", "Access rights Api", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAccessRightPermissionsForDocuments)]
        public JsonResult GetAccessRightPermissionForDocuments(Guid? documentId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,
                    "GetAccessRightPermissionForDocuments", "Access rights Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                var accessRightsSearchInputModel = new AccessRightsSearchInputModel();
                accessRightsSearchInputModel.DocumentId = documentId;
                
                List<AccessRightsReturnModel> documentRightAccessModels = _accessService.SearchAccessRightPermissionsForDocuments(accessRightsSearchInputModel,
                    LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            {
                                Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages,
                                Data = documentRightAccessModels
                            }
                        );
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue,
                    "GetAccessRightPermissionForDocuments", "Access rights Api"));

                return Json(new BtrakJsonResult {Data = documentRightAccessModels, Success = true});
            }
            catch (Exception exception)
            {
                LoggingManager.Error(
                    string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue,
                        "GetAccessRightPermissionForDocuments", "Access rights Api", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }
    }
}