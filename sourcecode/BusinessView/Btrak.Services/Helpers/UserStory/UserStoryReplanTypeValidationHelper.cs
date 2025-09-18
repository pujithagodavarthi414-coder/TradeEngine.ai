using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Status;
using BTrak.Common;

namespace Btrak.Services.Helpers.UserStory
{
    public class UserStoryReplanTypeValidationHelper
    {
        public static bool UpsertUserStoryReplanType(UpsertUserStoryReplanTypeInputModel upsertUserStoryReplanTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserStoryReplanType", "upsertUserStoryReplanTypeInputModel", upsertUserStoryReplanTypeInputModel, "UserStory Replan Type Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(upsertUserStoryReplanTypeInputModel.ReplanTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReplanTypeName
                });
            }

            if (upsertUserStoryReplanTypeInputModel.ReplanTypeName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForReplanTypeName
                });
            }
            return validationMessages.Count <= 0;
        }

    }
}
