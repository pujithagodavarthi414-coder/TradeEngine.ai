using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using System;
using System.Collections.Generic;
using System.Text;
using DocumentStorageService.Repositories.FileStore;
using DocumentStorageService.Services.Helpers;
using DocumentStorageService.Helpers.Constants;
using System.Linq;
using System.IO;
using System.Net;

namespace DocumentStorageService.Services.FileStore
{
    public class FileUploadService : IFileUploadService
    {
        private readonly FileRepository _fileRepository;
        private readonly StoreRepository _storeRepository;
        private readonly UploadFileRepository _uploadFileRepository;
        public FileUploadService(FileRepository fileRepository, StoreRepository storeRepository, UploadFileRepository uploadFileRepository)
        {
            _fileRepository = fileRepository;
            _storeRepository = storeRepository;
            _uploadFileRepository = uploadFileRepository;
        }

        public List<Guid?> UpsertMultipleFiles(UpsertFileInputModel fileUpsertInputModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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
                if (fileUpsertInputModels.ParentFolderNames.Count > 0)
                {
                    foreach (var folderName in fileUpsertInputModels.ParentFolderNames)
                    {
                        var folderSearchInputModel = new SearchFolderInputModel();
                        folderSearchInputModel.FolderName = folderName;
                        folderSearchInputModel.StoreId = fileUpsertInputModels.StoreId;
                        folderSearchInputModel.IsArchived = false;
                        SearchFolderOutputModel folderOutputModel = _fileRepository
                            .SearchFolders(folderSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();
                        if (folderOutputModel == null)
                        {
                            folderId = Guid.NewGuid();
                            var upsertFolderInputModel = new UpsertFolderInputModel();
                            upsertFolderInputModel.FolderName = folderName;
                            upsertFolderInputModel.StoreId = fileUpsertInputModels.StoreId;
                            upsertFolderInputModel.ParentFolderId = parentFolderId;
                            upsertFolderInputModel.FolderReferenceId = upsertFolderInputModel.FolderReferenceId;
                            upsertFolderInputModel.FolderReferenceTypeId = upsertFolderInputModel.FolderReferenceTypeId;
                            FolderCollectionModel folderCollectionModel =
                                FolderModelConverter.ConvertFolderUpsertInputModelToCollectionModel(upsertFolderInputModel);
                            folderCollectionModel.Id = folderId;
                            folderCollectionModel.CreatedDateTime = DateTime.UtcNow;
                            folderCollectionModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                            Guid? createdFolderId = _fileRepository.CreateFolder(folderCollectionModel,
                                loggedInContext, validationMessages);
                            parentFolderId = folderCollectionModel.Id;
                        }
                        else
                        {
                            parentFolderId = folderOutputModel.Id;
                        }
                    }
                }

                if (fileUpsertInputModels.FolderId == null)
                {
                    var folderNameSearchInputModel = new SearchFolderInputModel();
                    folderNameSearchInputModel.FolderName = fileUpsertInputModels.ParentFolderNames[fileUpsertInputModels.ParentFolderNames.Count - 1];
                    folderNameSearchInputModel.StoreId = fileUpsertInputModels.StoreId;
                    folderNameSearchInputModel.IsArchived = false;
                    folderNameOutputModel = _fileRepository
                        .SearchFolders(folderNameSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();
                    if (folderNameOutputModel != null)
                    {
                        fileUpsertInputModels.FolderId = folderNameOutputModel.Id;
                        fileUpsertInputModels.ReferenceId = fileUpsertInputModels.ReferenceId != null ? fileUpsertInputModels.ReferenceId : folderNameOutputModel.Id;
                    }
                }
                else
                {
                    fileUpsertInputModels.FolderId = fileUpsertInputModels.FolderId;
                    fileUpsertInputModels.ReferenceId = fileUpsertInputModels.FolderId;
                }
                FileApiReturnModel fileDetails = null;
                if (fileUpsertInputModels.DocumentId != null)
                {
                    fileDetails = _fileRepository.GetFileDetails(fileUpsertInputModels.DocumentId,null,
                        loggedInContext, new List<ValidationMessages>());
                }

                if (fileDetails != null)
                {
                    var versionsCount = fileDetails.VersionNumber;
                    var fileUpsertReturnModel = new FileModel();
                    fileUpsertReturnModel.FileId = fileDetails.Id;
                    foreach (var file in fileUpsertInputModels.FilesList)
                    {
                        fileUpsertReturnModel.VersionNumber = versionsCount + 1;
                        fileUpsertReturnModel.FilePath = file.FilePath;
                        FileCollectionModel fileCollection =
                            FileModelConverter.ConvertFileUpdateInputModelToCollectionModel(fileUpsertReturnModel);
                        Guid? fileId =
                            _uploadFileRepository.UpdateDocumentVersion(fileCollection, loggedInContext,
                                validationMessages);
                        AddVersionsToExistingDocuments(fileDetails, loggedInContext, validationMessages);
                        fileUploadIds.Add(fileId);
                    }
                 
                }
                else
                {
                    fileUploadIds = UploadFileInMongoDb(fileUpsertInputModels, loggedInContext, validationMessages);
                }

                if (fileUploadIds.Count > 0)
                {
                    System.Threading.Tasks.Task.Factory.StartNew(() =>
                    {
                        IncrementFolderAndStoreSize(fileUpsertInputModels, loggedInContext);
                    });

                }
            }

            return fileUploadIds;
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
                upsertFileInputModel.ReferenceTypeName = fileUpsertReturnModels.ReferenceTypeName;
                upsertFileInputModel.FilePath = fileCollection.FilePath;
                upsertFileInputModel.Description = fileCollection.Description;
                upsertFileInputModel.FileName = fileCollection.FileName;
                upsertFileInputModel.FileExtension = fileCollection.FileExtension;
                upsertFileInputModel.FileSize = fileCollection.FileSize;
                upsertFileInputModel.IsQuestionDocuments = fileCollection.IsQuestionDocuments;
                upsertFileInputModel.QuestionDocumentId = fileCollection.QuestionDocumentId;
                upsertFileInputModel.IsArchived = false;
                FileCollectionModel fileCollectionModel = FileModelConverter.ConvertFileUpsertInputModelToCollectionModel(upsertFileInputModel ?? new FileUpsertReturnModel());
                fileCollectionModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                fileCollectionModel.Id = Guid.NewGuid();
                fileCollectionModel.DocumentId = fileUpsertReturnModels.DocumentId;
                fileCollectionModel.VersionNumber = 1;

                // search records
                var fileSearchModel = new FileSearchCriteriaInputModel();
                fileSearchModel.ReferenceId = upsertFileInputModel.ReferenceId;
                fileSearchModel.ReferenceTypeId = upsertFileInputModel.ReferenceTypeId;
                fileSearchModel.FileName = fileCollection.FileName;
                var records = _uploadFileRepository.SearchFile(fileSearchModel, loggedInContext, validationMessages);
                
                Guid? fileId = _uploadFileRepository.CreateFile(fileCollectionModel, loggedInContext, validationMessages);
                fileIds.Add(fileCollectionModel.Id);
            }
            return fileIds;
        }

