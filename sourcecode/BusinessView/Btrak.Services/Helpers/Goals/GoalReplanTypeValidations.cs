using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Goals;
using BTrak.Common;

namespace Btrak.Services.Helpers.Goals
{
    public class GoalReplanTypeValidations
    {
        public static bool ValidateUpsertGoalReplanType(GoalReplanTypeUpsertInputModel goalReplanTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(goalReplanTypeUpsertInputModel.GoalReplanTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalReplanTypeName
                });
            }

            if (goalReplanTypeUpsertInputModel.GoalReplanTypeName?.Length > AppConstants.InputWithMaxSize500)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForGoalReplanTypeName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateGoalReplanTypeById(Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (statusId == Guid.Empty || statusId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalReplanTypeId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateGoalReplanTypeFoundWithId(Guid? goalReplanTypeId, List<ValidationMessage> validationMessages, GoalReplanTypeApiReturnModel goalReplanTypeSpReturnModel)
        {
            if (goalReplanTypeSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundGoalReplanTypeWithTheId, goalReplanTypeId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
