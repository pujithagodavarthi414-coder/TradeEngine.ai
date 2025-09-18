using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.LeaveManagement;
using BTrak.Common;

namespace Btrak.Services.Helpers.EmployeeAbsenceValidations
{
    public class EmployeeAbsenceValidationHelper
    {
        public static List<ValidationMessage> CheckValidationForEmployeeAbsence(LeaveManagementInputModel leaveManagementInputModel,LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered into CheckValidationForEmployeeAbsence ");
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (leaveManagementInputModel.UserId == null || leaveManagementInputModel.UserId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserId
                });
            }
            if (leaveManagementInputModel.LeaveTypeId == null || leaveManagementInputModel.LeaveTypeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLeaveTypeId
                });
            }
            if (leaveManagementInputModel.FromLeaveSessionId == null || leaveManagementInputModel.FromLeaveSessionId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotFoundLeaveSessionId
                });
            }
            if (leaveManagementInputModel.LeaveDateFrom == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotFoundLeaveSessionId
                });
            }
            if (string.IsNullOrEmpty(leaveManagementInputModel.LeaveReason))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLeaveReason
                });
            }

            return validationMessages;
        }
    }
}
