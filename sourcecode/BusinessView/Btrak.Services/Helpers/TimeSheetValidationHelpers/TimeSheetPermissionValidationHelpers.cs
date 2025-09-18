using Btrak.Models;
using System.Collections.Generic;
using Btrak.Models.TimeSheet;
using BTrak.Common;

namespace Btrak.Services.Helpers.TimeSheetValidationHelpers
{
    public class TimeSheetPermissionValidationHelpers
    {
        public static List<ValidationMessage> CheckPermissionReasonsValidationMessages(TimeSheetPermissionReasonInputModel timeSheetPermissionReasonInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckGetEnableOrDisableTimeSheetButtonDetailsValidationMessages", "TimeSheetValidationsHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(timeSheetPermissionReasonInputModel.PermissionReason))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPermissionReason
                });
            }
            return validationMessages;
        }
    }
}
