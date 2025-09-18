using System;
using System.Collections.Generic;
using DocumentStorageService.Api.Helpers;
using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using Microsoft.AspNetCore.Mvc;
using DocumentStorageService.Services.FileStore;
using DocumentStorageService.Services.FormDataServices;

namespace DocumentStorageService.Api.Controllers
{
   
    [ApiController]
    public class FileApiController : AuthTokenApiController
    {
        private readonly IFileUploadService _fileService;
        private readonly IDataSetsService _dataSetService;
        public FileApiController(IFileUploadService fileService, IDataSetsService dataSetService)
        {
            _fileService = fileService;
            _dataSetService = dataSetService;
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CreateMultipleFiles)]
        public JsonResult CreateMultipleFiles(UpsertFileInputModel fileUpsertInputModels)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertMultipleFiles", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                List<Guid?> fileIds = _fileService.UpsertMultipleFiles(fileUpsertInputModels, LoggedInContext, validationMessages);
                
                if (fileUpsertInputModels.ReferenceTypeId != null && fileUpsertInputModels.ReferenceTypeName != null && fileUpsertInputModels.ReferenceTypeName != "")
                {
                    _dataSetService.SaveCreateFileHistory(fileUpsertInputModels, LoggedInContext, validationMessages);
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages, Data = fileIds }
                            );
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertFile", "File Api"));

                return Json(new BtrakJsonResult { Data = fileIds, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMultipleFiles", "FileApiContr++oller", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpDelete]
        [HttpOptions]
        [Route(RouteConstants.ArchiveFile)]
        public JsonResult ArchiveFile(Guid? fileId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFile", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? fileIds = _fileService.ArchiveFile(fileId, LoggedInContext, validationMessages);

                if (fileIds != null && validationMessages.Count == 0)
                {
                    var fileSearchCriteriaInputModel = new FileSearchCriteriaInputModel();
                    fileSearchCriteriaInputModel.FileId = fileId;
                    fileSearchCriteriaInputModel.PageNumber = 1;
                    fileSearchCriteriaInputModel.PageSize = 100;
                    fileSearchCriteriaInputModel.SortBy = null;
                    fileSearchCriteriaInputModel.SortDirectionAsc = true;
                    fileSearchCriteriaInputModel.IsArchived = true;

                    List<FileApiReturnModel> files = _fileService.SearchFile(fileSearchCriteriaInputModel, LoggedInContext, validationMessages);
                    if (files[0].ReferenceTypeId != null && files[0].ReferenceTypeName != null && files[0].ReferenceTypeName != "")
                    {
                        _dataSetService.SaveDeleteFileHistory(files[0], LoggedInContext, validationMessages);
                    }
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages, Data = fileIds });
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteFile", "File Api"));

                return Json(new BtrakJsonResult { Data = fileIds, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFile", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.SearchFiles)]
        public JsonResult SearchFiles(Guid? referenceId = null, Guid? referenceTypeId = null, string referenceTypeName = null, Guid? userStoryId = null, Guid? storeId = null, Guid? folderId = null, Guid? fileId = null, string searchText = null, int pageNumber = 1, int pageSize = 1000, string sortBy = null, bool sortDirectionAsc = true, string fileName = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFile", "File Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                var fileSearchCriteriaInputModel = new FileSearchCriteriaInputModel();
                fileSearchCriteriaInputModel.ReferenceTypeId = referenceTypeId;
                fileSearchCriteriaInputModel.ReferenceId = referenceId;
                fileSearchCriteriaInputModel.ReferenceTypeName = referenceTypeName;
                fileSearchCriteriaInputModel.FolderId = folderId;
                fileSearchCriteriaInputModel.StoreId = storeId;
                fileSearchCriteriaInputModel.FileId = fileId;
                fileSearchCriteriaInputModel.PageNumber = pageNumber;
                fileSearchCriteriaInputModel.PageSize = pageSize;
                fileSearchCriteriaInputModel.SearchText = searchText;
                fileSearchCriteriaInputModel.SortBy = sortBy;
                fileSearchCriteriaInputModel.SortDirectionAsc = sortDirectionAsc;
                fileSearchCriteriaInputModel.IsArchived = false;
                fileSearchCriteriaInputModel.UserStoryId = userStoryId;
                fileSearchCriteriaInputModel.FileName = fileName;

                List<FileApiReturnModel> files = _fileService.SearchFile(fileSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages });
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchFile", "File Api"));

                return Json(new BtrakJsonResult { Data = files, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFile", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPut]
        [HttpOptions]
        [Route(RouteConstants.UpdateFile)]
        public JsonResult UpdateFile(FileModel fileModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFileName", "File Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? fileId = _fileService.UpdateFile(fileModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages });
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchFile", "File Api"));

                return Json(new BtrakJsonResult { Data = fileId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFile", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPatch]
        [HttpOptions]
        [Route(RouteConstants.ReviewFile)]
        public JsonResult ReviewFile(FileModel fileModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReviewFile", "File Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? fileId = _fileService.ReviewFile(fileModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages });
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReviewFile", "File Api"));

                return Json(new BtrakJsonResult { Data = fileId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReviewFile", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [Route(RouteConstants.DownloadFile)]
        public JsonResult DownloadFile(string filePath)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadFile", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                byte[] fileData = _fileService.DownloadFile(filePath, LoggedInContext, validationMessages);

                BtrakJsonResult btrakApiResult;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages });
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadFile", "File Api"));

                return Json(new BtrakJsonResult { Data = fileData, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadFile", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ActivateAndArchiveFiles)]
        public JsonResult ActivateAndArchiveFiles(ActivateAndArchiveFileInputModel activateAndArchiveFile)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ActivateAndArchiveFiles", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? fileId = null;

                if(activateAndArchiveFile.ActivateFile.Count > 0 || activateAndArchiveFile.ArchiveFileIds.Count > 0)
                {
                    fileId = _fileService.ActivateAndArchiveFiles(activateAndArchiveFile, LoggedInContext, validationMessages);
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages, Data = fileId }
                            );
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ActivateAndArchiveFiles", "File Api"));

                return Json(new BtrakJsonResult { Data = fileId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ActivateAndArchiveFiles", "FileApiContr++oller", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }
    }
}
