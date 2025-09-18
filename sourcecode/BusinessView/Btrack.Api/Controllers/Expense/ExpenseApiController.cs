using Btrak.Models;
using Btrak.Models.Expenses;
using Btrak.Services.ExpenseService;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Hangfire;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.Expense
{
    public class ExpenseApiController : AuthTokenApiController
    {
        private readonly IExpenseService _expenseService;
        private BtrakJsonResult _btrakJsonResult;

        public ExpenseApiController(IExpenseService expenseService)
        {
            _expenseService = expenseService;
            _btrakJsonResult = new BtrakJsonResult();
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertMerchant)]
        public JsonResult<BtrakJsonResult> UpsertMerchant(MerchantModel merchantModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Merchant", "MerchantModel", merchantModel, "Expense Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Merchant", "MerchantModel", merchantModel, "Expense Api"));

                    List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                    Guid? merchantId = _expenseService.UpsertMerchant(merchantModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Merchant", "Expense Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info("Upsert Merchant is completed. Return Guid is : " + merchantId + "Source command is " + merchantModel);

                    return Json(new BtrakJsonResult { Data = merchantId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Merchant", "Expense Api"));

                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertMerchant", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchMerchants)]
        public JsonResult<BtrakJsonResult> SearchMerchants(SearchMerchantApiInputModel searchMerchantApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Merchants", "searchMerchantApiInputModel", searchMerchantApiInputModel, "Expense Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Merchants", "searchMerchantApiInputModel", searchMerchantApiInputModel, "Expense Api"));

                    List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                    List<MerchantModel> merchants = _expenseService.SearchMerchants(searchMerchantApiInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Merchants", "Expense Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Merchants", "Expense Api"));

                    return Json(new BtrakJsonResult { Data = merchants, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Merchants", "Expense Api"));

                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchMerchants", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetMerchantById)]
        public JsonResult<BtrakJsonResult> GetMerchantById(Guid? merchantId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Merchant By Id", "merchantId", merchantId, "Expense Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                MerchantModel merchant = _expenseService.GetMerchantById(merchantId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Merchant By Id", "Expense Api"));

                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Merchant By Id", "Expense Api"));

                return Json(new BtrakJsonResult { Data = merchant, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMerchantById", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertExpenseCategory)]
        public JsonResult<BtrakJsonResult> UpsertExpenseCategory(UpsertExpenseCategoryApiInputModel upsertExpenseCategoryApiInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Category", "upsertExpenseCategoryApiInputModel", upsertExpenseCategoryApiInputModel, "Expense Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Category", "upsertExpenseCategoryApiInputModel", upsertExpenseCategoryApiInputModel, "Expense Api"));

                    List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                    Guid? categoryId = _expenseService.UpsertExpenseCategory(upsertExpenseCategoryApiInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Expense Category", "Expense Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info("Upsert Expense category is completed. Return Guid is : " + categoryId + "Source command is " + upsertExpenseCategoryApiInputModel);

                    return Json(new BtrakJsonResult { Data = categoryId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Expense Category", "Expense Api"));

                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpenseCategory", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchExpenseCategories)]
        public JsonResult<BtrakJsonResult> SearchExpenseCategories(ExpenseCategorySearchInputModel expenseCategorySearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Expense Categories", "expenseCategorySearchInputModel", expenseCategorySearchInputModel, "Expense Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Expense Categories", "expenseCategorySearchInputModel", expenseCategorySearchInputModel, "Expense Api"));

                    List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                    List<ExpenseCategoryModel> categories = _expenseService.SearchExpenseCategories(expenseCategorySearchInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Expense Categories", "Expense Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Expense Categories", "Expense Api"));

                    return Json(new BtrakJsonResult { Data = categories, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Expense Categories", "Expense Api"));

                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExpenseCategories", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetExpenseCategoryById)]
        public JsonResult<BtrakJsonResult> GetExpenseCategoryById(Guid? categoryId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Expense CategoryById", "categoryId", categoryId, "Expense Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                ExpenseCategoryModel categories = _expenseService.GetExpenseCategoryById(categoryId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Expense CategoryById", "Expense Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Expense CategoryById", "Expense Api"));
                return Json(new BtrakJsonResult { Data = categories, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseCategoryById", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertExpenseStatus)]
        public JsonResult<BtrakJsonResult> UpsertExpenseStatus(UpsertExpenseStatusModel upsertExpenseStatusModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Status", "upsertExpenseStatusModel", upsertExpenseStatusModel, "Expense Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Status", "upsertExpenseStatusModel", upsertExpenseStatusModel, "Expense Api"));

                    List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                    Guid? statusId = _expenseService.UpsertExpenseStatus(upsertExpenseStatusModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Expense Status", "Expense Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info("Upsert Expense status is completed. Return Guid is : " + statusId + "Source command is " + upsertExpenseStatusModel);

                    return Json(new BtrakJsonResult { Data = statusId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Expense Status", "Expense Api"));

                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpenseStatus", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllExpenseStatuses)]
        public JsonResult<BtrakJsonResult> GetAllExpenseStatuses(ExpenseStatusSearchInputModel expenseStatusSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get All Expense Statuses", "expenseCategorySearchInputModel", expenseStatusSearchInputModel, "Expense Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get All Expense Statuses", "expenseCategorySearchInputModel", expenseStatusSearchInputModel, "Expense Api"));

                    var validationMessages = new List<ValidationMessage>();

                    List<ExpenseStatusModel> categories = _expenseService.GetAllExpenseStatuses(expenseStatusSearchInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Expense Statuses", "Expense Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Expense Statuses", "Expense Api"));

                    return Json(new BtrakJsonResult { Data = categories, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get All Expense Statuses", "Expense Api"));

                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllExpenseStatuses", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertExpenseReport)]
        public JsonResult<BtrakJsonResult> UpsertExpenseReport(ExpenseReportInputModel expenseReportInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Report", "expenseReportInputModel", expenseReportInputModel, "Expense Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Report", "expenseReportInputModel", expenseReportInputModel, "Expense Api"));
                    List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                    Guid? expenseReportId = _expenseService.UpsertExpenseReport(expenseReportInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Expense Report", "Expense Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info("Upsert ExpenseReport is completed. Return Guid is : " + expenseReportId + "Source command is " + expenseReportInputModel);
                    return Json(new BtrakJsonResult { Data = expenseReportId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Expense Report", "Expense Api"));

                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpenseReport", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetExpenseStatusById)]
        public JsonResult<BtrakJsonResult> GetExpenseStatusById(Guid? statusId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Expense Status By Id", "categoryId", statusId, "Expense Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                ExpenseStatusModel expenseStatus = _expenseService.GetExpenseStatusById(statusId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Expense Status By Id", "Expense Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Expense Status By Id", "Expense Api"));
                return Json(new BtrakJsonResult { Data = expenseStatus, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseStatusById", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertExpenseReportStatus)]
        public JsonResult<BtrakJsonResult> UpsertExpenseReportStatus(UpsertExpenseReportStatusModel upsertExpenseReportStatusModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Report Status", "upsertExpenseReportStatusModel", upsertExpenseReportStatusModel, "Expense Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Expense Report Status", "expenseReportInputModel", upsertExpenseReportStatusModel, "Expense Api"));
                    List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                    Guid? expenseReportStatusId = _expenseService.UpsertExpenseReportStatus(upsertExpenseReportStatusModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Expense Report Status", "Expense Api"));
                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info("Upsert ExpenseReportStatus is completed. Return Guid is : " + expenseReportStatusId + "Source command is " + upsertExpenseReportStatusModel);
                    return Json(new BtrakJsonResult { Data = expenseReportStatusId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Upsert Expense Report", "Expense Api"));

                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpenseReportStatus", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchExpenseReports)]
        public JsonResult<BtrakJsonResult> SearchExpenseReports(SearchExpenseReportsInputModel searchExpenseReportsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Search Expense Reports", "searchExpenseReportsInputModel", searchExpenseReportsInputModel, "Expense Api"));

                if (ModelState.IsValid)
                {
                    List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                    List<SearchExpensesReportOutputModel> expensesReport = _expenseService.SearchExpenseReports(searchExpenseReportsInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Expense Reports", "Expense Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Expense Reports", "Expense Api"));

                    return Json(new BtrakJsonResult { Data = expensesReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Search Expense Reports", "Expense Api"));
                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExpenseReports", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetExpenseReportById)]
        public JsonResult<BtrakJsonResult> GetExpenseReportById(Guid? expenseReportId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Expense Report ById", "expenseReportId", expenseReportId, "Expense Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                SearchExpensesReportOutputModel expenseReport = _expenseService.GetExpenseReportById(expenseReportId, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Expense Report ById", "Expense Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Expense Report ById", "Expense Api"));
                return Json(new BtrakJsonResult { Data = expenseReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseReportById", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetExpenseReportSummary)]
        public JsonResult<BtrakJsonResult> GetExpenseReportSummary()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetExpenseReportSummary", "Expense Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                ExpensesReportSummaryOutputModel expenseReport = _expenseService.GetExpenseReportSummary(LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExpenseReportSummary", "Expense Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExpenseReportSummary", "Expense Api"));
                return Json(new BtrakJsonResult { Data = expenseReport, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseReportSummary", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetExpenseReportStatuses)]
        public JsonResult<BtrakJsonResult> GetExpenseReportStatuses(ExpenseReportStatusSearchInputModel expenseReportStatusSearchInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Expense Report Statuses", "expenseReportStatusSearchInputModel", expenseReportStatusSearchInputModel, "Expense Api"));

                if (ModelState.IsValid)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Expense Report Statuses", "expenseReportStatusSearchInputModel", expenseReportStatusSearchInputModel, "Expense Api"));

                    var validationMessages = new List<ValidationMessage>();

                    List<ExpenseReportStatusModel> expenseReportStatuses = _expenseService.GetExpenseReportStatuses(expenseReportStatusSearchInputModel, LoggedInContext, validationMessages);

                    if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                    {
                        validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                        LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Expense Report Statuses", "Expense Api"));

                        return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Expense Report Statuses", "Expense Api"));

                    return Json(new BtrakJsonResult { Data = expenseReportStatuses, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Expense Report Statuses", "Expense Api"));

                return Json(new BtrakJsonResult(ModelState), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseReportStatuses", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetExpenseReportStatusById)]
        public JsonResult<BtrakJsonResult> GetExpenseReportStatusById(Guid? reportStatusId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Get Expense Report Status By Id", "categoryId", reportStatusId, "Expense Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                ExpenseReportStatusModel expenseReportStatus = _expenseService.GetExpenseReportStatusById(reportStatusId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Expense Report Status By Id", "Expense Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Expense Report Status By Id", "Expense Api"));
                return Json(new BtrakJsonResult { Data = expenseReportStatus, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseReportStatusById", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertExpense)]
        public JsonResult<BtrakJsonResult> UpsertExpense(ExpenseUpsertInputModel expenseUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertExpense", "Expense Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? expenseIdReturned = _expenseService.UpsertExpense(expenseUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertExpense", "Expense Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertExpense", "Expense Api"));

                return Json(new BtrakJsonResult { Data = expenseIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpense", "ExpenseApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ApproveOrRejectExpense)]
        public JsonResult<BtrakJsonResult> ApproveOrRejectExpense(ExpenseUpsertInputModel expenseUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ApproveOrRejectExpense", "Expense Api"));

                var validationMessages = new List<ValidationMessage>();

                Guid? expenseIdReturned = _expenseService.ApproveOrRejectExpense(expenseUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ApproveOrRejectExpense", "Expense Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ApproveOrRejectExpense", "Expense Api"));

                return Json(new BtrakJsonResult { Data = expenseIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ApproveOrRejectExpense", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchExpenses)]
        public JsonResult<BtrakJsonResult> SearchExpenses(ExpenseSearchCriteriaInputModel expenseSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchExpenses", "Expense Api"));

                if (expenseSearchCriteriaInputModel == null)
                {
                    expenseSearchCriteriaInputModel = new ExpenseSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                List<ExpenseApiReturnModel> expenses = _expenseService.SearchExpenses(expenseSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchExpenses", "Expense Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchExpenses", "Expense Api"));

                return Json(new BtrakJsonResult { Data = expenses, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExpenses", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchExpenseDownloadDetails)]
        public JsonResult<BtrakJsonResult> SearchExpenseDownloadDetails(ExpenseSearchCriteriaInputModel expenseSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchExpenseDownloadDetails", "Expense Api"));

                if (expenseSearchCriteriaInputModel == null)
                {
                    expenseSearchCriteriaInputModel = new ExpenseSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                string expenseExcelPath = _expenseService.SearchExpensesDownloadDetails(expenseSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchExpenseDownloadDetails", "Expense Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchExpenseDownloadDetails", "Expense Api"));

                return Json(new BtrakJsonResult { Data = expenseExcelPath, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExpenseDownloadDetails", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetExpenseById)]
        public JsonResult<BtrakJsonResult> GetExpenseById(Guid? expenseId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetExpenseById", "Expense Api"));

                var validationMessages = new List<ValidationMessage>();

                ExpenseApiReturnModel expenseApiReturnModel = _expenseService.GetExpenseById(expenseId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExpenseById", "Expense Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetExpenseById", "Expense Api"));

                return Json(new BtrakJsonResult { Data = expenseApiReturnModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExpenseById", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.AddMultipleExpenses)]
        public JsonResult<BtrakJsonResult> AddMultipleExpenses(List<ExpenseUpsertInputModel> expenseUpsertInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "AddMultipleExpenses", "expenseUpsertInputModel", expenseUpsertInputModel, "Expense Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<Guid?> multipleExpenses = _expenseService.AddMultipleExpenses(expenseUpsertInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Multiple Expenses", "Expense Api"));
                    return Json(_btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Add Multiple Expenses", "Expense Api"));
                return Json(new BtrakJsonResult { Data = multipleExpenses, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AddMultipleExpenses", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchExpenseHistory)]
        public JsonResult<BtrakJsonResult> SearchExpenseHistory(ExpenseHistoryModel expenseSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchExpenseHistory", "Expense Api"));

                if (expenseSearchCriteriaInputModel == null)
                {
                    expenseSearchCriteriaInputModel = new ExpenseHistoryModel();
                }

                var validationMessages = new List<ValidationMessage>();

                List<ExpenseHistoryModel> expenseHistoryDetails = _expenseService.SearchExpenseHistory(expenseSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchExpenseHistory", "Expense Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchExpenseHistory", "Expense Api"));

                return Json(new BtrakJsonResult { Data = expenseHistoryDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExpenseHistory", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DownloadOrSendPdfExpense)]
        public async Task<JsonResult<BtrakJsonResult>> DownloadOrSendPdfExpense(ExpenseMailModel expenseModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadOrSendPdfExpense", "Expense Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                string pdfUrl = await _expenseService.SendExpenseMail(expenseModel, LoggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority, "Expense Mail Template");

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadOrSendPdfExpense", "Expense Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DownloadOrSendPdfExpense", "Expense Api"));

                return Json(new BtrakJsonResult { Data = pdfUrl, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadOrSendPdfExpense", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SearchExpenseStatuses)]
        public JsonResult<BtrakJsonResult> SearchExpenseStatuses(ExpenseStatusSearchCriteriaInputModel expenseSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchExpenseStatuses", "Expense Api"));

                if (expenseSearchCriteriaInputModel == null)
                {
                    expenseSearchCriteriaInputModel = new ExpenseStatusSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                List<ExpenseStatusSearchCriteriaInputModel> expenses = _expenseService.SearchExpenseStatuses(expenseSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchExpenseStatuses", "Expense Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchExpenseStatuses", "Expense Api"));

                return Json(new BtrakJsonResult { Data = expenses, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchExpenseStatuses", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ApprovePendingExpenses)]
        public JsonResult<BtrakJsonResult> ApprovePendingExpenses(ExpenseStatusSearchCriteriaInputModel expenseSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ApprovePendingExpenses", "Expense Api"));

                if (expenseSearchCriteriaInputModel == null)
                {
                    expenseSearchCriteriaInputModel = new ExpenseStatusSearchCriteriaInputModel();
                }

                var validationMessages = new List<ValidationMessage>();

                Guid? expensesStatusId = _expenseService.ApprovePendingExpenses(expenseSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ApprovePendingExpenses", "Expense Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ApprovePendingExpenses", "Expense Api"));

                return Json(new BtrakJsonResult { Data = expensesStatusId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ApprovePendingExpenses", "ExpenseApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
