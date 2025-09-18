using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;

namespace DocumentStorageService.Services.Helpers
{
   public  class StoreManagementHelper
    {
        public static bool ValidateUpsertStore(StoreInputModel storeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertStore", "storeInputModel", storeInputModel, "Store Management Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(storeInputModel.StoreName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyStoreName
                });
            }

            if (!string.IsNullOrEmpty(storeInputModel.StoreName))
            {
                if (storeInputModel.StoreName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.StoreLengthExceeded
                    });
                }
            }

            return validationMessages.Count <= 0;
        }
    }
}
