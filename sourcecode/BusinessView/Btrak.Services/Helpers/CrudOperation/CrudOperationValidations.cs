using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.CrudOperation;
using BTrak.Common;

namespace Btrak.Services.Helpers.CrudOperation
{
    public class CrudOperationValidations
    {
        public static bool ValidateUpsertPermission(string permissionName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(permissionName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyPermissionName)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidatePermissionById(Guid? permissionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (permissionId == Guid.Empty || permissionId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyPermissionId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidatePermissionFoundWithId(Guid? permissionId, List<ValidationMessage> validationMessages, CrudOperationApiReturnModel crudOperationSpReturnModel)
        {
            if (crudOperationSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundPermissionWithTheId, permissionId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
