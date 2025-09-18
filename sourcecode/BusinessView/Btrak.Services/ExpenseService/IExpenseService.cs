using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.Expenses;
using System.Threading.Tasks;

namespace Btrak.Services.ExpenseService
{
    public interface IExpenseService
    {
        Guid? UpsertMerchant(MerchantModel merchantModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<MerchantModel> SearchMerchants(SearchMerchantApiInputModel searchMerchantApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        MerchantModel GetMerchantById(Guid? merchantId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertExpenseCategory(UpsertExpenseCategoryApiInputModel upsertExpenseCategoryApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ExpenseCategoryModel> SearchExpenseCategories(ExpenseCategorySearchInputModel expenseCategorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ExpenseCategoryModel GetExpenseCategoryById(Guid? categoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertExpenseStatus(UpsertExpenseStatusModel upsertExpenseStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertExpenseReport(ExpenseReportInputModel expenseReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ExpenseStatusModel> GetAllExpenseStatuses(ExpenseStatusSearchInputModel expenseStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ExpenseStatusModel GetExpenseStatusById(Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertExpenseReportStatus(UpsertExpenseReportStatusModel upsertExpenseReportStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ExpenseReportStatusModel> GetExpenseReportStatuses(ExpenseReportStatusSearchInputModel expenseReportStatusSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ExpenseReportStatusModel GetExpenseReportStatusById(Guid? reportStatusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SearchExpensesReportOutputModel> SearchExpenseReports(SearchExpenseReportsInputModel searchExpenseReportsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        SearchExpensesReportOutputModel GetExpenseReportById(Guid? expenseReportId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertExpense(ExpenseUpsertInputModel expenseUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ApproveOrRejectExpense(ExpenseUpsertInputModel expenseUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ExpenseApiReturnModel GetExpenseById(Guid? expenseId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ExpenseApiReturnModel> SearchExpenses(ExpenseSearchCriteriaInputModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string SearchExpensesDownloadDetails(ExpenseSearchCriteriaInputModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ExpenseHistoryModel> SearchExpenseHistory(ExpenseHistoryModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        ExpensesReportSummaryOutputModel GetExpenseReportSummary(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid?> AddMultipleExpenses(List<ExpenseUpsertInputModel> expenseUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<string> SendExpenseMail(ExpenseMailModel expenseMailModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string siteAddress, string mailHeader);
        List<ExpenseStatusSearchCriteriaInputModel> SearchExpenseStatuses(ExpenseStatusSearchCriteriaInputModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ApprovePendingExpenses(ExpenseStatusSearchCriteriaInputModel expenseSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}