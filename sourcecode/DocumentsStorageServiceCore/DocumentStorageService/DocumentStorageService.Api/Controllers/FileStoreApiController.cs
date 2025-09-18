using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;
using DocumentStorageService.Services.FileStore;
using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using DocumentStorageService.Api.Helpers;

namespace DocumentStorageService.Api.Controllers
{
  
    [ApiController]
    public class FileStoreApiController : AuthTokenApiController
    {
        private readonly IFileService _fileService;
        public FileStoreApiController(IFileService fileService)
        {
            _fileService = fileService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateFolder)]
        public JsonResult CreateFolder(UpsertFolderInputModel upsertFolderInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFolder", "FileStore Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? folderIdReturned = _fileService.CreateFolder(upsertFolderInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages });
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertFolder", "FileStore Api"));

                return Json(new BtrakJsonResult { Data = folderIdReturned, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFolder", "FileStoreApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPut]
        [HttpOptions]
        [Route(RouteConstants.UpdateFolder)]
        public JsonResult UpdateFolder(UpsertFolderInputModel updateFolderInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFolder", "FileStore Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? folderIdReturned = _fileService.UpdateFolder(updateFolderInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages});
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertFolder", "FileStore Api"));

                return Json(new BtrakJsonResult { Data = folderIdReturned, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFolder", "FileStoreApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPatch]
        [HttpOptions]
        [Route(RouteConstants.UpdateFolderDescription)]
        public JsonResult UpdateFolderDescription(UpsertFolderInputModel updateFolderInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFolderDescription", "FileStore Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? folderIdReturned = _fileService.UpdateFolderDescription(updateFolderInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages });
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateFolderDescription", "FileStore Api"));

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
        [Route(RouteConstants.ArchiveFolder)]
        public JsonResult ArchiveFolder(Guid? folderId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFolder", "FileStore Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? folderIdReturned = _fileService.ArchiveFolder(folderId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages });
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteFolder", "FileStore Api"));

                return Json(new BtrakJsonResult { Data = folderIdReturned, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFolder", "FileStoreApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchFolder)]
        public JsonResult SearchFolder(Guid? folderReferenceId = null,
            Guid? folderReferenceTypeId = null, Guid? storeId = null, bool? isTreeView = false, Guid? folderId = null,
            Guid? parentFolderId = null, Guid? userStoryId = null, int pageNumber = 1, int pageSize = 10, string sortBy = "createdDatetime", string sortDirection = "asc")
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFolder", "FileStore Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                var searchFolderInputModel = new SearchFolderInputModel();
                searchFolderInputModel.FolderId = folderId;
                searchFolderInputModel.ParentFolderId = parentFolderId;
                searchFolderInputModel.FolderReferenceId = folderReferenceId;
                searchFolderInputModel.FolderReferenceTypeId = folderReferenceTypeId;
                searchFolderInputModel.StoreId = storeId;
                searchFolderInputModel.UserStoryId = userStoryId;
                searchFolderInputModel.IsTreeView = isTreeView;
                searchFolderInputModel.IsArchived = false;
                searchFolderInputModel.PageNumber = pageNumber;
                searchFolderInputModel.PageSize = pageSize;
                searchFolderInputModel.SortBy = sortBy;
                if (sortDirection == "asc")
                {
                    searchFolderInputModel.SortDirectionAsc = true;
                }
                else
                {
                    searchFolderInputModel.SortDirectionAsc = false;
                }

                SearchFolderOutputModel folders = _fileService.SearchFolder(searchFolderInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages });
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchFolder", "FileStore Api"));

                return Json(new BtrakJsonResult { Data = folders, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFolder", "FileStoreApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.FolderTreeView)]
        public JsonResult FolderTreeView(Guid? folderReferenceId = null,
            Guid? folderReferenceTypeId = null, Guid? storeId = null, bool? isTreeView = false, Guid? folderId = null,
            Guid? parentFolderId = null, Guid? userStoryId = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "FolderTreeView", "Store Management Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;
                var searchFolderInputModel = new SearchFolderInputModel();
                searchFolderInputModel.FolderId = folderId;
                searchFolderInputModel.ParentFolderId = parentFolderId;
                searchFolderInputModel.FolderReferenceId = folderReferenceId;
                searchFolderInputModel.FolderReferenceTypeId = folderReferenceTypeId;
                searchFolderInputModel.StoreId = storeId;
                searchFolderInputModel.UserStoryId = userStoryId;
                searchFolderInputModel.IsTreeView = isTreeView;
                searchFolderInputModel.IsArchived = false;

                string folderTreeView = _fileService.FolderTreeView(searchFolderInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "FolderTreeView", "Store Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "FolderTreeView", "Store Management Api"));
                return Json(new BtrakJsonResult { Data = folderTreeView, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "FolderTreeView", "StoreManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

    }
}
