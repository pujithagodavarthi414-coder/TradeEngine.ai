using System;
using System.Collections.Generic;
using System.Text;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;

namespace DocumentStorageService.Services.Fake
{
   public  interface IFakeFileUploadService
    {
        List<Guid?> CreateMultipleFiles(UpsertFileInputModel fileCollectionModel, LoggedInContext loggedInContext,
           List<ValidationMessage> validationMessages);

        Guid? UpdateFile(FileModel fileCollectionModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);

        Guid? DeleteFile(Guid? fileId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<FileApiReturnModel> SearchFile(FileSearchCriteriaInputModel fileSearchCriteriaInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? ReviewFile(FileModel fileCollectionModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
    }
}
