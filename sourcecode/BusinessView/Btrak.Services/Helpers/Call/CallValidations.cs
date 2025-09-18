using Btrak.Models;
using Btrak.Models.Comments;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Btrak.Services.Helpers.Comments
{
    public class CallValidations
    {
        public static bool ValidateCallFeedbackUpsertInputModel(CallFeedbackUserInputModel callFeedbackModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            var comments = GetSubStringFromHtml(callFeedbackModel.CallDescription, callFeedbackModel.CallDescription.Length);
            comments = comments.Trim();

            if (string.IsNullOrEmpty(comments))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyComment
                });
            }

            if (comments.Length > AppConstants.InputWithMaxSize1000)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForComment
                });
            }

            if (callFeedbackModel.ReceiverId == null || callFeedbackModel.ReceiverId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyReceiverId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateCommentById(Guid? commentId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (commentId == Guid.Empty || commentId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyCommentId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateCommentByReceiverId(Guid? receiverId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (receiverId == Guid.Empty || receiverId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyReceiverId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static string GetSubStringFromHtml(string html, int length)
        {
            if (!string.IsNullOrEmpty(html))
            {
                var result = Regex.Replace(html, @"<[^>]*>|&nbsp;", string.Empty);
                if (result.Length > length)
                {
                    result = result.Substring(0, length) + "...";
                }
                return result;
            }
            return string.Empty;
        }
    }
}
