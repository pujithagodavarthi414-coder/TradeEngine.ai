using System;
using BTrak.Common;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.File;

namespace Btrak.Services.Helpers.File
{
    public class FileValidations
    {
        public static bool ValidateUpsertFile(FileModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(fileUpsertInputModel.FileName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileName)
                });
            }
            if (!string.IsNullOrEmpty(fileUpsertInputModel.FileName) && fileUpsertInputModel.FileName.Length > 800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.ExceededFileName)
                });
            }
            if (string.IsNullOrEmpty(fileUpsertInputModel.FilePath))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFilePath)
                });
            }
            if (!string.IsNullOrEmpty(fileUpsertInputModel.FilePath))
            {
                if (fileUpsertInputModel.FilePath.Length > 2000)
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(ValidationMessages.ExceededFilePath)
                    });
            }
            if (string.IsNullOrEmpty(fileUpsertInputModel.FileExtension))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileExtension)
                });
            }
            if (!string.IsNullOrEmpty(fileUpsertInputModel.FileExtension) && fileUpsertInputModel.FileExtension.Length > 50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.ExceededFileExtension)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertFileDetails(UpsertUploadFileInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(fileUpsertInputModel.FileName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileName)
                });
            }
            if (!string.IsNullOrEmpty(fileUpsertInputModel.FileName) && fileUpsertInputModel.FileName.Length > 800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.ExceededFileName)
                });
            }
            if (string.IsNullOrEmpty(fileUpsertInputModel.FilePath))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFilePath)
                });
            }
            if (!string.IsNullOrEmpty(fileUpsertInputModel.FilePath))
            {
                if (fileUpsertInputModel.FilePath.Length > 2000)
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(ValidationMessages.ExceededFilePath)
                    });
            }
            if (string.IsNullOrEmpty(fileUpsertInputModel.FileExtension))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileExtension)
                });
            }
            if (!string.IsNullOrEmpty(fileUpsertInputModel.FileExtension) && fileUpsertInputModel.FileExtension.Length > 50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.ExceededFileExtension)
                });
            }

            return validationMessages.Count <= 0;
        }


        public static bool ValidateDownloadFile(List<ValidationMessage> validationMessages, byte[] fileData)
        {
            if (fileData == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileDownLoad)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateDeleteFile(DeleteFileInputModel deleteFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (deleteFileInputModel.FileId == Guid.Empty || deleteFileInputModel.FileId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateReviewFile(FileModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (fileInputModel.FileId == Guid.Empty || fileInputModel.FileId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateFileName(FileModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (fileInputModel.FileId == Guid.Empty || fileInputModel.FileId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileId)
                });
            }
           
            return validationMessages.Count <= 0;
        }

        public static bool ValidateDownloadFile(string filePath, List<ValidationMessage> validationMessages)
        {
            if (string.IsNullOrEmpty(filePath))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFilePath)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateFileDetailFoundWithId(List<Guid?> fileIds, List<ValidationMessage> validationMessages, List<FileApiReturnModel> fileModel)
        {
            if (fileModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundFileWithTheId, fileIds)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateFileDetailById(Guid? fileId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (fileId == Guid.Empty || fileId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(upsertFolderInputModel.FolderName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFolderName)
                });
            }
            if (!string.IsNullOrEmpty(upsertFolderInputModel.FolderName))
            {
                if (upsertFolderInputModel.FolderName.Length > 50)
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(ValidationMessages.ExceededFolderName)
                    });
            }
            //if (upsertFolderInputModel.StoreId == Guid.Empty || upsertFolderInputModel.StoreId == null)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = string.Format(ValidationMessages.NotEmptyStoreId)
            //    });
            //}

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertFolderDescription(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if ((upsertFolderInputModel.FolderReferenceId == Guid.Empty || upsertFolderInputModel.FolderReferenceId == null) && (upsertFolderInputModel.FolderReferenceTypeId == Guid.Empty || upsertFolderInputModel.FolderReferenceTypeId == null))
            {
                if (upsertFolderInputModel.FolderId == Guid.Empty || upsertFolderInputModel.FolderId == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(ValidationMessages.NotEmptyFolderId)
                    });
                }
            }

            if (upsertFolderInputModel.FolderId == Guid.Empty || upsertFolderInputModel.FolderId == null)
            {
                if (upsertFolderInputModel.FolderReferenceId == Guid.Empty || upsertFolderInputModel.FolderReferenceId == null)
                {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = string.Format(ValidationMessages.NotEmptyFolderReferenceId)
                        });
                }

                if (upsertFolderInputModel.FolderReferenceTypeId == Guid.Empty || upsertFolderInputModel.FolderReferenceTypeId == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(ValidationMessages.NotEmptyFolderReferenceTypeId)
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertUploadFile(UpsertUploadFileInputModel upsertUploadFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(upsertUploadFileInputModel.FilePath))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFilePath)
                });
            }

            if (string.IsNullOrEmpty(upsertUploadFileInputModel.FileExtension))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileExtension)
                });
            }

            if (string.IsNullOrEmpty(upsertUploadFileInputModel.FileName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileName)
                });
            }
            return validationMessages.Count <= 0;
        }
    }
}
