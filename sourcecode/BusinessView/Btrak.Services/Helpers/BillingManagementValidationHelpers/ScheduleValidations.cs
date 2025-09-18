using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.BillingManagement
{
    public class ScheduleValidations
    {
        public static bool ValidateUpsertInvoiceSchedule(UpsertInvoiceScheduleInputModel upsertscheduleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (upsertscheduleInputModel.InvoiceId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyInvoiceId
                });
            }

            if (upsertscheduleInputModel.ScheduleName == String.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyScheduleName
                });
            }
            if (upsertscheduleInputModel.ScheduleName == String.Empty && upsertscheduleInputModel.ScheduleName.Length > AppConstants.InputWithMaxSize100)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForScheduleName
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
