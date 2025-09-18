using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Goals;
using BTrak.Common;

namespace Btrak.Services.Helpers.Goals
{
    public class GoalReplanValidations
    {
        public static bool ValidateInsertGoalReplan(GoalReplanUpsertInputModel goalReplanUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (goalReplanUpsertInputModel.GoalId == Guid.Empty || goalReplanUpsertInputModel.GoalId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalId
                });
            }

            if (goalReplanUpsertInputModel.GoalReplanTypeId == Guid.Empty || goalReplanUpsertInputModel.GoalReplanTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyGoalReplanTypeId
                });
            }

            if (goalReplanUpsertInputModel.Reason?.Length > AppConstants.InputWithMaxSize800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForReason
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
