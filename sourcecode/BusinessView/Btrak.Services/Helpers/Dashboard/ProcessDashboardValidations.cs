using System;
using System.Collections.Generic;
using Btrak.Models;
using BTrak.Common;

namespace Btrak.Services.Helpers.Dashboard
{
    public class ProcessDashboardValidations
    {
        public static bool ValidateGoalsOverAllStatusByDashboardId(int? dashboardId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (dashboardId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProcessDashboardId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateGetProcessDashboardByProjectId(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (projectId == null || projectId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProjectId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
