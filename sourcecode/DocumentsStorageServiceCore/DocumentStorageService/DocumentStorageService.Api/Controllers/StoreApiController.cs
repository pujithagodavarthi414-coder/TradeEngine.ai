using System;
using System.Collections.Generic;
using DocumentStorageService.Api.Helpers;
using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using DocumentStorageService.Services.FileStore;
using Microsoft.AspNetCore.Mvc;

namespace DocumentStorageService.Api.Controllers
{
    
    [ApiController]
    public class StoreApiController : AuthTokenApiController
    {
        private readonly IStoreService _storeService;
        public StoreApiController(IStoreService storeService)
        {
            _storeService = storeService;
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertStore)]
        public JsonResult UpsertStore(StoreInputModel upsertStoreInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertStore", "FileStore Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? folderIdReturned = _storeService.UpsertStore(upsertStoreInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }
                           );
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertStore", "FileStore Api"));

                return Json(new BtrakJsonResult { Data = folderIdReturned, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFolder", "FileStoreApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpDelete]
        [HttpOptions]
        [Route(RouteConstants.ArchiveStore)]
        public JsonResult ArchiveStore(Guid? storeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ArchiveStore", "Store Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? folderIdReturned = _storeService.ArchiveStore(storeId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }
                           );
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ArchiveStore", "Store Api"));

                return Json(new BtrakJsonResult { Data = folderIdReturned, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFolder", "FileStoreApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetStore)]
        public JsonResult GetStore(Guid? storeId = null, bool? isArchived = false)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStore", "Store Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                var storeSearchInputModel = new StoreCriteriaSearchInputModel();
                storeSearchInputModel.Id = storeId;
                storeSearchInputModel.IsArchived = false;
                storeSearchInputModel.CompanyId = LoggedInContext.CompanyGuid;

                List<StoreOutputReturnModels> storeReturnModels = _storeService.SearchStore(storeSearchInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }
                            );
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetStore", "Store Api"));

                return Json(new BtrakJsonResult { Data = storeReturnModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFolder", "FileStoreApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }
    }
}
