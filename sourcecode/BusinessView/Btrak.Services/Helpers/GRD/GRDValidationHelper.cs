using Btrak.Models;
using Btrak.Models.GRD;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Helpers.GRD
{
    public class GRDValidationHelper
    {
        public static bool UpsertGRDValidation(GRDInputModel grdInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGRDValidation", "grdInputModel", grdInputModel, "GRD Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(grdInputModel.Name))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyName)
                });
            }

            if (grdInputModel.StartDate == null || grdInputModel.StartDate.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyStartDate)
                });
            }

            if (grdInputModel.EndDate == null || grdInputModel.EndDate.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyEndDate)
                });
            }
            return validationMessages.Count <= 0;
        }

        public static bool UpsertCreditNoteValidation(CreditNoteUpsertInputModel creditNoteUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCreditNoteValidation", "creditNoteUpsertInputModel", creditNoteUpsertInputModel, "GRD Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (creditNoteUpsertInputModel.SiteId == null || creditNoteUpsertInputModel.SiteId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptySiteId)
                });
            }
            if (creditNoteUpsertInputModel.GrdId == null || creditNoteUpsertInputModel.GrdId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyGrdId)
                });
            }
            if (creditNoteUpsertInputModel.Month == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyMonth)
                });
            }
            if (creditNoteUpsertInputModel.StartDate == null || creditNoteUpsertInputModel.StartDate.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyStartDate)
                });
            }
            if (creditNoteUpsertInputModel.EndDate == null || creditNoteUpsertInputModel.EndDate.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyEndDate)
                });
            }
            if (creditNoteUpsertInputModel.Term == null || creditNoteUpsertInputModel.Term.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyTerm)
                });
            }
            if (string.IsNullOrEmpty(creditNoteUpsertInputModel.Year.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyYear)
                });
            }
            if (string.IsNullOrEmpty(creditNoteUpsertInputModel.Name.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NameShouldNotBeNull)
                });
            }

            if (creditNoteUpsertInputModel.EntryDate == null || creditNoteUpsertInputModel.EntryDate.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.DateIsRequired)
                });
            }
            return validationMessages.Count <= 0;
        }
        public static bool UpsertMasterAccountValidation(MasterAccountUpsertInputModel masterAccountUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGRDValidation", "masterAccountUpsertInputModel", masterAccountUpsertInputModel, "GRD Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(masterAccountUpsertInputModel.Account))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyAccountName)
                });
            }
            return validationMessages.Count <= 0;
        }
        public static bool UpsertExpenseBookingValidation(ExpenseBookingUpsertInputModel expenseBookingUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGRDValidation", "expenseBookingUpsertInputModel", expenseBookingUpsertInputModel, "GRD Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(expenseBookingUpsertInputModel.Type))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyType)
                });
            }
            if (expenseBookingUpsertInputModel.SiteId == null || expenseBookingUpsertInputModel.SiteId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptySiteId)
                });
            }
            if (expenseBookingUpsertInputModel.Month == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyMonth)
                });
            }
            if (expenseBookingUpsertInputModel.InvoiceDate == null || expenseBookingUpsertInputModel.InvoiceDate.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyStartDate)
                });
            }
            if (expenseBookingUpsertInputModel.Term == null || expenseBookingUpsertInputModel.Term.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyTerm)
                });
            }
            if (string.IsNullOrEmpty(expenseBookingUpsertInputModel.Year.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyYear)
                });
            }

            if (expenseBookingUpsertInputModel.EntryDate == null || expenseBookingUpsertInputModel.EntryDate.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.DateIsRequired)
                });
            }
            return validationMessages.Count <= 0;
        }
        public static bool UpsertPaymentReceiptValidation(PaymentReceiptUpsertInputModel paymentReceiptUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertGRDValidation", "paymentReceiptUpsertInputModel", paymentReceiptUpsertInputModel, "GRD Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);
            if (string.IsNullOrEmpty(paymentReceiptUpsertInputModel.Term))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyType)
                });
            }
            if (paymentReceiptUpsertInputModel.SiteId == null || paymentReceiptUpsertInputModel.SiteId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptySiteId)
                });
            }
            if (paymentReceiptUpsertInputModel.Month == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyMonth)
                });
            }
            if (paymentReceiptUpsertInputModel.BankReceiptDate == null || paymentReceiptUpsertInputModel.BankReceiptDate.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyStartDate)
                });
            }
            if (paymentReceiptUpsertInputModel.Term == null || paymentReceiptUpsertInputModel.Term.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyTerm)
                });
            }
            if (string.IsNullOrEmpty(paymentReceiptUpsertInputModel.Year.ToString()))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyYear)
                });
            }
            //if (string.IsNullOrEmpty(paymentReceiptUpsertInputModel.EntryFormIds.ToString()))
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = string.Format(ValidationMessages.NotEmptyYear)
            //    });
            //}
            //if (string.IsNullOrEmpty(paymentReceiptUpsertInputModel.CreditNoteIds.ToString()))
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = string.Format(ValidationMessages.NotEmptyYear)
            //    });
            //}

            if (paymentReceiptUpsertInputModel.EntryDate == null || paymentReceiptUpsertInputModel.EntryDate.ToString() == string.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.DateIsRequired)
                });
            }
            return validationMessages.Count <= 0;
        }
    }
}
