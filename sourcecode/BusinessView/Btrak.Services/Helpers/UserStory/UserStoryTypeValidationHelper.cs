using System.Collections.Generic;
using Btrak.Models;
using BTrak.Common;
using Btrak.Models.MasterData;

namespace Btrak.Services.Helpers.UserStory
{
    public class UserStoryTypeValidationHelper
    {
        public static bool UpsertUserStoryType(UpsertUserStoryTypeInputModel upsertUserStoryTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserStoryType", "upsertUserStoryTypeInputModel", upsertUserStoryTypeInputModel, "UserStory Type Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(upsertUserStoryTypeInputModel.UserStoryTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReplanTypeName
                });
            }

            if (upsertUserStoryTypeInputModel.UserStoryTypeName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForReplanTypeName
                });
            }
            if (string.IsNullOrEmpty(upsertUserStoryTypeInputModel.ShortName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyShortName
                });
            }

            if (upsertUserStoryTypeInputModel.ShortName?.Length > AppConstants.InputWithMaxSize50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForShortName
                });
            }
            return validationMessages.Count <= 0;
        }

    }
}
