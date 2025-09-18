using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Services.Helpers
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

        public static bool ValidateDeleteFile(Guid? fileId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
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
            if (string.IsNullOrEmpty(fileInputModel.FileName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileName)
                });
            }
            if (!string.IsNullOrEmpty(fileInputModel.FileName) && fileInputModel.FileName.Length > 800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.ExceededFileName)
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


    }
}
