using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.LeaveType;
using BTrak.Common;

namespace Btrak.Services.Helpers.LeaveTypeValidationHelpers
{
    public class LeaveTypeValidationHelper
    {
        public static List<ValidationMessage> CheckValidationForUpsertLeaveType(LeaveTypeInputModel leaveTypeInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered into CheckValidationForUpsertLeaveType in LeaveManagementValidationHelper");
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(leaveTypeInputModel.LeaveTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyLeaveTypeName)
                });
                return null;
            }
            return validationMessages;
        }

        public static List<ValidationMessage> CheckLeaveTypeByIdValidationMessage(Guid? leaveTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckGetFoodOrderByIdValidationMessages", "FoodOrderManagementValidationHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (leaveTypeId == Guid.Empty || leaveTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyLeaveTypeId)
                });
                return null;
            }
            return validationMessages;
        }
    }
}
