using Btrak.Models;
using Btrak.Models.User;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Btrak.Dapper.Dal.Models;

namespace Btrak.Services.Helpers
{
    public class UserValidationHelpers
    {
        public static bool UpsertUserValidation(UserInputModel userModel, LoggedInContext loggedInContext,  List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserValidation", "userModel", userModel, "User Validation Helpers"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(userModel.FirstName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFirstName)
                });
            }

            if (string.IsNullOrEmpty(userModel.SurName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptySurName)
                });
            }

            if (string.IsNullOrEmpty(userModel.Email))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyEmail)
                });
            }

            if (userModel.UserId != null && string.IsNullOrEmpty(userModel.Password))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyPassword)
                });
            }

            if (string.IsNullOrEmpty(userModel.RoleId))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyRoleId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool UpsertUserProfileValidation(UserProfileInputModel userProfileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserValidation", "userProfileInputModel", userProfileInputModel, "User Validation Helpers"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(userProfileInputModel.FirstName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyFirstName)
                });
            }

            if (string.IsNullOrEmpty(userProfileInputModel.SurName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptySurName)
                });
            }

            if (string.IsNullOrEmpty(userProfileInputModel.Email))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyEmail)
                });
            }

            return validationMessages.Count <= 0;
        }


        public static bool GetUserByIdValidation(Guid? userId, LoggedInContext loggedInContext,   List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetUserByIdValidation","userId", userId, "UserValidation Helpers"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (userId == Guid.Empty || userId == null)
            {
                validationMessages.Add(new ValidationMessage()
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyUserId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ChangePasswordValidation(UserPasswordResetModel changePasswordModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ChangePasswordValidation", "changePasswordModel", changePasswordModel, "User Validation Helpers"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (changePasswordModel.Type == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyType
                });
            }

            /* Type = 1 for change password for user other than logged user */
            if (changePasswordModel.Type == AppConstants.OtherThanLoggedUserType)
            {
                if (changePasswordModel.UserId == null || changePasswordModel.UserId == Guid.Empty)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyUserId
                    });
                }
            }

            /* Type = 2 for change password for logged user */
            if (changePasswordModel.Type == AppConstants.LoggedUserType)
            {
                if (string.IsNullOrEmpty(changePasswordModel.OldPassword))
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyPassword
                    });
                }
            }

            if (string.IsNullOrEmpty(changePasswordModel.NewPassword))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyNewPassword
                });
            }

            if (string.IsNullOrEmpty(changePasswordModel.ConfirmPassword))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyConfirmPassword
                });
            }

            if (changePasswordModel.NewPassword != changePasswordModel.ConfirmPassword)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotMatchNewPasswordConfirmPassword
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool IsUserExistedValidation(string email, string password, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered IsUserExistedValidation , Email is " + email + ", password is " + password);

            if (string.IsNullOrEmpty(email))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmail
                });
            }

            if (string.IsNullOrEmpty(password))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPassword
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool EmailValidation(string email, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered IsUserExistedValidation , Email is " + email);

            if (string.IsNullOrEmpty(email))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEmail
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ResetPasswordValidation(UserPasswordResetModel resetPasswordModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ResestPasswordValidation", "resetPasswordModel", resetPasswordModel, "User Validation Helpers"));

            if (resetPasswordModel.ResetGuid == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyResetGuid
                });
            }

            if (string.IsNullOrEmpty(resetPasswordModel.NewPassword))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPassword
                });
            }

            if (string.IsNullOrEmpty(resetPasswordModel.ConfirmPassword))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyConfirmPassword
                });
            }

            if (resetPasswordModel.NewPassword != resetPasswordModel.ConfirmPassword)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotMatchNewPasswordConfirmPassword
                });
            }

            var passwordRegularExpression = new Regex("((?=.*\\d)(?=.*[A-Z])(?=.*[a-z])(?=.*\\W).{8,8})");

            if (!passwordRegularExpression.IsMatch(resetPasswordModel.NewPassword))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PasswordNotStrong
                });
            }   

            return validationMessages.Count <= 0;
        }

        public static bool ResetGuidValidation(Guid? resetGuid, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ResetGuidValidation", "resetGuid", resetGuid, "User Validation Helpers"));

            if (resetGuid == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyResetGuid
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}

