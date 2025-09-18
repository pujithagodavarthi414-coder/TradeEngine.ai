using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Employee;
using BTrak.Common;

namespace Btrak.Services.Helpers.EmployeeValidationHelpers
{
    public class EmployeeValidationHelper
    {
        public static bool UpsertEmployeeValidation(EmployeeInputModel employeeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertEmployeeValidation", "employeeModel", employeeModel, "EmployeeValidationHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeModel.UserId ==  null ||employeeModel.UserId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyUserId)
                });
            }

            if (employeeModel.JobCategoryId == null || employeeModel.JobCategoryId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyJobCategoryId)
                });
            }

            if (employeeModel.DesignationId == null || employeeModel.DesignationId== Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyDesignationId)
                });
            }

            if (employeeModel.EmploymentStatusId == null || employeeModel.EmploymentStatusId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyEmploymentStatusId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetEmployeeByIdValidation(Guid? employeeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeByIdValidation", "employeeId", employeeId, "EmployeeValidationHelper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeId == Guid.Empty || employeeId == null)
            {
                validationMessages.Add(new ValidationMessage()
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyEmployeeId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
