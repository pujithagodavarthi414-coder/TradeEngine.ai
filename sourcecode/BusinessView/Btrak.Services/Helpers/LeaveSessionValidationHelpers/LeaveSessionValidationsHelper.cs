using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.LeaveSessions;
using BTrak.Common;

namespace Btrak.Services.Helpers.LeaveSessionValidationHelpers
{
    public class LeaveSessionValidationsHelper
    {
        public static bool UpsertLeaveSessionValidation(LeaveSessionsInputModel leaveSessionInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertShiftTimingValidation", "leaveSessionInput", leaveSessionInput, "LeaveSession Validations Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(leaveSessionInput.LeaveSessionName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyLeaveSessionName)
                });
            }

            if (!string.IsNullOrEmpty(leaveSessionInput.LeaveSessionName))
            {
                if (leaveSessionInput.LeaveSessionName.Length > 50)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(ValidationMessages.leaveSessionNameLengthExceeded)
                    });
                }
            }

            return validationMessages.Count <= 0;
        }

        public static bool LeaveSessionsByIdValidation(Guid? leaveSessionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered to LeaveSessionsByIdValidation." + "leaveSessionId=" + leaveSessionId + ", loggedInContext=" + loggedInContext.LoggedInUserId);
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (leaveSessionId == Guid.Empty || leaveSessionId == null)
            {
                validationMessages.Add(new ValidationMessage()
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyLeaveSessionId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
