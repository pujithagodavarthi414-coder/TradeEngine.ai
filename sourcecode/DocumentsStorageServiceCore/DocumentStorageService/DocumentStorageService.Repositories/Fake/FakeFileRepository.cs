using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using System;
using System.Collections.Generic;
using System.Text;

namespace DocumentStorageService.Repositories.Fake
{
    public class FakeFileRepository
    {
        public Guid? AddChildFolders(FolderCollectionModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public Guid? CreateFolder(FolderCollectionModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            return upsertFolderInputModel.Id;
        }

        public Guid? ArchiveFolder(Guid? folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return folderId;
        }

        public List<FolderTreeStructureModel> FolderTreeView(SearchFolderInputModel searchFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public bool? GetFolderDetails(Guid? folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return true;
        }

        public List<SearchFolderOutputModel> GetParentAndChildFolders(Guid? folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public List<SearchFolderOutputModel> SearchFolders(SearchFolderInputModel searchFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public SearchFolderOutputModel SearchFoldersAndFiles(SearchFolderInputModel searchFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public Guid? UpdateFolder(FolderCollectionModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return upsertFolderInputModel.Id;
        }

        public Guid? UpdateFolderDescription(FolderCollectionModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public Guid? UpdateFolderSize(FolderCollectionModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public List<UploadFileReturnModel> GetFilesFromFolder(Guid? folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public Guid? ArchiveFile(Guid? Id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
    }
}
