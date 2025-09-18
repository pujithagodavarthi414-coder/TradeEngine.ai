using System;
using System.Collections.Generic;
using System.Web.Http;
using Btrak.Models;
using Btrak.Services.File;
using Btrak.Services.FileUploadDownload;
using BTrak.Common;

namespace BTrak.Api.Controllers.FileStore
{
    public class FileStoreApiController : ApiController
    {
        private readonly IFileStoreService _fileStoreService;
        private readonly IFileService _fileService;

        public FileStoreApiController()
        {
            _fileStoreService = new FileStoreService();
            _fileService = new FileService();
        }

        [HttpPost]
        [HttpOptions]
        [Route("FileStore/FileStoreApi/PostFile")]
        public string PostFile(FilePostInputModel filePostInputModel)
        {
            try
            {
                return _fileStoreService.PostFile(filePostInputModel);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "PostFile", "FileStoreApiController", exception.Message), exception);

                throw;
            }
        }


        /* Need to check the api by sir for download file */
        [HttpGet]
        [HttpOptions]
        [Route("FileStore/FileStoreApi/DownloadFile")]
        public byte[] DownloadFile(string filePath)
        {
            return _fileStoreService.DownloadFile(filePath);
        }

        //FileDbEntity fileDbEntity = _fileRepository.GetFile(jobModel.FileId);
        [HttpGet]
        [HttpOptions]
        [Route("FileStore/FileStoreApi/GetUserStoryRelatedFiles")]
        public IList<FilesModel> GetUserStoryRelatedFiles(Guid userStoryId)
        {

            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get UserStory Related Files", "File Store Api"));

                var data = _fileService.GetUserStoriesRelatedFiles(userStoryId);
                return data;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserStoryRelatedFiles", "FileStoreApiController", exception.Message), exception);

                throw;
            }

        }
    }
}
