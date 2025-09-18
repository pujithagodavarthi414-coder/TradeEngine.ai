using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.UserStory;
using BTrak.Common;

namespace Btrak.Services.Helpers.UserStory
{
    public class UserStoryReviewCommentValidations
    {
        public static bool ValidateUpsertUserStoryReviewComment(UserStoryReviewCommentUpsertInputModel userStoryReviewCommentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(userStoryReviewCommentUpsertInputModel.Comment))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryReviewComment
                });
            }

            if (userStoryReviewCommentUpsertInputModel.Comment?.Length > AppConstants.InputWithMaxSize1000)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForUserStoryReviewComment
                });
            }

            if (userStoryReviewCommentUpsertInputModel.UserStoryId == Guid.Empty || userStoryReviewCommentUpsertInputModel.UserStoryId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryId
                });
            }

            if (userStoryReviewCommentUpsertInputModel.UserStoryReviewStatusId == Guid.Empty || userStoryReviewCommentUpsertInputModel.UserStoryReviewStatusId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserStoryReviewStatusId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
