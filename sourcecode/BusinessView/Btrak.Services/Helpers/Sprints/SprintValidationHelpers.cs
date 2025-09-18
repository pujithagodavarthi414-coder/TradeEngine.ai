using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.Sprints
{
    public class SprintValidationHelpers
    {
        public static bool GetSprintByIdValidations(Guid? sprintId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (sprintId == Guid.Empty || sprintId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptySprintId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