        public void IncrementFolderAndStoreSize(UpsertFileInputModel fileUpsertReturnModels,
            LoggedInContext loggedInContext)
        {
            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            long? fileSize = 0;

            foreach (var fileModel in fileUpsertReturnModels.FilesList)
            {
                fileSize += fileModel.FileSize;
            }

            Guid? folderId = fileUpsertReturnModels.FolderId;
            Guid? storeId = fileUpsertReturnModels.StoreId;
            List<SearchFolderOutputModel> searchFolderModel =
                _fileRepository.GetParentAndChildFolders(folderId, loggedInContext, validationMessages);
            if (searchFolderModel.Count > 0)
            {
                foreach (var folder in searchFolderModel)
                {
                    if (folder.FolderSize == null)
                    {
                        folder.FolderSize = 0;
                    }
                    var folderSize = folder.FolderSize + fileSize;
                    var upsertFolderInputModel = new UpsertFolderInputModel();
                    upsertFolderInputModel.FolderId = folder.ParentFolderId;
                    upsertFolderInputModel.Size = folderSize;
                    FolderCollectionModel folderCollectionModel =
                        FolderModelConverter.ConvertFolderUpsertInputModelToCollectionModel(upsertFolderInputModel);
                    folderCollectionModel.UpdatedDateTime = DateTime.UtcNow;
                    Guid? updateFolderId = _fileRepository.UpdateFolderSize(folderCollectionModel, loggedInContext, validationMessages);

                }
            }
            if (storeId != null)
            {
                var storeInputModel = new StoreInputModel();
                var storeSearchCriteriaInputModel = new StoreCriteriaSearchInputModel();
                storeSearchCriteriaInputModel.Id = storeId;

                StoreOutputReturnModels storeOutputModel = _storeRepository
                    .SearchStore(storeSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();
                if (storeOutputModel != null)
                {
                    if (storeOutputModel.StoreSize == null)
                    {
                        storeOutputModel.StoreSize = 0;
                    }
                    var storeSize = storeOutputModel.StoreSize + fileSize;
                    storeInputModel.StoreId = storeId;
                    storeInputModel.StoreSize = storeSize;
                }

                StoreCollectionModel updateStoreSize =
                    StoreModelConverter.ConvertStoreUpsertInputModelToCollectionModel(storeInputModel);
                updateStoreSize.UpdatedDateTime = DateTime.UtcNow;
                Guid? updateStoreId =
                    _storeRepository.UpdateStoreSize(updateStoreSize, loggedInContext, validationMessages);
            }

        }

        public Guid? ArchiveFile(Guid? fileId, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
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
                Guid? deleteFileId = _uploadFileRepository.ArchiveFile(fileId, loggedInContext, validationMessages);
            }
            else
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.FileIdNotExists)
                });
                return null;
            }


            System.Threading.Tasks.Task.Factory.StartNew(() =>
            {
                DecrementFolderAndStoreSize(fileDetails, loggedInContext);
            });


            return fileId;
        }

        public void DecrementFolderAndStoreSize(FileApiReturnModel fileApiModel, LoggedInContext loggedInContext)
        {
            Guid? storeId = null;
            List<ValidationMessage> validationMessages = new List<ValidationMessage>();
            List<SearchFolderOutputModel> searchFolderModel =
                _fileRepository.GetParentAndChildFolders(fileApiModel.FolderId, loggedInContext, validationMessages);
            if (searchFolderModel.Count > 0)
            {
                storeId = searchFolderModel[0].StoreId;
                foreach (var folder in searchFolderModel)
                {
                    if (folder.FolderSize == null)
                    {
                        folder.FolderSize = 0;
                    }
                    var folderSize = folder.FolderSize - fileApiModel.FileSize;
                    var upsertFolderInputModel = new UpsertFolderInputModel();
                    upsertFolderInputModel.FolderId = folder.ParentFolderId;
                    upsertFolderInputModel.Size = folderSize;
                    FolderCollectionModel folderCollectionModel =
                        FolderModelConverter.ConvertFolderUpsertInputModelToCollectionModel(upsertFolderInputModel);
                    folderCollectionModel.UpdatedDateTime = DateTime.UtcNow;
                    Guid? updateFolderId = _fileRepository.UpdateFolderSize(folderCollectionModel, loggedInContext, validationMessages);
                }
            }

            if (storeId != null)
            {
                var storeInputModel = new StoreInputModel();
                var storeSearchCriteriaInputModel = new StoreCriteriaSearchInputModel();
                storeSearchCriteriaInputModel.Id = storeId;

                StoreOutputReturnModels storeOutputModel = _storeRepository
                    .SearchStore(storeSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();
                if (storeOutputModel != null)
                {
                    if (storeOutputModel.StoreSize == null)
                    {
                        storeOutputModel.StoreSize = 0;
                    }
                    var storeSize = storeOutputModel.StoreSize - fileApiModel.FileSize;
                    storeInputModel.StoreId = storeId;
                    storeInputModel.StoreSize = storeSize;
                }

                StoreCollectionModel updateStoreSize =
                    StoreModelConverter.ConvertStoreUpsertInputModelToCollectionModel(storeInputModel);
                updateStoreSize.UpdatedDateTime = DateTime.UtcNow;
                Guid? updateStoreId =
                    _storeRepository.UpdateStoreSize(updateStoreSize, loggedInContext, validationMessages);
            }
        }

        public List<FileApiReturnModel> SearchFile(FileSearchCriteriaInputModel fileSearchCriteriaInput,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to SearchFile." + "FileSearchCriteriaInputModel=" + fileSearchCriteriaInput + ", loggedInContext=" + loggedInContext.LoggedInUserId);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, fileSearchCriteriaInput, validationMessages))
            {
                return null;
            }

            List<FileApiReturnModel> fileApiReturnModels = _uploadFileRepository.SearchFile(fileSearchCriteriaInput, loggedInContext, validationMessages);
            return fileApiReturnModels;
        }

        public Guid? UpdateFile(FileModel fileModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to SearchFile." + "FileModel=" + fileModel + ", loggedInContext=" + loggedInContext.LoggedInUserId);
            if (!FileValidations.ValidateReviewFile(fileModel, loggedInContext, validationMessages))
            {
                return null;
            }
            FileCollectionModel fileCollectionModel =
                FileModelConverter.ConvertFileUpdateInputModelToCollectionModel(fileModel);
            fileCollectionModel.UpdatedDateTime = DateTime.UtcNow;

            var searchFileInputModel = new FileSearchCriteriaInputModel();
            searchFileInputModel.FileId = fileModel.FileId;
            searchFileInputModel.IsArchived = false;
            FileApiReturnModel fileDetails =
                SearchFile(searchFileInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (fileDetails == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.FileIdNotExists)
                });
                return null;

            }
            else
            {
                Guid? fileId = _uploadFileRepository.UpdateFile(fileCollectionModel, loggedInContext, validationMessages);
            }

            return fileCollectionModel.Id;
        }

        public Guid? ReviewFile(FileModel fileModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
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

            var searchFileInputModel = new FileSearchCriteriaInputModel();
            searchFileInputModel.FileId = fileModel.FileId;
            searchFileInputModel.IsArchived = false;
            FileApiReturnModel fileDetails =
                SearchFile(searchFileInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (fileDetails == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.FileIdNotExists)
                });
                return null;
            }
            else
            {
                Guid? fileId = _uploadFileRepository.UpdateReviewFile(fileCollectionModel, loggedInContext, validationMessages);
            }

            return fileCollectionModel.Id;
        }

        public byte[] DownloadFile(string filePath, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered Download File with filePath" + filePath + ",Logged in User Id=" + loggedInContext);

            LoggingManager.Debug(filePath);

            if (!FileValidations.ValidateDownloadFile(filePath, validationMessages))
            {
                return null;
            }

            byte[] fileData = DownloadFileData(filePath);

            LoggingManager.Debug(fileData?.ToString());

            return fileData;
        }

        public void AddVersionsToExistingDocuments(FileApiReturnModel fileDetails,LoggedInContext loggedInContext,List<ValidationMessage> validationMessages)
        {
            var fileCollectionModel = new FileCollectionModel();
            fileCollectionModel.Id = fileDetails.Id;
            fileCollectionModel.FilePath = fileDetails.FilePath;
            fileCollectionModel.VersionNumber = fileDetails.VersionNumber;
            Guid? fileId =
                _uploadFileRepository.AddVersionToDocument(fileCollectionModel, loggedInContext, validationMessages);
        }

        public byte[] DownloadFileData(string filePath)
        {
            byte[] buffer = null;

            if (filePath != null)
            {
                using (var client = new WebClient())
                {
                    var content = client.DownloadData(filePath);
                    using (var stream = new MemoryStream(content))
                    {
                        int length = (int)stream.Length;

                        using (BinaryReader br = new BinaryReader(stream))
                        {
                            buffer = br.ReadBytes(length);
                        }
                    }
                }
            }

            return buffer;
        }

        public Guid? ActivateAndArchiveFiles(ActivateAndArchiveFileInputModel activateAndArchiveFile, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to ActivateAndArchiveFiles." + "ActivateAndArchiveFileInputModel=" + activateAndArchiveFile + ", loggedInContext=" + loggedInContext.LoggedInUserId);
            Guid? result = Guid.Empty;

            if (activateAndArchiveFile.ActivateFile.Count > 0)
            {
                foreach (var file in activateAndArchiveFile.ActivateFile)
                {
                    FileCollectionModel fileCollectionModel =
                    FileModelConverter.ConvertFileUpdateInputModelToCollectionModel(file);
                    fileCollectionModel.UpdatedDateTime = DateTime.UtcNow;

                    var searchFileInputModel = new FileSearchCriteriaInputModel();
                    searchFileInputModel.FileId = file.FileId;
                    searchFileInputModel.IsArchived = true;
                    FileApiReturnModel fileDetails =
                        SearchFile(searchFileInputModel, loggedInContext, validationMessages).FirstOrDefault();

                    if (fileDetails == null)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = string.Format(ValidationMessages.FileIdNotExists)
                        });
                        //return null;
                    }
                    else
                    {
                        Guid? fileId = _uploadFileRepository.UpdateFile(fileCollectionModel, loggedInContext, validationMessages);
                    }
                }

                result = activateAndArchiveFile.ActivateFile[0].FileId;
            }

            if (activateAndArchiveFile.ArchiveFileIds.Count > 0)
            {
                foreach (var id in activateAndArchiveFile.ArchiveFileIds)
                {
                    ArchiveFile(id, loggedInContext, validationMessages);
                }
                result = activateAndArchiveFile.ArchiveFileIds[0];
            }
            return result;
        }
    } }
