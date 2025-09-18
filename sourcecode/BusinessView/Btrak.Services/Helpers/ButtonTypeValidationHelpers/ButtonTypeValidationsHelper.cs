using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.ButtonType;
using BTrak.Common;

namespace Btrak.Services.Helpers.ButtonTypeValidationHelpers
{
    public class ButtonTypeValidationsHelper
    {
        public static bool UpsertButtonTypeValidation(ButtonTypeInputModel buttonTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertButtonTypeValidation", "buttonTypeInputModel", buttonTypeInputModel, "ButtonTypeValidations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(buttonTypeInputModel.ButtonTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyButtonTypeName
                });
            }

            if (!string.IsNullOrEmpty(buttonTypeInputModel.ButtonTypeName))
            {
                if (buttonTypeInputModel.ButtonTypeName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.ButtonTypeNameExceeded
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetButtonTypeByIdValidation(Guid? buttonTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetButtonTypeByIdValidation", "buttonTypeId", buttonTypeId, "ButtonType Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (buttonTypeId == null || buttonTypeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyButtonTypeId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
