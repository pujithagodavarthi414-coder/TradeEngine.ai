using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Helpers.BillingManagement
{
    public class InvoiceValidations
    {
        public static bool ValidateUpsertInvoice(UpsertInvoiceInputModel upsertInvoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (String.IsNullOrEmpty(upsertInvoiceInputModel.ClientId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyClientId
                });
            }

            if (String.IsNullOrEmpty(upsertInvoiceInputModel.InvoiceNumber))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyInvoiceNumber
                });
            }

            if ((!String.IsNullOrEmpty(upsertInvoiceInputModel.InvoiceNumber)) && upsertInvoiceInputModel.InvoiceNumber.Length > 50)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceededInvoiceNumber
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateInsertInvoiceLogPayment(InvoicePaymentLogModel invoicePaymentLogModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (String.IsNullOrEmpty(invoicePaymentLogModel.InvoiceId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyInvoiceId
                });
            }

            if (String.IsNullOrEmpty(invoicePaymentLogModel.PaidAccountToId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPaidAccountToId
                });
            }

            if (String.IsNullOrEmpty(invoicePaymentLogModel.PaymentMethodId.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyPaymentMethodId
                });
            }

            if ((!String.IsNullOrEmpty(invoicePaymentLogModel.Notes)) && invoicePaymentLogModel.Notes.Length > 800)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceededNotes
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
