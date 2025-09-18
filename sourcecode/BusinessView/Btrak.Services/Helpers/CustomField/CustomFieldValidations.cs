using Btrak.Models;
using Btrak.Models.CustomFields;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Helpers
{
   public static class CustomFieldValidations
    {
        public static bool ValidateUpsertCustomFieldForm(UpsertCustomFieldModel customFieldUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (customFieldUpsertInputModel.ModuleTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyModuleTypeId
                });
            }

            if (customFieldUpsertInputModel.ReferenceId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReferenceId
                });
            }

            if (customFieldUpsertInputModel.ReferenceTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReferenceTypeId
                });
            }

            if (string.IsNullOrEmpty(customFieldUpsertInputModel.FormName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFieldName
                });
            }

            if(!string.IsNullOrEmpty(customFieldUpsertInputModel.FormName) && customFieldUpsertInputModel.FormName.Length >100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FieldNameCannotExceed100Characters
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetCustomFieldByIdValidations(Guid? customFieldId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (customFieldId == Guid.Empty || customFieldId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyCustomFieldId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpdateCustomFieldForm(UpsertCustomFieldModel customFieldUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);


            if (customFieldUpsertInputModel.ModuleTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyModuleTypeId
                });
            }

            if (customFieldUpsertInputModel.ReferenceId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReferenceId
                });
            }
            return validationMessages.Count <= 0;
        }
    }
}
