using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace DocumentStorageService.Services.FileStore
{
   public interface IFileService
    {
        Guid? CreateFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ArchiveFolder(Guid? folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateFolder(UpsertFolderInputModel updateFolderInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
        SearchFolderOutputModel SearchFolder(SearchFolderInputModel searchFolderInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string FolderTreeView(SearchFolderInputModel searchFolderInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateFolderDescription(UpsertFolderInputModel updateFolderInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);

       Task  UploadFilesChunk(IFormFile file, int id,int moduleTypeId, string fileName, string contentType,Guid? parentDocumentId,LoggedInContext loggedInContext,IHttpContextAccessor httpContextAccessor,
            List<ValidationMessage> validationMessages);
       string GetChunkBlobUrl(string fileName, int moduleTypeId,string[] ids, string contentType, Guid? parentDocumentId,LoggedInContext loggedInContext,IHttpContextAccessor httpContextAccessor);
        string UploadLocalFileToBlob(UploadFileToBlobInputModel uploadFileToBlobInputModel, LoggedInContext loggedInContext, IHttpContextAccessor httpContextAccessor);
    }
    
}
