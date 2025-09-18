using System;
using System.Collections.Generic;
using System.Text;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
namespace DocumentStorageService.Services.FileStore
{
    public interface IFileUploadService
    {
        List<Guid?> UpsertMultipleFiles(UpsertFileInputModel fileUpsertInputModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ArchiveFile(Guid? fileId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FileApiReturnModel> SearchFile(FileSearchCriteriaInputModel fileSearchCriteriaInput,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateFile(FileModel fileModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
        Guid? ReviewFile(FileModel fileModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
        byte[] DownloadFile(string filePath, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ActivateAndArchiveFiles(ActivateAndArchiveFileInputModel activateAndArchiveFile, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
