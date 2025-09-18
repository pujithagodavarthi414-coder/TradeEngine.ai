using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.BillingManagement
{
    public interface IExpenseService
    {
        Guid? UpsertExpenseCategory(UpsertExpenseCategoryInputModel upsertExpenseCategoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ExpenseCategoryOutputModel> GetExpenseCategories(ExpenseCategoryInputModel expenseCategoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertExpenseMerchant(UpsertExpenseMerchantInputModel upsertExpenseMerchantInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ExpenseMerchantOutputModel> GetExpenseMerchants(ExpenseMerchantInputModel expenseMerchantInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
