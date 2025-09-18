using System;
using System.Collections.Generic;
using Btrak.Models;
using BTrak.Common;

namespace Btrak.Services.Helpers.AccessibilityValidationHelpers
{
    public class AccessibilityValidationHelper
    {
        public static List<ValidationMessage> IfUserAccessibleToFeatureCheckValidation(Guid? userId, Guid? featureId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "If User Accessible To Feature CheckValidation", "Accessibility Validation Helpers"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (userId == null || userId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "If User Accessible To Feature CheckValidation", "Accessibility Validation Helpers"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserId
                });
            }
            if (featureId == null || featureId == Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "If User Accessible To Feature CheckValidation", "Accessibility Validation Helpers"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFeatureId
                });
            }
            return validationMessages;
        }
    }
}
