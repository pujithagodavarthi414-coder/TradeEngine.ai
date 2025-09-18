using Btrak.Models;
using Btrak.Models.MasterData;
using BTrak.Common;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.MasterDataValidationHelper
{
    public class PaymentTypeValidationHelper
    {
        public static bool UpsertPaymentTypeValidation(PaymentTypeUpsertModel paymentTypeUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessageses)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert payment type", "payment type UpsertModel", paymentTypeUpsertModel, "Upsert payment type Validation helper"));

            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessageses);

            if (string.IsNullOrEmpty(paymentTypeUpsertModel.PaymentTypeName))
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPaymentTypeName
                });
            }

            if (!string.IsNullOrEmpty(paymentTypeUpsertModel.PaymentTypeName) && paymentTypeUpsertModel.PaymentTypeName.Length > 50)
            {
                validationMessageses.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.paymentTypeNameLengthExceeded
                });

            }

            return validationMessageses.Count <= 0;
        }
    }
}
