using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.GenericForm;
using BTrak.Common;

namespace Btrak.Services.Helpers.GenericForm
{
    public class GenericFormValidations
    {
        public static bool ValidateUpsertGenericForms(GenericFormUpsertInputModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            
            if (string.IsNullOrEmpty(genericFormModel.FormName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FormNameNotFound
                });
            }

            if (genericFormModel.FormName?.Length > 100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FormNameMaxLength
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateGenericFormsByTypeId(Guid typeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (typeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FormTypeIdNotFound
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
