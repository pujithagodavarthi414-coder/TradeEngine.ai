using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DocumentStorageService.Models.AccessRights;

namespace DocumentStorageService.Models.FileStore
{
   public class FileModelConverter
    {
        public static FileCollectionModel ConvertFileUpsertInputModelToCollectionModel(FileUpsertReturnModel inputModel)
        {
            return new FileCollectionModel
            {
                Id = inputModel.FileId,
                FileName = inputModel.FileName,
                FileExtension = inputModel.FileExtension,
                StoreId = inputModel.StoreId,
                FolderId = inputModel.FolderId,
                FileSize = inputModel.FileSize,
                ReferenceId = (inputModel.ReferenceId != null ? inputModel.ReferenceId : inputModel.FolderId),
                ReferenceTypeId = inputModel.ReferenceTypeId,
                ReferenceTypeName = inputModel.ReferenceTypeName,
                IsQuestionDocuments = inputModel.IsQuestionDocuments,
                Description = inputModel.Description,
                QuestionDocumentId = inputModel.QuestionDocumentId,
                IsToBeReviewed = inputModel.IsToBeReviewed,
                FilePath = inputModel.FilePath,
                CreatedDateTime = DateTime.UtcNow,
                IsArchived = false,
                DocumentId = inputModel.DocumentId,
                VersionNumber = inputModel.VersionNumber,
                Versions = new List<VersionModel>(),
                AccessRights = new List<AccessModel>()
            };
        }

        public static FileCollectionModel ConvertFileUpdateInputModelToCollectionModel(FileModel inputModel)
        {
            return new FileCollectionModel
            {
                Id = inputModel.FileId,
                FileName = inputModel.FileName,
                FileExtension = inputModel.FileExtension,
                FileSize = inputModel.FileSize,
                IsQuestionDocuments = inputModel.IsQuestionDocuments,
                QuestionDocumentId = inputModel.QuestionDocumentId,
                FilePath = inputModel.FilePath,
                UpdatedDateTime = DateTime.UtcNow,
                IsArchived = false,
                VersionNumber = inputModel.VersionNumber
            };
        }
    }
}
