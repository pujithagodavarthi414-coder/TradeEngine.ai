using Btrak.Models;
using Btrak.Models.MasterData;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.MasterDataValidationHelper
{
    public class LeaveStatusValidationHelper
    {
        public static bool UpsertLeaveStatusValidation(LeaveStatusUpsertModel leaveStatusUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessageses)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert leave status", "leaveStatus UpsertModel ", leaveStatusUpsertModel, "Upsert leave status Validation helper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessageses);

            if (string.IsNullOrEmpty(leaveStatusUpsertModel.LeaveStatusName))
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLeaveStatus
                });
            }

            if (!string.IsNullOrEmpty(leaveStatusUpsertModel.LeaveStatusName) && leaveStatusUpsertModel.LeaveStatusName.Length > 50)
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.leaveStatusLengthExceeded
                });

            }

            if (leaveStatusUpsertModel.LeaveStatusId== Guid.Empty)
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLeaveStatusId
                });
            }


            return validationMessageses.Count <= 0;
        }
    }
}
