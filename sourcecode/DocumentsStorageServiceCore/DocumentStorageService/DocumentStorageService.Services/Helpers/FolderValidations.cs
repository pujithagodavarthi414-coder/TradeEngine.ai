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
    public class FolderValidations
    {
        public static bool ValidateUpsertFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (upsertFolderInputModel.FolderReferenceTypeId != null && upsertFolderInputModel.FolderReferenceTypeId.ToString().ToUpper() !=
                "DF52BB58-F895-4C7F-B0C1-5D3C5737CC3E")
            {
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

            }

            if (upsertFolderInputModel.StoreId == null && upsertFolderInputModel.FolderReferenceId == null &&
                upsertFolderInputModel.FolderReferenceTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyStoreId)
                });
            }
            return validationMessages.Count <= 0;
        }

    }
}
