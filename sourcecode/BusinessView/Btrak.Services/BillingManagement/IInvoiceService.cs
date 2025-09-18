using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Btrak.Services.BillingManagement
{
    public interface IInvoiceService
    {
        List<InvoiceOutputModel> GetInvoices(InvoiceInputModel invoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InvoiceStatusModel> GetInvoiceStatuses(InvoiceStatusModel invoiceStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InvoiceHistoryModel> GetInvoiceHistory(InvoiceHistoryModel invoiceHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AccountTypeModel> GetAccountTypes(AccountTypeModel accountTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertInvoice(UpsertInvoiceInputModel upsertInvoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<string> DownloadOrSendPdfInvoice(InvoiceOutputModel invoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? InsertInvoiceLogPayment(InvoicePaymentLogModel invoicePaymentLogModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InvoiceGoalOutputModel> GetInvoiceGoals(InvoiceGoalInputModel invoiceGoalInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InvoiceTasksOutputModel> GetInvoiceTasks(InvoiceTasksInputModel invoiceTasksInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InvoiceItemsOutputModel> GetInvoiceItems(InvoiceItemsInputModel invoiceItemsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InvoiceProjectsOutputModel> GetInvoiceProjects(InvoiceProjectsInputModel invoiceProjectsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InvoiceTaxOutputModel> GetInvoiceTax(InvoiceTaxInputModel invoiceTaxInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid?> MultipleInvoiceDelete(MultipleInvoiceDeleteModel multipleInvoiceDeleteModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //bool? SendInvoiceEmail(Guid? invoiceId, List<ValidationMessage> validationMessages);

        //List<GetClientInvoiceOutputModel> GetClientInvoice(ClientInvoiceSearchInputModel getInvoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        //List<GetClientProjectOutputModel> GetClientProjects(ClientProjectSearchInputModel getClientProjectInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        //List<GetInvoiceStatusOutputModel> GetInvoiceStatus(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        //List<GetRecentInvoicesOutputModel> GetRecentInvoices(InvoiceSearchInputModel getInvoiceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        //List<> ( , LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        //List<> ( , LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

    }
}
