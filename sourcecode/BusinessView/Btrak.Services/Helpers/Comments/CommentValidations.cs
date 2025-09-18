using Btrak.Models;
using Btrak.Models.Comments;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Btrak.Services.Helpers.Comments
{
    public class CommentValidations
    {
        public static bool ValidateCommentUpsertInputModel(CommentUserInputModel commentModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            var comments = GetSubStringFromHtml(commentModel.Comment, commentModel.Comment.Length);
            comments = comments.Trim();

            if (string.IsNullOrEmpty(comments))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyComment
                });
            }

            if (comments.Length > AppConstants.InputWithMaxSize800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForComment
                });
            }

            if (commentModel.ReceiverId == null || commentModel.ReceiverId == Guid.Empty)
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
