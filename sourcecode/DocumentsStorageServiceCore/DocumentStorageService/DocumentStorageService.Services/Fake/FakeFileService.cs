using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using System;
using System.Collections.Generic;
using System.Text;
using DocumentStorageService.Repositories.Fake;
namespace DocumentStorageService.Services.Fake
{
    public class FakeFileService : IFakeFileService
    {
        private FakeFileRepository _fakeFileRepository;
        public FakeFileService(FakeFileRepository fakeFileRepository)
        {
            _fakeFileRepository = fakeFileRepository;
        }
        public Guid? DeleteFolder(Guid? folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            Guid? deleteFolderId = null;

            deleteFolderId = _fakeFileRepository.ArchiveFolder(folderId, loggedInContext, validationMessages);

            return deleteFolderId;
        }

        public Guid? UpsertFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (!Helpers.FolderValidations.ValidateUpsertFolder(upsertFolderInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            Guid? folderId = null;
            var newFolderUpsertModel = new UpsertFolderInputModel();
            if (validationMessages.Count > 0)
            {
                return null;
            }
            else
            {
                FolderCollectionModel folderCollectionModel = FolderModelConverter.ConvertFolderUpsertInputModelToCollectionModel(upsertFolderInputModel ?? new UpsertFolderInputModel());
                if (upsertFolderInputModel.IsArchived == true)
                {
                    folderCollectionModel.InActiveDateTime = DateTime.UtcNow;
                }
                else
                {
                    folderCollectionModel.InActiveDateTime = null;
                }

                if (upsertFolderInputModel.FolderId != null)
                {
                    folderCollectionModel.Id = newFolderUpsertModel.FolderId;
                    folderCollectionModel.UpdatedByUserId = loggedInContext.LoggedInUserId;
                    folderCollectionModel.UpdatedDateTime = DateTime.UtcNow;
                    folderId = _fakeFileRepository.UpdateFolder(folderCollectionModel, loggedInContext, validationMessages);
                }
                else
                {
                    folderCollectionModel.Id = new Guid("3B3DE008-7F82-4ADF-A867-8827A99CE596");
                    folderCollectionModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                    folderCollectionModel.CreatedDateTime = DateTime.UtcNow;
                    folderId = _fakeFileRepository.CreateFolder(folderCollectionModel, loggedInContext, validationMessages);
                }
                return folderId;
            }
        }

        public Guid? UpdateFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            if (!Helpers.FolderValidations.ValidateUpsertFolder(upsertFolderInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            FolderCollectionModel folderCollectionModel = FolderModelConverter.ConvertFolderUpsertInputModelToCollectionModel(upsertFolderInputModel ?? new UpsertFolderInputModel());
            folderCollectionModel.Id = upsertFolderInputModel.FolderId;
            folderCollectionModel.UpdatedByUserId = loggedInContext.LoggedInUserId;
            folderCollectionModel.UpdatedDateTime = DateTime.UtcNow;
            Guid? folderId = _fakeFileRepository.UpdateFolder(folderCollectionModel, loggedInContext, validationMessages);
            return folderId;
        }

        public Guid? UpdateFolderDescription(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
           
            FolderCollectionModel folderCollectionModel = FolderModelConverter.ConvertFolderUpsertInputModelToCollectionModel(upsertFolderInputModel ?? new UpsertFolderInputModel());
            folderCollectionModel.Id = upsertFolderInputModel.FolderId;
            folderCollectionModel.UpdatedByUserId = loggedInContext.LoggedInUserId;
            folderCollectionModel.UpdatedDateTime = DateTime.UtcNow;
            Guid? folderId = _fakeFileRepository.UpdateFolderDescription(folderCollectionModel, loggedInContext, validationMessages);
            return folderId;
        }
    }
}
