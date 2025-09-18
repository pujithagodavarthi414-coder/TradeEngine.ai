using Btrak.Models;
using Btrak.Models.CustomTags;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Helpers.CustomTags
{
    public static class CustomTagsValidations
    {
        public static bool ValidateUpsertCustomFieldForm(CustomTagsInputModel customTagsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (customTagsInputModel.ReferenceId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReferenceId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertTagFieldForm(CustomTagsInputModel customTagsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(customTagsInputModel.Tag))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTagName
                });
            }

            return validationMessages.Count <= 0;
        }

    }
}
