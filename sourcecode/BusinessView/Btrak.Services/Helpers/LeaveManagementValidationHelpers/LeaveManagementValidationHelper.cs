using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.LeaveManagement;
using BTrak.Common;

namespace Btrak.Services.Helpers.LeaveManagementValidationHelpers
{
    public class LeaveManagementValidationHelper
    {
        public static List<ValidationMessage> CheckValidationForUpsertLeaves(LeaveManagementInputModel leaveManagementInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered into CheckValidationForUpsertLeaves in LeaveManagementValidationHelper");
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (leaveManagementInputModel.LeaveTypeId == Guid.Empty || leaveManagementInputModel.LeaveTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.LeaveTypeRequired
                });
                return null;
            }
            
            if (leaveManagementInputModel.LeaveDateFrom == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.LeaveDateFromRequired
                });
                return null;
            }

            if (leaveManagementInputModel.LeaveDateTo == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.LeaveDateToRequired
                });
            }

            if (leaveManagementInputModel.LeaveDateFrom != null && leaveManagementInputModel.LeaveDateTo != null)
            {
                int value = DateTime.Compare((DateTime)leaveManagementInputModel.LeaveDateFrom, (DateTime)leaveManagementInputModel.LeaveDateTo);

                if (value > 0)
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.LeaveDateFromIsLaterThanLeaveDateTo
                    });
            }

            if (leaveManagementInputModel.FromLeaveSessionId == null || leaveManagementInputModel.FromLeaveSessionId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FromLeaveSessionRequired
                });
            }
            if (leaveManagementInputModel.ToLeaveSessionId == null || leaveManagementInputModel.ToLeaveSessionId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ToLeaveSessionRequired
                });
            }
            //if (leaveManagementInputModel.LeaveReason == null)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = ValidationMessages.LeaveReasonRequired
            //    });
            //}

            return validationMessages;
        }

        public static List<ValidationMessage> CheckGetLeaveDetailByIdValidationMessages(Guid? leaveApplicationId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CheckGetLeaveDetailByIdValidationMessages", "FoodOrderManagementValidationHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (leaveApplicationId == Guid.Empty || leaveApplicationId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLeaveApplicationId
                });
            }
            return validationMessages;
        }

        public static bool DeleteLeave(DeleteLeaveModel deleteLeaveModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteLeave", "deleteLeaveModel", deleteLeaveModel, "Leave Management Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (deleteLeaveModel == null)
            {
                deleteLeaveModel = new DeleteLeaveModel();
            }

            if (deleteLeaveModel.LeaveId == null || deleteLeaveModel.LeaveId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLeaveId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool DeleteLeavePermission(DeleteLeavePermissionModel deleteLeavePermissionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteLeavePermission", "deleteLeavePermissionModel", deleteLeavePermissionModel, "Leave Management Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (deleteLeavePermissionModel == null)
            {
                deleteLeavePermissionModel = new DeleteLeavePermissionModel();
            }

            if (deleteLeavePermissionModel.PermissionId == null || deleteLeavePermissionModel.PermissionId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyLeavePermissionId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
