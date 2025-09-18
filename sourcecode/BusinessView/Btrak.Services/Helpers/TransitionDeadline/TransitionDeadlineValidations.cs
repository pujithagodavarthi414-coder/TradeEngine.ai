using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.TransitionDeadline;
using BTrak.Common;

namespace Btrak.Services.Helpers.TransitionDeadline
{
    public class TransitionDeadlineValidations
    {
        public static bool ValidateTransitionDeadlineFoundWithId(Guid? transitionDeadlineId, List<ValidationMessage> validationMessages, TransitionDeadlineApiReturnModel transitionDeadlineSpReturnModel)
        {
            if (transitionDeadlineSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage =
                        string.Format(ValidationMessages.NotFoundTransitionDeadlineWithTheId, transitionDeadlineId)
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateUpsertTransitionDeadline(TransitionDeadlineUpsertInputModel transitionDeadlineUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(transitionDeadlineUpsertInputModel.Deadline))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyDeadlineName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateTransitionDeadlineById(Guid? transitionDeadlineId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (transitionDeadlineId == Guid.Empty || transitionDeadlineId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyTransitionDeadlineId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
