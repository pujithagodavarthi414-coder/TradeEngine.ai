using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.BillingManagementValidationHelpers;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.BillingManagement
{
    public class ExpenseService : IExpenseService
    {
        private readonly BillingExpenseRepository _billingExpenseRepository;
        private readonly IAuditService _auditService;

        public ExpenseService(BillingExpenseRepository billingExpenseRepository, IAuditService auditService)
        {
            _billingExpenseRepository = billingExpenseRepository;
            _auditService = auditService;
        }

        public Guid? UpsertExpenseCategory(UpsertExpenseCategoryInputModel upsertExpenseCategoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertExpenseCategory", "Expense Service"));

            LoggingManager.Debug(upsertExpenseCategoryInputModel.ToString());

            if (!ExpenseValidations.ValidateUpsertExpenseCategory(upsertExpenseCategoryInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            upsertExpenseCategoryInputModel.ExpenseCategoryId = _billingExpenseRepository.UpsertExpenseCategory(upsertExpenseCategoryInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertExpenseCategoryCommandId, upsertExpenseCategoryInputModel, loggedInContext);

            LoggingManager.Debug(upsertExpenseCategoryInputModel.ExpenseCategoryId?.ToString());

            return upsertExpenseCategoryInputModel.ExpenseCategoryId;
        }

        public List<ExpenseCategoryOutputModel> GetExpenseCategories(ExpenseCategoryInputModel expenseCategoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetExpenseCategories", "Expense Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExpenseCategories", "Expense Service"));

            List<ExpenseCategoryOutputModel> categoriesList = _billingExpenseRepository.GetExpenseCategories(expenseCategoryInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetExpenseCategoriesCommandId, expenseCategoryInputModel, loggedInContext);

            return categoriesList;
        }

        public Guid? UpsertExpenseMerchant(UpsertExpenseMerchantInputModel upsertExpenseMerchantInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertExpenseMerchant", "Expense Service"));

            LoggingManager.Debug(upsertExpenseMerchantInputModel.ToString());

            if (!ExpenseValidations.ValidateUpsertExpenseMerchant(upsertExpenseMerchantInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            upsertExpenseMerchantInputModel.ExpenseMerchantId = _billingExpenseRepository.UpsertExpenseMerchant(upsertExpenseMerchantInputModel, loggedInContext, validationMessages);

            upsertExpenseMerchantInputModel.MerchantBankDetailsId = _billingExpenseRepository.UpsertMerchantBankDetails(upsertExpenseMerchantInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertExpenseMerchantCommandId, upsertExpenseMerchantInputModel, loggedInContext);

            LoggingManager.Debug(upsertExpenseMerchantInputModel.ExpenseMerchantId?.ToString());

            return upsertExpenseMerchantInputModel.ExpenseMerchantId;
        }

        public List<ExpenseMerchantOutputModel> GetExpenseMerchants(ExpenseMerchantInputModel expenseMerchantInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetExpenseMerchants", "Expense Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExpenseMerchants", "Expense Service"));

            List<ExpenseMerchantOutputModel> merchantsList = _billingExpenseRepository.GetExpenseMerchants(expenseMerchantInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetExpenseMerchantsCommandId, expenseMerchantInputModel, loggedInContext);

            return merchantsList;
        }
    }
}
