using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.File;
using Btrak.Services.CompanyStructure;
using Btrak.Services.FileUpload;
using Btrak.Services.FileUploadDownload;
using Btrak.Services.Recruitment;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;

namespace BTrak.Api.Controllers.Fil
{
    public class FileApiController : AuthTokenApiController
    {
        private readonly IFileService _fileService;
        private readonly IRecruitmentMasterDataService _recruitmentMasterDataService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IFileStoreService _fileStoreService;

        public FileApiController(IFileService fileService, CompanyStructureService companyStructureService, IRecruitmentMasterDataService recruitmentMasterDataService)
        {
            _fileService = fileService; ;
            _recruitmentMasterDataService = recruitmentMasterDataService;
            _companyStructureService = companyStructureService;
            _fileStoreService = new FileStoreService();
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DownloadFile)]
        public JsonResult<BtrakJsonResult> DownloadFile(string filePath)
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
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadFile", "File Api"));

                return Json(new BtrakJsonResult { Data = fileData, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadFile", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchFileHistory)]
        public JsonResult<BtrakJsonResult> SearchFileHistory(SearchFileHistoryInputModel searchFileHistoryInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFileHistory", "File Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                List<SearchFileHistoryOutputModel> filesHistory = _fileService.SearchFileHistory(searchFileHistoryInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchFileHistory", "File Api"));

                return Json(new BtrakJsonResult { Data = filesHistory, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFileHistory", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        //Document management
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertFolderDescription)]
        public JsonResult<BtrakJsonResult> UpsertFolderDescription(UpsertFolderInputModel upsertFolderInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFolderDescription", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? folderIdReturned = _fileService.UpsertFolderDescription(upsertFolderInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertFolderDescription", "File Api"));

                return Json(new BtrakJsonResult { Data = folderIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFolderDescription", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertFolder)]
        public JsonResult<BtrakJsonResult> UpsertFolder(UpsertFolderInputModel upsertFolderInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFolder", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? folderIdReturned = _fileService.UpsertFolder(upsertFolderInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertFolder", "File Api"));

                return Json(new BtrakJsonResult { Data = folderIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFolder", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertFileDetails)]
        public JsonResult<BtrakJsonResult> UpsertFileDetails(UpsertUploadFileInputModel upsertFolderInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFileDetails", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? folderIdReturned = _fileService.UpsertFileDetails(upsertFolderInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertFileDetails", "File Api"));

                return Json(new BtrakJsonResult { Data = folderIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFileDetails", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchFolder)]
        public JsonResult<BtrakJsonResult> SearchFolder(SearchFolderInputModel searchFolderInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFolder", "File Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                SearchFolderOutputModel folders = _fileService.SearchFolder(searchFolderInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchFolder", "File Api"));

                return Json(new BtrakJsonResult { Data = folders, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFolder", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadFile)]
        public async Task<JsonResult<BtrakJsonResult>> UploadFileAsync(int moduleTypeId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadFile", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var httpRequest = HttpContext.Current.Request;

                BtrakJsonResult btrakApiResult;

                List<FileResult> fileIdReturned = await _fileService.UploadFile(httpRequest, LoggedInContext, validationMessages, moduleTypeId);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadFile", "File Api"));

                return Json(new BtrakJsonResult { Data = fileIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFileAsync", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.UploadWHFile)]
        public async Task<JsonResult<BtrakJsonResult>> UploadWHFile(int moduleTypeId,Guid companyId, Guid userId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadWHFile", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var httpRequest = HttpContext.Current.Request;

                BtrakJsonResult btrakApiResult;
                LoggedInContext loggedInContext = new LoggedInContext();
                loggedInContext.CompanyGuid = companyId;
                loggedInContext.LoggedInUserId = userId;
                List<FileResult> fileIdReturned = await _fileService.UploadFile(httpRequest, loggedInContext, validationMessages, moduleTypeId);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadWHFile", "File Api"));

                return Json(new BtrakJsonResult { Data = fileIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadWHFile", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.UploadFileForRecruitment)]
        public async Task<object> UploadFileForRecruitment(int moduleTypeId,Guid jobOpeningId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadFileForRecruitment", "FileApiController"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var httpRequest = HttpContext.Current.Request;

                LoggedInContext loggedInContext = _recruitmentMasterDataService.GetLoggedInContextForCandidate(jobOpeningId, "", validationMessages);

                BtrakJsonResult btrakApiResult;

                List<FileResult> fileIdReturned = await _fileService.UploadFile(httpRequest, loggedInContext, validationMessages, moduleTypeId);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadFileForRecruitment", "FileApiController"));

                return Json(new BtrakJsonResult { Data = fileIdReturned[0], Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFileForRecruitment", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.UploadFileFromForms)]
        public async Task<object> UploadFileFromForms(int moduleTypeId, Guid referenceId, Guid loggedInUserId,Guid companyId, string baseUrl, string project, string form)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadFileFromForms", "FileApiController"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                var httpRequest = HttpContext.Current.Request;

                BtrakJsonResult btrakApiResult;
                LoggedInContext loggedInContext = new LoggedInContext();
                loggedInContext.CompanyGuid = companyId;
                loggedInContext.LoggedInUserId = loggedInUserId;
                List<FileResult> fileIdReturned = await _fileService.UploadFileFromForms(httpRequest, loggedInContext, validationMessages, moduleTypeId, referenceId);
                fileIdReturned[0].Url = fileIdReturned[0].FilePath;
                //fileIdReturned[0].Url = ConfigurationManager.AppSettings["SiteUrl"]+"/File/FileApi/UploadedFormDocuments?fileId=" + fileIdReturned[0].FileId + "&fileUrl=" + fileIdReturned[0].FilePath+ "&LoggedInUserId="+loggedInUserId;
                fileIdReturned[0].Name = fileIdReturned[0].FileName;
                fileIdReturned[0].Size = fileIdReturned[0].FileSize;

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadFileFromForms", "FileApiController"));

                return Json(new BtrakJsonResult { Data = fileIdReturned[0], Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFileFromForms", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        
        [HttpDelete]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.UploadedFormDocuments)]
        public async Task<object> UploadedFormDocuments(Guid fileId, Guid loggedInUserId,string fileUrl)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadFileFromForms", "FileApiController"));
                List<Guid?> fileIds = new List<Guid?>();
                fileIds.Add(fileId);

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                LoggedInContext loggedInContext = new LoggedInContext();
                loggedInContext.LoggedInUserId = loggedInUserId;
                List<FileApiReturnModel> fileModel = _fileService.GetFileDetailById(fileIds, loggedInContext, validationMessages);


                BtrakJsonResult btrakApiResult;
                DeleteFileInputModel deleteFileInputModel = new DeleteFileInputModel();
                deleteFileInputModel.FileId = fileId;
                deleteFileInputModel.TimeStamp = fileModel[0].TimeStamp;
                var fileIdReturned= _fileService.DeleteFile(deleteFileInputModel, loggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadFileFromForms", "FileApiController"));

                return Json(new BtrakJsonResult { Data = fileIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFileFromForms", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }



        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SaveFileBase64)]
        public JsonResult<BtrakJsonResult> SaveFile(FileDataForBase64 file)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadFileFromForms", "FileApiController"));
                
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;
                CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(LoggedInContext.CompanyGuid, LoggedInContext, validationMessages);
                var result = _fileStoreService.UploadFilesUsingBase64(companyModel, file, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UploadFileFromForms", "FileApiController"));

                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFileFromForms", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertMultipleFiles)]
        public JsonResult<BtrakJsonResult> UpsertMultipleFiles(FileUpsertInputModel fileUpsertInputModels)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertMultipleFiles", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                List<Guid?> fileIds = _fileService.UpsertMultipleFiles(fileUpsertInputModels, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages, Data = fileIds },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertFile", "File Api"));

                return Json(new BtrakJsonResult { Data = fileIds, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMultipleFiles", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchFile)]
        public JsonResult<BtrakJsonResult> SearchFile(FileSearchCriteriaInputModel fileSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFile", "File Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                List<FileApiReturnModel> files = _fileService.SearchFile(fileSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchFile", "File Api"));

                return Json(new BtrakJsonResult { Data = files, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFile", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetFileDetailById)]
        public JsonResult<BtrakJsonResult> GetFileDetailById(List<Guid?> fileIds)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFileDetailById", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                List<FileApiReturnModel> fileModel = _fileService.GetFileDetailById(fileIds, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFileDetailById", "File Api"));

                return Json(new BtrakJsonResult { Data = fileModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFileDetailById", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteFile)]
        public JsonResult<BtrakJsonResult> DeleteFile(DeleteFileInputModel deleteFileInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFile", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? fileModel = _fileService.DeleteFile(deleteFileInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteFile", "File Api"));

                return Json(new BtrakJsonResult { Data = fileModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFile", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteFileByReferenceId)]
        public JsonResult<BtrakJsonResult> DeleteFileByReferenceId(DeleteFileInputModel deleteFileInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFileByReferenceId", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? fileModel = _fileService.DeleteFileByReferenceId(deleteFileInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteFileByReferenceId", "File Api"));

                return Json(new BtrakJsonResult { Data = fileModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFileByReferenceId", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ReviewFile)]
        public JsonResult<BtrakJsonResult> ReviewFile(FileModel fileInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ReviewFile", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? fileModel = _fileService.ReviewFile(fileInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ReviewFile", "File Api"));

                return Json(new BtrakJsonResult { Data = fileModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReviewFile", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertFileName)]
        public JsonResult<BtrakJsonResult> UpsertFileName(FileModel fileInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFileName", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                Guid? fileModel = _fileService.UpsertFileName(fileInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertFileName", "File Api"));

                return Json(new BtrakJsonResult { Data = fileModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFileName", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetFolderDetailById)]
        public JsonResult<BtrakJsonResult> GetFolderDetailById(Guid folderId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFolderDetailById", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakApiResult;

                FolderApiReturnModel fileModel = _fileService.GetFolderDetailById(folderId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    if (btrakApiResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFolderDetailById", "File Api"));

                return Json(new BtrakJsonResult { Data = fileModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFolderDetailById", "FileApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetGenericFileDetails)]
        public HttpResponseMessage GetGenericFileDetails(Guid fileId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetGenericFileDetails", "File Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                WebHeaderCollection contentHeaders;

                byte[] filePath = _fileService.GetFileDetails(fileId, validationMessages,out contentHeaders);

                var res = Request.CreateResponse(HttpStatusCode.OK);
                res.Content = new ByteArrayContent(filePath);
                res.Content.Headers.Remove("Content-Type");
                res.Content.Headers.Add("Content-Type", contentHeaders["Content-Type"]);
                res.Headers.Remove("Cache-Control");
                res.Headers.Add("Cache-Control", contentHeaders["Cache-Control"]);

                return res;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGenericFileDetails", "FileApiController", exception.Message), exception);

                return null;
            }
        }

    }
}