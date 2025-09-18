using System;
using System.Collections.Generic;
using System.Text;
using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.AccessRights;

namespace DocumentStorageService.Services.Helpers
{
   public  class AccessRightsValidations
    {
        public static bool ValidateAccessFileFile(DocumentRightAccessModel accessRightsModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
           
            if (accessRightsModel.DocumentId == Guid.Empty || accessRightsModel.DocumentId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
