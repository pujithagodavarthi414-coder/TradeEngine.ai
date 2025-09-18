using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.ConsiderHour;
using BTrak.Common;

namespace Btrak.Services.Helpers.ConsiderHour
{
    public static class ConsiderHourValidations
    {
        public static bool ValidateUpsertConsiderHour(ConsiderHourUpsertInputModel considerHourUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(considerHourUpsertInputModel.ConsiderHourName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyConsiderHourName
                });
            }

            if (considerHourUpsertInputModel.ConsiderHourName?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForConsiderHourName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateConsiderHourById(Guid? considerHourId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (considerHourId == Guid.Empty || considerHourId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyConsiderHourId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateConsiderHourFoundWithId(Guid? considerHourId, List<ValidationMessage> validationMessages, ConsiderHourApiReturnModel considerHourSpReturnModel)
        {
            if (considerHourSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundConsiderHourWithTheId, considerHourId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
