using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Status;
using BTrak.Common;

namespace Btrak.Services.Helpers.BugPriorityValidationHelpers
{
    public class BugPriorityValidationHelper
    {
        public static bool UpsertBugPriorityValidation(UpsertBugPriorityInputModel upsertBugPriorityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertBugPriorityValidation", "upsertBugPriorityInputModel", upsertBugPriorityInputModel, "Bug Priority Validation Helpers"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(upsertBugPriorityInputModel.PriorityName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPriorityName
                });
            }

            if (upsertBugPriorityInputModel.PriorityName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForPriorityName
                });
            }

            if (string.IsNullOrEmpty(upsertBugPriorityInputModel.Color))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyColor
                });
            }

            return validationMessages.Count <= 0;
        }
       
    }
}
