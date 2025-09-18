using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using DocumentStorageService.Repositories.Fake;
using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Services.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;

namespace DocumentStorageService.Services.Fake
{
    public class FakeFileUploadService : IFakeFileUploadService
    {
        private FakeUploadFileRepository _fakeUploadFileRepository;

        public FakeFileUploadService(FakeUploadFileRepository fakeUploadFileRepository)
        {
            _fakeUploadFileRepository = fakeUploadFileRepository;
        }
        public List<Guid?> CreateMultipleFiles(UpsertFileInputModel fileUpsertInputModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFile", "File Service and logged details=" + loggedInContext));


            List<Guid?> fileUploadIds = new List<Guid?>();
            Guid? parentFolderId = null;
            Guid? folderId = null;
            SearchFolderOutputModel folderNameOutputModel = new SearchFolderOutputModel();
            if (fileUpsertInputModels != null)
            {
                LoggingManager.Debug(fileUpsertInputModels.ToString());

                if (fileUpsertInputModels.ReferenceTypeId == Guid.Empty || fileUpsertInputModels.ReferenceTypeId == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(ValidationMessages.NotEmptyReferenceTypeId)
                    });
                    return null;
                }


                var filesWithoutErrors = new List<FileModel>();

                foreach (var file in fileUpsertInputModels.FilesList)
                {
                    List<ValidationMessage> validations = new List<ValidationMessage>();

                    FileValidations.ValidateUpsertFile(file, loggedInContext, validations);

                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                    }
                    else
                    {
                        filesWithoutErrors.Add(file);
                    }
                }

                fileUpsertInputModels.FilesList = filesWithoutErrors;


                fileUpsertInputModels.FolderId = fileUpsertInputModels.FolderId;
                fileUpsertInputModels.ReferenceId = fileUpsertInputModels.FolderId;


                fileUploadIds = UploadFileInMongoDb(fileUpsertInputModels, loggedInContext, validationMessages);

            }

            return fileUploadIds;
        }

        public Guid? DeleteFile(Guid? fileId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to DeleteFile." + "fileId=" + fileId + ", loggedInContext=" + loggedInContext.LoggedInUserId);

            LoggingManager.Debug(fileId.ToString());

            if (!FileValidations.ValidateDeleteFile(fileId, loggedInContext, validationMessages))
            {
                return null;
            }

            var searchFileInputModel = new FileSearchCriteriaInputModel();
            searchFileInputModel.FileId = fileId;
            searchFileInputModel.IsArchived = false;
            FileApiReturnModel fileDetails =
                SearchFile(searchFileInputModel, loggedInContext, validationMessages).FirstOrDefault();
            if (fileDetails != null)
            {
                Guid? deleteFileId = _fakeUploadFileRepository.ArchiveFile(fileId, loggedInContext, validationMessages);
            }
            else
            {
                return null;
            }

            return fileId;
        }

        public Guid? ReviewFile(FileModel fileModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to ReviewFile." + "FileModel=" + fileModel + ", loggedInContext=" + loggedInContext.LoggedInUserId);
            if (!FileValidations.ValidateReviewFile(fileModel, loggedInContext, validationMessages))
            {
                return null;
            }
            FileCollectionModel fileCollectionModel =
                FileModelConverter.ConvertFileUpdateInputModelToCollectionModel(fileModel);
            fileCollectionModel.UpdatedDateTime = DateTime.UtcNow;
            fileCollectionModel.IsToBeReviewed = true;
            fileCollectionModel.ReviewedDateTime = DateTime.UtcNow;
            fileCollectionModel.ReviewedByUserId = loggedInContext.LoggedInUserId;

            if (validationMessages.Count > 0)
            {
                return null;
            }
            else
            {
                Guid? fileId = _fakeUploadFileRepository.UpdateFile(fileCollectionModel, loggedInContext, validationMessages);
            }

            return fileCollectionModel.Id;
        }

        public List<FileApiReturnModel> SearchFile(FileSearchCriteriaInputModel fileSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to SearchFile." + "FileSearchCriteriaInputModel=" + fileSearchCriteriaInputModel + ", loggedInContext=" + loggedInContext.LoggedInUserId);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, fileSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            List<FileApiReturnModel> fileApiReturnModels = _fakeUploadFileRepository.SearchFile(fileSearchCriteriaInputModel, loggedInContext, validationMessages);
            return fileApiReturnModels;
        }

        public Guid? UpdateFile(FileCollectionModel fileCollectionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public Guid? UpdateFile(FileModel fileModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to SearchFile." + "FileModel=" + fileModel + ", loggedInContext=" + loggedInContext.LoggedInUserId);
            if (!FileValidations.ValidateReviewFile(fileModel, loggedInContext, validationMessages))
            {
                return null;
            }
            FileCollectionModel fileCollectionModel =
                FileModelConverter.ConvertFileUpdateInputModelToCollectionModel(fileModel);
            fileCollectionModel.UpdatedDateTime = DateTime.UtcNow;
            if (validationMessages.Count > 0)
            {
                return null;
            }
            else
            {
                Guid? fileId = _fakeUploadFileRepository.UpdateFile(fileCollectionModel, loggedInContext, validationMessages);
            }

            return fileCollectionModel.Id;
        }

        private List<Guid?> UploadFileInMongoDb(UpsertFileInputModel fileUpsertReturnModels,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<Guid?> fileIds = new List<Guid?>();
            Guid? folderId = null;

            foreach (var fileCollection in fileUpsertReturnModels.FilesList)
            {
                var upsertFileInputModel = new FileUpsertReturnModel();
                upsertFileInputModel.FolderId = fileUpsertReturnModels.FolderId;
                upsertFileInputModel.StoreId = fileUpsertReturnModels.StoreId;
                upsertFileInputModel.ReferenceTypeId = fileUpsertReturnModels.ReferenceTypeId;
                upsertFileInputModel.ReferenceId = fileUpsertReturnModels.ReferenceId;
                upsertFileInputModel.FilePath = fileCollection.FilePath;
                upsertFileInputModel.FileName = fileCollection.FileName;
                upsertFileInputModel.FileExtension = fileCollection.FileExtension;
                upsertFileInputModel.FileSize = fileCollection.FileSize;
                upsertFileInputModel.IsQuestionDocuments = fileCollection.IsQuestionDocuments;
                upsertFileInputModel.QuestionDocumentId = fileCollection.QuestionDocumentId;
                upsertFileInputModel.IsArchived = false;
                FileCollectionModel fileCollectionModel = FileModelConverter.ConvertFileUpsertInputModelToCollectionModel(upsertFileInputModel ?? new FileUpsertReturnModel());
                fileCollectionModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                fileCollectionModel.Id = Guid.NewGuid();
                Guid? fileId = _fakeUploadFileRepository.CreateFile(fileCollectionModel, loggedInContext, validationMessages);
                fileIds.Add(fileCollectionModel.Id);
            }
            return fileIds;
        }
    }
}
