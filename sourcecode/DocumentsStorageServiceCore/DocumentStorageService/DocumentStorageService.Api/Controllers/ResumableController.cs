using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using DocumentStorageService.Services.FileStore;
using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using System.Text;
using Microsoft.AspNetCore.Http;
using DocumentStorageService.Models.FileStore;

namespace DocumentStorageService.Api.Controllers
{

    [ApiController]
    public class ResumableController : AuthTokenApiController
    {
        private readonly IFileService _fileService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IFileUploadService _fileUploadService;
        public ResumableController(IFileService fileService, IHttpContextAccessor httpContextAccessor)
        {
            _fileService = fileService;
            _httpContextAccessor = httpContextAccessor;
        }

        [HttpPost]
        [Route(RouteConstants.UploadFileChunks)]
        public async Task<JsonResult> UploadFileChunks(int chunkNumber, int moduleTypeId, string fileName,
            string contentType, Guid? parentDocumentId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadFileChunks",
                "File Api"));

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();
            var files = HttpContext.Request.Form.Files;
            if (files.Count > 0)
            {
                foreach (var file in files)
                {
                    try
                    {

                        await _fileService.UploadFilesChunk(file, chunkNumber, moduleTypeId, fileName, contentType, parentDocumentId,
                            LoggedInContext, _httpContextAccessor, validationMessages);
                    }
                    catch (Exception exception)
                    {
                        LoggingManager.Error(
                            string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFileChunks",
                                "FileApiController", exception.Message), exception);
                        return Json(new BtrakJsonResult()
                        { Data = "UploadFileChunks Exception -" + exception.Message + "", Success = false });
                    }
                }
            }
            else
                return Json(new BtrakJsonResult { Data = "no files found", Success = false });

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue,
                "UploadFileChunks", "FileApiController"));
            return Json(new BtrakJsonResult { Data = true, Success = true });
        }

        [HttpPost]
        [Route(RouteConstants.GetChunkBlobUrl)]
        public JsonResult GetChunkBlobUrl(string fileName, int moduleTypeId, string list, string contentType, Guid? parentDocumentId)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetChunkBlobUrl",
                "File Api"));

            string filePath = string.Empty;
            try
            {
                var ids = list
                    .Split(',')
                    .Where(id => !string.IsNullOrWhiteSpace(id))
                    .Select(id => Convert.ToBase64String(Encoding.UTF8.GetBytes(int.Parse(id).ToString("d6"))))
                    .ToArray();
                filePath = _fileService.GetChunkBlobUrl(fileName, moduleTypeId, ids, contentType, parentDocumentId, LoggedInContext, _httpContextAccessor);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(
                    string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetChunkBlobUrl",
                        "FileApiController", ex.Message), ex);
                return Json(new BtrakJsonResult() { Data = ex.Message, Success = false });
            }

            return Json(new BtrakJsonResult { Data = filePath, Success = true });
        }

        [HttpPost]
        [Route(RouteConstants.UploadLocalFileToBlob)]
        public JsonResult UploadLocalFileToBlob(UploadFileToBlobInputModel uploadFileToBlobInputModel)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UploadLocalFileToBlob",
                "File Api"));
            string filePath;
            try
            {
                filePath = _fileService.UploadLocalFileToBlob(uploadFileToBlobInputModel, LoggedInContext, _httpContextAccessor);
            }
            catch (Exception ex)
            {
                LoggingManager.Error(
                    string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadLocalFileToBlob",
                        "FileApiController", ex.Message), ex);
                return Json(new BtrakJsonResult() { Data = ex.Message, Success = false });
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue,
                "UploadLocalFileToBlob", "FileApiController"));

            return Json(new BtrakJsonResult { Data = filePath, Success = true });
        }
    }
}
