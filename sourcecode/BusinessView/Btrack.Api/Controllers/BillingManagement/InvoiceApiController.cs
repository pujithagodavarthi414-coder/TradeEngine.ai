using Btrak.Models;
using Btrak.Models.BillingManagement;
using Btrak.Services.BillingManagement;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Results;
using Twilio;
using MessageResource = Twilio.Rest.Api.V2010.Account.MessageResource;

namespace BTrak.Api.Controllers.BillingManagement
{
    public class InvoiceApiController : AuthTokenApiController
    {
        private readonly IInvoiceService _invoiceService;

        public InvoiceApiController(IInvoiceService invoiceService)
        {
            _invoiceService = invoiceService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertInvoice)]
        public JsonResult<BtrakJsonResult> UpsertInvoice(UpsertInvoiceInputModel upsertInvoiceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertInvoice", "Invoice Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (upsertInvoiceInputModel == null)
                {
                    upsertInvoiceInputModel = new UpsertInvoiceInputModel();
                }

                Guid? invoices = _invoiceService.UpsertInvoice(upsertInvoiceInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInvoice", "Invoice Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertInvoice", "Invoice Api"));
                return Json(new BtrakJsonResult { Data = invoices, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertInvoice", "InvoiceApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(ValidationMessages.ExceptionUpsertInvoice), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInvoices)]
        public JsonResult<BtrakJsonResult> GetInvoices(InvoiceInputModel invoiceInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInvoices", "Invoice Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<InvoiceOutputModel> invoiceList = _invoiceService.GetInvoices(invoiceInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoices", "Invoice Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoices", "Invoice Api"));
                return Json(new BtrakJsonResult { Data = invoiceList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoices", "InvoiceApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetInvoices), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInvoiceStatuses)]
        public JsonResult<BtrakJsonResult> GetInvoiceStatuses(InvoiceStatusModel invoiceStatusModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInvoiceStatuses", "Invoice Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<InvoiceStatusModel> invoiceStatusList = _invoiceService.GetInvoiceStatuses(invoiceStatusModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceStatuses", "Invoice Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceStatuses", "Invoice Api"));
                return Json(new BtrakJsonResult { Data = invoiceStatusList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceStatuses", "InvoiceApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetInvoiceStatuses), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInvoiceHistory)]
        public JsonResult<BtrakJsonResult> GetInvoiceHistory(InvoiceHistoryModel invoiceHistoryModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInvoiceHistory", "Invoice Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<InvoiceHistoryModel> invoiceHistoryList = _invoiceService.GetInvoiceHistory(invoiceHistoryModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceHistory", "Invoice Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceHistory", "Invoice Api"));
                return Json(new BtrakJsonResult { Data = invoiceHistoryList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceHistory", "InvoiceApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetInvoiceHistory), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAccountTypes)]
        public JsonResult<BtrakJsonResult> GetAccountTypes(AccountTypeModel accountTypeModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAccountTypes", "Invoice Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<AccountTypeModel> accountTypeList = _invoiceService.GetAccountTypes(accountTypeModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAccountTypes", "Invoice Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAccountTypes", "Invoice Api"));
                return Json(new BtrakJsonResult { Data = accountTypeList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAccountTypes", "InvoiceApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetAccountTypes), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.InsertInvoiceLogPayment)]
        public JsonResult<BtrakJsonResult> InsertInvoiceLogPayment(InvoicePaymentLogModel invoicePaymentLogModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertInvoiceLogPayment", "Invoice Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                if (invoicePaymentLogModel == null)
                {
                    invoicePaymentLogModel = new InvoicePaymentLogModel();
                }

                Guid? invoicePaymentLogId = _invoiceService.InsertInvoiceLogPayment(invoicePaymentLogModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertInvoiceLogPayment", "Invoice Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertInvoiceLogPayment", "Invoice Api"));
                return Json(new BtrakJsonResult { Data = invoicePaymentLogId, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertInvoiceLogPayment", "InvoiceApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionInsertInvoiceLog), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DownloadOrSendPdfInvoice)]
        public async Task<JsonResult<BtrakJsonResult>> DownloadOrSendPdfInvoice(InvoiceOutputModel invoiceOutputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DownloadOrSendPdfInvoice", "Invoice Api"));

                var validationMessages = new List<ValidationMessage>();

                BtrakJsonResult btrakJsonResult;

                string pdfUrl = await _invoiceService.DownloadOrSendPdfInvoice(invoiceOutputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));

                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "PrintAssets", "Asset Api"));

                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "PrintAssets", "Asset Api"));

                return Json(new BtrakJsonResult { Data = pdfUrl, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DownloadOrSendPdfInvoice", "InvoiceApiController", exception.Message), exception);


                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInvoiceGoals)]
        public JsonResult<BtrakJsonResult> GetInvoiceGoals(InvoiceGoalInputModel invoiceGoalInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInvoiceGoals", "Invoice Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<InvoiceGoalOutputModel> invoiceGoalsList = _invoiceService.GetInvoiceGoals(invoiceGoalInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceGoals", "Invoice Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceGoals", "Invoice Api"));
                return Json(new BtrakJsonResult { Data = invoiceGoalsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceGoals", "InvoiceApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetInvoiceGoals), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInvoiceTasks)]
        public JsonResult<BtrakJsonResult> GetInvoiceTasks(InvoiceTasksInputModel invoiceTasksInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInvoiceTasks", "Invoice Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<InvoiceTasksOutputModel> invoiceTasksList = _invoiceService.GetInvoiceTasks(invoiceTasksInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceTasks", "Invoice Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceTasks", "Invoice Api"));
                return Json(new BtrakJsonResult { Data = invoiceTasksList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceTasks", "InvoiceApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetInvoiceTasks), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInvoiceItems)]
        public JsonResult<BtrakJsonResult> GetInvoiceItems(InvoiceItemsInputModel invoiceItemsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInvoiceItems", "Invoice Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<InvoiceItemsOutputModel> invoiceItemsList = _invoiceService.GetInvoiceItems(invoiceItemsInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceItems", "Invoice Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceItems", "Invoice Api"));
                return Json(new BtrakJsonResult { Data = invoiceItemsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceItems", "InvoiceApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetInvoiceTasks), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInvoiceProjects)]
        public JsonResult<BtrakJsonResult> GetInvoiceProjects(InvoiceProjectsInputModel invoiceProjectsInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInvoiceProjects", "Invoice Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<InvoiceProjectsOutputModel> invoiceProjectsList = _invoiceService.GetInvoiceProjects(invoiceProjectsInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceProjects", "Invoice Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceProjects", "Invoice Api"));
                return Json(new BtrakJsonResult { Data = invoiceProjectsList, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceProjects", "InvoiceApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetInvoiceProjects), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetInvoiceTax)]
        public JsonResult<BtrakJsonResult> GetInvoiceTax(InvoiceTaxInputModel invoiceTaxInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInvoiceTax", "Invoice Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<InvoiceTaxOutputModel> invoiceTax = _invoiceService.GetInvoiceTax(invoiceTaxInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceTax", "Invoice Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetInvoiceTax", "Invoice Api"));
                return Json(new BtrakJsonResult { Data = invoiceTax, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInvoiceTax", "InvoiceApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionGetInvoiceTax), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.MultipleInvoiceDelete)]
        public JsonResult<BtrakJsonResult> MultipleInvoiceDelete(MultipleInvoiceDeleteModel multipleInvoiceDeleteModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "MultipleInvoiceDelete", "Invoice Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                List<Guid?> multipleInvoiceDeleted = _invoiceService.MultipleInvoiceDelete(multipleInvoiceDeleteModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "MultipleInvoiceDelete", "Invoice Api"));
                    return Json(btrakJsonResult, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "MultipleInvoiceDelete", "Invoice Api"));
                return Json(new BtrakJsonResult { Data = multipleInvoiceDeleted, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "MultipleInvoiceDelete", "InvoiceApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(ValidationMessages.ExceptionMultipleInvoiceDelete), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route("Sms/SendStaticSms")]
        public bool SendStaticSms(string mobileNo)
        {
            try
            {
                TwilioClient.Init("ACdcc491d2772c49007b89a65f650677cc", "d4cbde0c79eb61314c2232d61a3f683d");
                mobileNo = "+" + mobileNo;
                var messageBody = "Hello and welcome to Nxusworld! Click on link to login.. https://iora-core.nxusworld.com";
                var message = MessageResource.Create(
                    body: messageBody,
                    from: new Twilio.Types.PhoneNumber("+16107561113"),
                    to: new Twilio.Types.PhoneNumber(mobileNo)
                );
                return true;
            }
            catch (Exception exception)
            {
                return false;
            }
        }

    }
}