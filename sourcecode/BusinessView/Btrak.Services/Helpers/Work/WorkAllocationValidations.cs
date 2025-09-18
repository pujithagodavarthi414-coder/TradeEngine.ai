using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Work;
using BTrak.Common;

namespace Btrak.Services.Helpers.Work
{
    public class WorkAllocationValidations
    {
        public static bool ValidateWorkAllocationByProjectId(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (projectId == null || projectId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyProjectId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateEmployeeWorkAllocation(List<ValidationMessage> validationMessages, List<WorkAllocationApiReturnModel> workAllocationSpReturnModels)
        {
            if (workAllocationSpReturnModels == null || workAllocationSpReturnModels.Count <= 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.WorkAllocationDetailsNotFound
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
