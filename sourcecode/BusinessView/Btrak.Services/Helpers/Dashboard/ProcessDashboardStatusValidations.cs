using Btrak.Models.Dashboard;
using System;
using System.Collections.Generic;
using Btrak.Models;
using BTrak.Common;

namespace Btrak.Services.Helpers.Dashboard
{
    public class ProcessDashboardStatusValidations
    {
        public static bool ValidateUpsertProcessDashboardStatus(ProcessDashboardStatusUpsertInputModel upsertProcessDashboardStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(upsertProcessDashboardStatusInputModel.ProcessDashboardStatusName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProcessDashboardStatusName
                });
            }

            if (string.IsNullOrEmpty(upsertProcessDashboardStatusInputModel.ProcessDashboardStatusHexaValue))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProcessDashboardStatusColor
                });
            }

            if (upsertProcessDashboardStatusInputModel.ProcessDashboardStatusName?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForProcessDashboardStatusName
                });
            }

            if (upsertProcessDashboardStatusInputModel.ProcessDashboardStatusHexaValue?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForProcessDashboardStatusColor
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateStatusById(Guid? processDashboardStatusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (processDashboardStatusId == Guid.Empty || processDashboardStatusId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyProcessDashboardStatusId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateProcessDashboardStatusFoundWithId(Guid? processDashboardStatusId, List<ValidationMessage> validationMessages, ProcessDashboardStatusApiReturnModel processDashboardStatusSpReturnModel)
        {
            if (processDashboardStatusSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundProcessDashboardStatusWithTheId, processDashboardStatusId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
