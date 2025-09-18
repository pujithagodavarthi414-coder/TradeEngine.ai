using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.HrDashboard;
using BTrak.Common;

namespace Btrak.Services.Helpers.HrDashboardValidationHelpers
{
    public class HrDashboardValidationHelper
    {
        public static bool EmployeeAttendanceByDayValidation(EmployeeAttendanceSearchInputModel employeeAttendanceSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "EmployeeAttendanceByDayValidation", "date", employeeAttendanceSearchInputModel.Date, "HrDashboard Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (employeeAttendanceSearchInputModel.Date == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDate
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetEmployeeWorkingDaysValidation(EmployeeWorkingDaysSearchCriteriaInputModel employeeWorkingDaysSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "employeeWorkingDaysSearchCriteriaInputModel", "hrDashboardSearchCriteriaInputModel", employeeWorkingDaysSearchCriteriaInputModel, "HrDashboardValidationHelper Api"));
            CommonValidationHelper.ValidateSearchCriteria(loggedInContext, employeeWorkingDaysSearchCriteriaInputModel, validationMessages);

            if (employeeWorkingDaysSearchCriteriaInputModel.Date == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDate
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetEmployeeSpentTimeValidation(Guid? userId, string fromDate, string toDate, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetEmployeeSpentTimeValidation", "HrDashboardValidationHelper"));
            LoggingManager.Debug("Entered GetEmployeeAttendanceByDay with userId " + userId + ", fromDate=" + fromDate + ",toDate=" + toDate);
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(fromDate))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyFromDate
                });
            }

            if (string.IsNullOrEmpty(toDate))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyToDate
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetEmployeeSpentTimeValidation(HrDashboardSearchCriteriaInputModel hrDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetEmployeeSpentTimeValidation", "hrDashboardSearchCriteriaInputModel", hrDashboardSearchCriteriaInputModel, "HrDashboardValidationHelper Api"));
            CommonValidationHelper.ValidateSearchCriteria(loggedInContext, hrDashboardSearchCriteriaInputModel, validationMessages);

            if (hrDashboardSearchCriteriaInputModel.Date == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDate
                });
            }

            if (string.IsNullOrEmpty(hrDashboardSearchCriteriaInputModel.Type))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyType
                });
            }
            
            return validationMessages.Count <= 0;
        }
    }
}
