using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.UserStory;
using BTrak.Common;

namespace Btrak.Services.Helpers.UserStory
{
    public class UserStorySubTypeValidations
    {
        public static bool ValidateUpsertUserStorySubType(UserStorySubTypeUpsertInputModel userStorySubTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(userStorySubTypeUpsertInputModel.UserStorySubTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStorySubTypeName
                });
            }

            if (userStorySubTypeUpsertInputModel.UserStorySubTypeName?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForUserStorySubTypeName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUserStorySubTypeById(Guid? subTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (subTypeId == Guid.Empty || subTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStorySubTypeId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUserStorySubTypeFoundWithId(Guid? subTypeId, List<ValidationMessage> validationMessages, UserStorySubTypeApiReturnModel userStorySubTypeSpReturnModel)
        {
            if (userStorySubTypeSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundUserStorySubTypeWithTheId, subTypeId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
