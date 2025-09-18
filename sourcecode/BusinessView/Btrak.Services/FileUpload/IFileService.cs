using Btrak.Models;
using Btrak.Models.DocumentManagement;
using Btrak.Models.File;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using Btrak.Models.ActivityTracker;
using System.Net;
using System.IO;

namespace Btrak.Services.FileUpload
{
    public abstract class IFileService
    {
       // public abstract Guid? UpsertFile(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract List<Guid?> UpsertMultipleFiles(FileUpsertInputModel fileUpsertInputModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract byte[] DownloadFile(string filePath, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract Guid? DeleteFile(DeleteFileInputModel deleteFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract Guid? DeleteFileByReferenceId(DeleteFileInputModel deleteFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract List<FileApiReturnModel> GetFileDetailById(List<Guid?> fileId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract Task<List<FileResult>> UploadFile(HttpRequest httpRequest, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, int moduleTypeId);
        public abstract List<FileResult> UploadActivityTrackerScreenShot(InsertUserActivityScreenShotInputModel insertUserActivityScreenShotInputModel, List<ValidationMessage> validationMessages, UploadScreenshotInputModel uploadScreenshotInputModel);

        public abstract List<FileApiReturnModel> SearchFile(FileSearchCriteriaInputModel fileSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> vaidValidationMessages);
        public abstract SearchFolderOutputModel SearchFolder(SearchFolderInputModel searchFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract Guid? UpsertFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract Guid? UpsertFolderDescription(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract Guid? UpsertUploadFile(UpsertUploadFileInputModel upsertUploadFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract List<SearchFileHistoryOutputModel> SearchFileHistory(SearchFileHistoryInputModel searchFileHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract SearchFoldersAndFilesReturnModel GetFoldersAndFiles(SearchFoldersAndFilesInputModel searchFoldersAndFilesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract Guid? ReviewFile(FileModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract Guid? UpsertFileName(FileModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract Guid? UpsertFileDetails(UpsertUploadFileInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract Task<FileResult> ReadPart(DriveFile file, MultipartFormDataStreamProvider provider, object sr, LoggedInContext loggedInContext, List<ValidationMessage> validationMessage);
        public abstract bool ChunkIsHere(int chunkNumber, string identifier);
        public abstract Task<object> UploadFile(MultipartFormDataStreamProvider provider, HttpRequestMessage requestMessage, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract FolderApiReturnModel GetFolderDetailById(Guid folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        public abstract byte[] GetFileDetails(Guid fileId, List<ValidationMessage> validationMessages, out WebHeaderCollection contentType);
        public abstract Task<List<FileResult>> UploadFileFromForms(HttpRequest httpRequest, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, int moduleTypeId, Guid referenceId);
    }
}