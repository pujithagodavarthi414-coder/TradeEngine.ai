using Btrak.Models;
using Btrak.Models.MasterData.FeedbackTypeModel;
using BTrak.Common;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.MasterDataValidationHelper.FeedbackType
{
    public class UpsertFeedbackTypeValidationHelper
    {
        public static bool UpsertFeedbackTypeValidation(UpsertFeedbackTypeModel upsertFeedbackTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessageses)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Feebdback form Type", "upsertFeedbackTypeModel", upsertFeedbackTypeModel, "UpsertFeedbackForm Api"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessageses);

            if (string.IsNullOrEmpty(upsertFeedbackTypeModel.FeedbackTypeName))
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFeedbackTypeName
                });
            }

            if (!string.IsNullOrEmpty(upsertFeedbackTypeModel.FeedbackTypeName) && upsertFeedbackTypeModel.FeedbackTypeName.Length > 50)
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FeedbackTypeNameLengthExceeded
                });
            }

            return validationMessageses.Count <= 0;
        }
    }
}