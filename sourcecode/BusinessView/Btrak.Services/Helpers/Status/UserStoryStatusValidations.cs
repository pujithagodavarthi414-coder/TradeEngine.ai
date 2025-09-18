using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Status;
using BTrak.Common;

namespace Btrak.Services.Helpers.Status
{
    public class UserStoryStatusValidations
    {
        public static bool ValidateUpsertStatus(UserStoryStatusUpsertInputModel userStoryStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(userStoryStatusUpsertInputModel.UserStoryStatusName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyStatusName
                });
            }

            if (string.IsNullOrEmpty(userStoryStatusUpsertInputModel.UserStoryStatusColor))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyStatusColor
                });
            }

            if (userStoryStatusUpsertInputModel.UserStoryStatusName?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForStatusName
                });
            }

            if (userStoryStatusUpsertInputModel.UserStoryStatusName?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForStatusColor
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateStatusById(Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (statusId == Guid.Empty || statusId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyStatusId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateStatusFoundWithId(Guid? statusId, List<ValidationMessage> validationMessages, UserStoryStatusApiReturnModel userStoryStatusSpReturnModel)
        {
            if (userStoryStatusSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundStatusWithTheId, statusId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
