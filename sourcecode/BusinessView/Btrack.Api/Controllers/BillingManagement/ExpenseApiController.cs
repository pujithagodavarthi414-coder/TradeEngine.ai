using Btrak.Models;
using Btrak.Models.BillingManagement;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Web.Http;
using System.Web.Http.Results;
using Btrak.Services.BillingManagement;
using System.Web;

namespace BTrak.Api.Controllers.BillingManagement
{
    public class ExpenseApiController : AuthTokenApiController
    {
        private readonly IExpenseService _expenseService;

        public ExpenseApiController(IExpenseService expenseService)
        {
            _expenseService = expenseService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertExpenseCategory)]
        public JsonResult<BtrakJsonResult> UpsertExpenseCategory(UpsertExpenseCategoryInputModel upsertExpenseCategoryInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertExpenseCategory", "Expense Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (upsertExpenseCategoryInputModel == null)
                {
                    upsertExpenseCategoryInputModel = new UpsertExpenseCategoryInputModel();
                }

                Guid? expenseCategoryId = _expenseService.UpsertExpenseCategory(upsertExpenseCategoryInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertExpenseCategory", "Expense Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertExpenseCategory", "Expense Api"));
                return Json(new BtrakJsonResult { Data = expenseCategoryId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertExpenseCategory, exception);
                return Json(new BtrakJsonResult(ValidationMessages.ExceptionUpsertExpenseCategory), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetExpenseCategories)]
        public JsonResult<BtrakJsonResult> GetExpenseCategories(ExpenseCategoryInputModel expenseCategoryInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetExpenseCategories", "Expense Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ExpenseCategoryOutputModel> categoriesList = _expenseService.GetExpenseCategories(expenseCategoryInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExpenseCategories", "Expense Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExpenseCategories", "Expense Api"));
                return Json(new BtrakJsonResult { Data = categoriesList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetExpenseCategories, exception);
                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetExpenseCategories), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertExpenseMerchant)]
        public JsonResult<BtrakJsonResult> UpsertExpenseMerchant(UpsertExpenseMerchantInputModel upsertExpenseMerchantInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertExpenseMerchant", "Expense Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (upsertExpenseMerchantInputModel == null)
                {
                    upsertExpenseMerchantInputModel = new UpsertExpenseMerchantInputModel();
                }

                Guid? expenseMerchantId = _expenseService.UpsertExpenseMerchant(upsertExpenseMerchantInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertExpenseMerchant", "Expense Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertExpenseMerchant", "Expense Api"));
                return Json(new BtrakJsonResult { Data = expenseMerchantId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionUpsertExpenseMerchant, exception);
                return Json(new BtrakJsonResult(ValidationMessages.ExceptionUpsertExpenseMerchant), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetExpenseMerchants)]
        public JsonResult<BtrakJsonResult> GetExpenseMerchants(ExpenseMerchantInputModel expenseMerchantInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetExpenseMerchants", "Expense Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<ExpenseMerchantOutputModel> merchantsList = _expenseService.GetExpenseMerchants(expenseMerchantInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExpenseMerchants", "Expense Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExpenseMerchants", "Expense Api"));
                return Json(new BtrakJsonResult { Data = merchantsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(ValidationMessages.ExceptionGetExpenseMerchants, exception);
                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetExpenseMerchants), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
