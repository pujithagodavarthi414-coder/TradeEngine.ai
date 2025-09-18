using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.BillingManagement
{
    public class EstimateValidations
    {
        public static bool ValidateUpsertEstimate(UpsertEstimateInputModel upsertEstimateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (String.IsNullOrEmpty(upsertEstimateInputModel.ClientId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyClientId
                });
            }

            if (String.IsNullOrEmpty(upsertEstimateInputModel.EstimateNumber))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyEstimateNumber
                });
            }

            if ((!String.IsNullOrEmpty(upsertEstimateInputModel.EstimateNumber)) && upsertEstimateInputModel.EstimateNumber.Length > 50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceededEstimateNumber
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
