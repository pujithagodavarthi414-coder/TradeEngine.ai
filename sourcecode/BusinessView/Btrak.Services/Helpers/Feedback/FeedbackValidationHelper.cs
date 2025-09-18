using Btrak.Models;
using Btrak.Models.Feedback;
using Btrak.Models.UserStory;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Helpers.Feedback
{
    public class FeedbackValidationHelper
    {
        public static bool UpsertFeedbackValidation(FeedbackSubmitModel upsertFeedbackModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessageses)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Feebdback form", "upsertFeedbackModel", upsertFeedbackModel, "UpsertFeedbackForm Api"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessageses);

            if (string.IsNullOrEmpty(upsertFeedbackModel.Description))
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFeedbackDescription
                });
            }
            if (!string.IsNullOrEmpty(upsertFeedbackModel.Description) && upsertFeedbackModel.Description.Length > AppConstants.InputWithMaxSize800)
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForComment
                });
            }
            return validationMessageses.Count <= 0;
        }
        
        public static bool GetFeedbackByIdValidations(Guid? feedbackId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessageses)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get feedback by Id", "feedbackId", feedbackId, "GetFeedbackById Api"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessageses);

            if (feedbackId == Guid.Empty || feedbackId == null)
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFeedbackId
                });
            }
            return validationMessageses.Count <= 0;
        }

        public static bool UpsertBugFeedbackValidation(UserStoryUpsertInputModel bugInsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessageses)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Bug Feebdback", "bugInsertModel", bugInsertModel, "UpsertFeedbackForm Api"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessageses);

            if (string.IsNullOrEmpty(bugInsertModel.UserStoryName))
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBugTitle
                });
            }
            if (!string.IsNullOrEmpty(bugInsertModel.UserStoryName) && bugInsertModel.UserStoryName.Length > AppConstants.InputWithMaxSize800)
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForBugTitle
                });
            }
            if (string.IsNullOrEmpty(bugInsertModel.Description))
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyBugDescription
                });
            }
            return validationMessageses.Count <= 0;
        }

    }
}
