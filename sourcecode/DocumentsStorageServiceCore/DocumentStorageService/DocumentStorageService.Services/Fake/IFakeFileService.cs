using System;
using System.Collections.Generic;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;

namespace DocumentStorageService.Services.Fake
{
    public interface IFakeFileService
    {
        Guid? UpsertFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteFolder(Guid? folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateFolderDescription(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
