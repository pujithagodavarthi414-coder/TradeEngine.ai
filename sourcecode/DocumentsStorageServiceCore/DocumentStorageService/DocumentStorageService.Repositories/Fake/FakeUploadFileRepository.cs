using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using System;
using System.Collections.Generic;
using System.Text;

namespace DocumentStorageService.Repositories.Fake
{
   public  class FakeUploadFileRepository
    {
        public Guid? CreateFile(FileCollectionModel upsertFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return upsertFileInputModel.FileId;
        }

        public Guid? ArchiveFile(Guid? fileId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return fileId;
        }

        public List<FileApiReturnModel> SearchFile(FileSearchCriteriaInputModel fileSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new List<FileApiReturnModel>
            {
                new FileApiReturnModel
                {
                    Id = new Guid("92A1FF92-1158-4B64-8ABF-BD815337FBFD"),
                    FolderId = new Guid("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b"),
                    ReferenceId = new Guid("d3c3f943-e134-47d4-afca-5dc0b5eb1c6b"),
                    ReferenceTypeId = new Guid("1b35f2d3-1972-491f-8dc8-0a2a1f429934"),
                    FileName = "Actvity-Log.xlsx",
                    FileSize = 7676,
                    FilePath = "https://bviewstorage.blob.core.windows.net/cf1c6756-936f-4a19-9d48-468d343f10cb/projects/fdc73d7d-7f60-4bfd-aeba-405bb50999fb/Actvity-Log-ec5f8d53-b79c-4c37-a617-cafa65a3a396.xlsx",
                    FileExtension = ".xlsx",
                    IsArchived = false
                }
            };
        }

        public Guid? UpdateFile(FileCollectionModel fileModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return fileModel.FileId;
        }
    }
}
