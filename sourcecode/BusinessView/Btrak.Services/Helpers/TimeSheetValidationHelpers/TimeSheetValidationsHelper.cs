using System;
using System.Collections.Generic;
using Btrak.Models;
using BTrak.Common;
using Btrak.Models.TimeSheet;

namespace Btrak.Services.Helpers.TimeSheetValidationHelpers
{
    public class TimeSheetValidationsHelper
    {
        public static List<ValidationMessage> CheckUpsertTimeSheetValidationMessages(TimeSheetManagementInputModel timeSheetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckUpsertTimeSheetValidationMessages", "TimeSheetValidationsHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
          
            if (timeSheetModel.UserId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserId
                });
                return null;
            }

            if (timeSheetModel.Date == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDate
                });
            }
            return validationMessages;
        }

        public static List<ValidationMessage> CheckGetEnableOrDisableTimeSheetButtonDetailsValidationMessages(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckGetEnableOrDisableTimeSheetButtonDetailsValidationMessages", "TimeSheetValidationsHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (userId == Guid.Empty || userId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserId
                });
            }
            return validationMessages;
        }

        public static List<ValidationMessage> CheckTimeSheetManagementPermissionModelValidationMessages(TimeSheetManagementPermissionInputModel timeSheetPermissionsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckTimeSheetManagementPermissionModelValidationMessages", "TimeSheetValidationsHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (timeSheetPermissionsInputModel.UserId == Guid.Empty || timeSheetPermissionsInputModel.UserId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserId
                });
                return null;
            }

            if (timeSheetPermissionsInputModel.Date == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDate
                });
                return null;
            }

            if (timeSheetPermissionsInputModel.Duration == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDuration
                });
            }
            if (timeSheetPermissionsInputModel.PermissionReasonId == null || timeSheetPermissionsInputModel.PermissionReasonId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPermissionReasonId
                });
            }
            return validationMessages;
        }

        public static bool CheckUpsertUserPunchCardValidationMessages(UpsertUserPunchCardInputModel upsertUserPunchCardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckUpsertUserPunchCardValidationMessages", "TimeSheetValidationsHelper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (upsertUserPunchCardInputModel.ButtonTypeId == null || upsertUserPunchCardInputModel.ButtonTypeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserPunchCardButtonTypeId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
