using Btrak.Models;
using Btrak.Models.GRD;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Btrak.Services.GRD
{
    public interface IGRDService
    {
        Guid? UpsertGRD(GRDInputModel grdInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GRDSearchOutputModel> GetGRD(GRDSearchInputModel grdInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> UpsertCreditNote(CreditNoteUpsertInputModel creditNoteUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CreditNoteSearchOutputModel> GetCreditNote(CreditNoteSearchInputModel creditNoteSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertMasterAccount(MasterAccountUpsertInputModel masterAccountUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<MasterAccountSearchOutputModel> GetMasterAccounts(MasterAccountSearchInputModel masterAccountSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertExpenseBooking(ExpenseBookingUpsertInputModel expenseBookingUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ExpenseBookingSearchOutputModel> GetExpenseBookings(ExpenseBookingSearchInputModel expenseBookingSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PaymentReceiptSearchOutputModel> GetPaymentReceipts(PaymentReceiptSearchInputModel paymentReceiptSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertPaymentReceipt(PaymentReceiptUpsertInputModel paymentReceiptUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string SendCreditNoteMail(CreditNoteUpsertInputModel creditNoteUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
