using Btrak.Models;
using Btrak.Models.Chat;
using Btrak.Services.Chat;
using Btrak.Services.FileUploadDownload;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;

namespace BTrak.Api.Controllers.FileStore
{
    public class SlackFilesApiController : AuthTokenApiController
    {
        private readonly IChatService _chatService;
        private readonly IFileStoreService _fileStoreService;

        public SlackFilesApiController(IChatService chatService,IFileStoreService fileStoreService)
        {
            _chatService = chatService;
            _fileStoreService = fileStoreService;
        }

        [HttpPost]
        [ActionName("SendFiles")]
        [Route(RouteConstants.UploadFileInChat)]
        public JsonResult<BtrakSlackJsonResult> StoreFilesInBlob([FromBody] FileExchangeDetails exchangeFiles)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "StoreFilesInBlob", "ChatApiController"));

            List<MessageUpsertInputModel> uploadedFiles = new List<MessageUpsertInputModel>();

            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;

            if (exchangeFiles != null && exchangeFiles.Files.Count > 0 && exchangeFiles.SenderId != default(Guid))
            {
                foreach (var file in exchangeFiles.Files)
                {
                    if (file.FileBytes.Length > 0)
                    {
                        FilePostInputModel filePostInputModel = new FilePostInputModel
                        {
                            MemoryStream = file.FileBytes,
                            FileName = file.FileName,
                            ContentType = file.FileType
                        };

                        filePostInputModel.LoggedInUserId = LoggedInContext.LoggedInUserId;
                        string fileBlobPath = _fileStoreService.PostFile(filePostInputModel);

                        var messageViewModel = new MessageUpsertInputModel
                        {
                            Id = file.MessageId,
                            FilePath = fileBlobPath,
                            IsDeleted = false,
                            MessageDateTime = DateTime.Now,
                            ReceiverUserId = exchangeFiles.ReceiverId,
                            SenderUserId = exchangeFiles.SenderId,
                            ChannelId = exchangeFiles.ChannelId,
                            FileType = file.FileType,
                            SenderName = exchangeFiles.SenderName,
                            ChannelName = exchangeFiles.ChannelName,
                            MessageType = "File",
                            ParentMessageId = exchangeFiles.ParentMessageId
                        };

                        if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                        {
                            validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "StoreFilesInBlob", "SlackFilesApi"));
                            return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                        }

                        _chatService.SendMessageToChannelOrUser(messageViewModel, LoggedInContext, validationMessages);

                        uploadedFiles.Add(messageViewModel);
                    }
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "StoreFilesInBlob", "SlackFilesApi"));
                return Json(new BtrakSlackJsonResult { Data = uploadedFiles }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "StoreFilesInBlob", "SlackFilesApi"));
            return Json(new BtrakSlackJsonResult { Success = false, Result = "No files found" }, UiHelper.JsonSerializerNullValueIncludeSettings);
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadFileInChunks)]
        public JsonResult<BtrakSlackJsonResult> UploadFileInChunks([FromBody] Files file)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "StoreFilesInBlob", "ChatApiController"));

            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;

            string fileBlobPath = string.Empty;

            if (file.FileBytes.Length > 0)
            {
                FilePostInputModel filePostInputModel = new FilePostInputModel
                {
                    MemoryStream = file.FileBytes,
                    FileName = file.FileName,
                    ContentType = file.FileType,
                    ChunkId = file.ChunkId,
                    FileId = file.FileId
                };

                fileBlobPath = _fileStoreService.PostFileAsChunks(filePostInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "StoreFilesInBlob", "SlackFilesApi"));
                    return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "StoreFilesInBlob", "SlackFilesApi"));
            return Json(new BtrakSlackJsonResult { Data = fileBlobPath }, UiHelper.JsonSerializerNullValueIncludeSettings);
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetBlobReference)]
        public JsonResult<BtrakSlackJsonResult> GetBlobReference(FileChunksModel fileChunksModel)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetBlobReference", "ChatApiController"));

            var validationMessages = new List<ValidationMessage>();
            BtrakJsonResult btrakJsonResult;

            string fileUrl = _fileStoreService.CombineChunksAndReturnFileUrl(fileChunksModel.FileName,fileChunksModel.Ids,fileChunksModel.FileType);

            if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
            {
                validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBlobReference", "SlackFilesApi"));
                return Json(new BtrakSlackJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetBlobReference", "SlackFilesApi"));
            return Json(new BtrakSlackJsonResult { Data = fileUrl }, UiHelper.JsonSerializerNullValueIncludeSettings);
        }
    }
}